# API Security

Modern applications rely on APIs (Application Programming Interfaces) for communication between services, mobile apps, and third-party integrations. APIs are what makes an architecture like microservices possible, and they widen the attack surface at the same time. API vulnerabilities lead to data breaches, unauthorized access, and complete system compromise.

This lecture covers the security considerations for REST APIs, GraphQL, authentication mechanisms, and the OWASP API Security Top 10.

## Why API Security Matters

**API traffic:**

- **83% of web traffic** is API traffic (Cloudflare, 2024)
- APIs now carry most application traffic, yet they are routinely
  tested less thoroughly than the user-facing web interfaces in front
  of them

**Real-World Breaches:**

1. **T-Mobile (2023)**: API vulnerability exposed 37 million customer records
2. **Optus (2022)**: API misconfiguration leaked 9.8 million Australian records
3. **Peloton (2021)**: BOLA vulnerability exposed all user data
4. **Facebook (2019)**: API flaw exposed 50 million accounts

**Why APIs Are Targeted:**

1. They often connect directly to databases
2. Token-based authentication introduces new attack vectors
3. They often lack the same security rigor as the web UIs in front of them
4. API documentation reveals the attack surface
5. External APIs bring supply chain risks with them
6. Resource exhaustion is easier than on a traditional web app when rate limits are missing

---

## REST API Security

**REST (Representational State Transfer)** is the most common API architectural style, using HTTP methods for CRUD operations. REST APIs present unique security challenges compared to traditional web applications.

### REST API Fundamentals

**Key Characteristics:**

- **Stateless**: Each request contains all necessary information
- **Resource-Based**: Operations on resources (e.g., `/users/123`)
- **HTTP Methods**: GET, POST, PUT, PATCH, DELETE
- **Standard Status Codes**: 200, 401, 403, 404, 500, etc.
- **Content Negotiation**: JSON, XML response formats

**Typical REST Endpoint:**

```http
GET /api/v1/users/123 HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Accept: application/json
```

**Response:**

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 123,
  "username": "alice",
  "email": "alice@example.com",
  "role": "user"
}
```

---

### Common REST API Vulnerabilities

#### 1. Broken Object Level Authorization (BOLA/IDOR)

**Definition**: API fails to validate that the authenticated user has permission to access the requested object.

**Example Vulnerable Endpoint:**

```python
@app.route('/api/users/<user_id>/profile')
@require_authentication
def get_user_profile(user_id):
    # VULNERABLE: No authorization check
    user = User.query.get(user_id)
    return jsonify({
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'ssn': user.ssn,  # Sensitive data!
        'salary': user.salary
    })
```

**Attack:**

```http
# Attacker is authenticated as user ID 456
GET /api/users/123/profile HTTP/1.1
Authorization: Bearer <attacker_token>

# Response: Full profile of user 123 (unauthorized access!)
```

**Prevention:**

```python
@app.route('/api/users/<user_id>/profile')
@require_authentication
def get_user_profile(user_id):
    user = User.query.get(user_id)

    # Check authorization
    if user.id != current_user.id and not current_user.is_admin:
        return jsonify({'error': 'Forbidden'}), 403

    return jsonify({
        'id': user.id,
        'username': user.username,
        'email': user.email
    })
```

**Automated BOLA Testing:**

```bash
# Use different authorization tokens for same resource
curl -H "Authorization: Bearer USER_A_TOKEN" \
     https://api.example.com/api/users/123
curl -H "Authorization: Bearer USER_B_TOKEN" \
     https://api.example.com/api/users/123

# Should fail for USER_B
```

#### 2. Excessive Data Exposure

**Definition**: API returns more data than necessary, exposing sensitive information.

**Vulnerable Code:**

```javascript
// Node.js/Express
app.get('/api/users', async (req, res) => {
    // VULNERABLE: Returns entire user object
    const users = await User.find({});
    res.json(users);
});

// Database user object contains:
// { id, username, email, password_hash, ssn, credit_card, internal_notes }
```

**Attack Response:**

```json
{
  "users": [
    {
      "id": 1,
      "username": "alice",
      "email": "alice@example.com",
      "password_hash": "$2b$10$...",
      "ssn": "123-45-6789",
      "credit_card": "4532-****-****-1234",
      "internal_notes": "VIP customer, waive fees"
    }
  ]
}
```

**Prevention (Data Transfer Objects):**

```javascript
// Define DTO (Data Transfer Object)
class UserDTO {
    constructor(user) {
        this.id = user.id;
        this.username = user.username;
        this.email = user.email;
        // Explicitly exclude sensitive fields
    }
}

app.get('/api/users', async (req, res) => {
    const users = await User.find({});

    // Map to DTOs
    const userDTOs = users.map(u => new UserDTO(u));
    res.json(userDTOs);
});
```

#### 3. Mass Assignment

**Definition**: API automatically binds client input to internal object properties without filtering, allowing attackers to modify unintended fields.

**Vulnerable Code:**

```python
# Flask endpoint
@app.route('/api/users/<user_id>', methods=['PUT'])
@require_authentication
def update_user(user_id):
    user = User.query.get(user_id)

    if user.id != current_user.id:
        return jsonify({'error': 'Forbidden'}), 403

    # VULNERABLE: Blindly updates all fields from request
    for key, value in request.json.items():
        setattr(user, key, value)

    db.session.commit()
    return jsonify({'message': 'Updated'})
```

**Attack Payload:**

```http
PUT /api/users/123 HTTP/1.1
Content-Type: application/json
Authorization: Bearer <token>

{
  "username": "alice",
  "email": "newemail@example.com",
  "is_admin": true,
  "account_balance": 1000000
}
```

**Result**: Attacker gains admin privileges and arbitrary account balance!

**Prevention (Whitelist Fields):**

```python
# Define allowed fields
ALLOWED_FIELDS = {'username', 'email', 'bio', 'avatar_url'}

@app.route('/api/users/<user_id>', methods=['PUT'])
@require_authentication
def update_user(user_id):
    user = User.query.get(user_id)

    if user.id != current_user.id:
        return jsonify({'error': 'Forbidden'}), 403

    # Only update whitelisted fields
    for key, value in request.json.items():
        if key in ALLOWED_FIELDS:
            setattr(user, key, value)

    db.session.commit()
    return jsonify({'message': 'Updated'})
```

#### 4. Lack of Rate Limiting

**Definition**: API doesn't limit the number of requests, enabling brute force, DoS, and resource exhaustion attacks.

**Attack Scenarios:**

```bash
# Brute force API key
for key in $(cat wordlist.txt); do
    curl -H "X-API-Key: $key" https://api.example.com/data
done

# Password brute force
for pass in $(cat passwords.txt); do
    curl -d '{"username":"admin","password":"'$pass'"}' \
         https://api.example.com/login
done

# Resource exhaustion
while true; do
    curl https://api.example.com/expensive-operation &
done
```

**Prevention:**

```python
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    app,
    key_func=get_remote_address,
    default_limits=["200 per day", "50 per hour"]
)

@app.route('/api/login', methods=['POST'])
@limiter.limit("5 per minute")  # Only 5 login attempts per minute
def login():
    # Login logic
    pass

@app.route('/api/expensive-operation')
@limiter.limit("10 per hour")
def expensive_operation():
    # Resource-intensive operation
    pass
```

**Advanced Rate Limiting (Token Bucket):**

```python
import time
from functools import wraps

class TokenBucket:
    def __init__(self, capacity, refill_rate):
        self.capacity = capacity
        self.tokens = capacity
        self.refill_rate = refill_rate
        self.last_refill = time.time()

    def consume(self, tokens=1):
        self._refill()
        if self.tokens >= tokens:
            self.tokens -= tokens
            return True
        return False

    def _refill(self):
        now = time.time()
        elapsed = now - self.last_refill
        self.tokens = min(self.capacity,
                         self.tokens + elapsed * self.refill_rate)
        self.last_refill = now

# Usage
buckets = {}

def rate_limit(capacity, refill_rate):
    def decorator(f):
        @wraps(f)
        def wrapped(*args, **kwargs):
            client_id = get_client_identifier()

            if client_id not in buckets:
                buckets[client_id] = TokenBucket(capacity, refill_rate)

            if not buckets[client_id].consume():
                return jsonify({'error': 'Rate limit exceeded'}), 429

            return f(*args, **kwargs)
        return wrapped
    return decorator

@app.route('/api/data')
@rate_limit(capacity=100, refill_rate=10)  # 100 tokens, refill 10/second
def get_data():
    return jsonify({'data': 'sensitive information'})
```

#### 5. API Authentication Bypass

**Common Weaknesses:**

**a) Predictable API Keys:**

```python
# VULNERABLE: Sequential API keys
def generate_api_key(user_id):
    return f"api_key_{user_id}_{int(time.time())}"

# Attacker can predict keys:
# api_key_123_1699999999
# api_key_124_1699999999
```

**b) Missing Authentication on Endpoints:**

```javascript
// VULNERABLE: Forgot to add authentication
app.get('/api/admin/users', (req, res) => {
    // No authentication check!
    const users = await User.find({});
    res.json(users);
});
```

**c) Trusting the Algorithm Named in the Token:**

```python
import jwt

# VULNERABLE: the algorithm is taken from the token's own header,
# so the attacker decides how their token gets verified.
def verify_token(token):
    header = jwt.get_unverified_header(token)
    return jwt.decode(token, SECRET_KEY, algorithms=[header['alg']])
```

Worse still is code that passes
`options={"verify_signature": False}`: that does not weaken the
check, it removes it, and every claim in the token is then
attacker-controlled.

**Prevention:**

```python
# Secure API key generation
import secrets

def generate_api_key():
    return secrets.token_urlsafe(32)  # Cryptographically secure random key

# Always require authentication
def require_api_key(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        api_key = request.headers.get('X-API-Key')

        if not api_key or not validate_api_key(api_key):
            return jsonify({'error': 'Invalid API key'}), 401

        return f(*args, **kwargs)
    return decorated_function

@app.route('/api/admin/users')
@require_api_key
def get_users():
    return jsonify(users)

# Secure JWT validation
def verify_token(token):
    try:
        # Explicitly specify allowed algorithms
        payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        return payload
    except jwt.InvalidTokenError:
        return None
```

---

### REST API Security Best Practices

#### 1. API Versioning

```url
https://api.example.com/v1/users
https://api.example.com/v2/users
```

**Benefits:**

- Deprecate insecure endpoints gradually
- Maintain backward compatibility
- Clear security policy per version

#### 2. Input Validation

```python
from marshmallow import Schema, fields, ValidationError

class UserCreateSchema(Schema):
    username = fields.Str(required=True, validate=lambda x: len(x) >= 3)
    email = fields.Email(required=True)
    age = fields.Int(validate=lambda x: 0 < x < 150)

@app.route('/api/users', methods=['POST'])
def create_user():
    schema = UserCreateSchema()

    try:
        # Validate input
        data = schema.load(request.json)
    except ValidationError as err:
        return jsonify({'errors': err.messages}), 400

    # Create user with validated data
    user = User(**data)
    db.session.add(user)
    db.session.commit()

    return jsonify({'id': user.id}), 201
```

#### 3. Security Headers for APIs

```python
@app.after_request
def set_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['Strict-Transport-Security'] = (
        'max-age=31536000; includeSubDomains'
    )

    # CORS configuration
    response.headers['Access-Control-Allow-Origin'] = (
        'https://trusted-app.com'
    )
    response.headers['Access-Control-Allow-Credentials'] = 'true'

    return response
```

#### 4. Logging and Monitoring

```python
import logging

logger = logging.getLogger(__name__)

@app.route('/api/sensitive-operation')
@require_authentication
def sensitive_operation():
    # Log security-relevant events
    logger.info(
        f"User {current_user.id} accessed sensitive operation "
        f"from {request.remote_addr}"
    )

    # Detect anomalies
    if is_suspicious_activity(current_user, request):
        logger.warning(f"Suspicious activity detected: {current_user.id}")
        alert_security_team()

    return jsonify({'status': 'success'})
```

---

## GraphQL Security

**GraphQL** is a query language for APIs that allows clients to request exactly the data they need. That flexibility also brings security problems that REST APIs do not have.

### GraphQL Fundamentals

**Basic Query:**

```graphql
query {
  user(id: 123) {
    username
    email
    posts {
      title
      content
    }
  }
}
```

**Key Differences from REST:**

- **Single Endpoint**: All queries go to `/graphql`
- **Client-Specified Queries**: Client controls data structure
- **Introspection**: Schema is discoverable
- **Flexible Relationships**: Deep nested queries possible

---

### GraphQL Vulnerabilities

#### 1. Introspection Abuse

**Definition**: GraphQL exposes its entire schema through introspection, revealing all available queries, mutations, and data types.

**Introspection Query:**

```graphql
query {
  __schema {
    types {
      name
      fields {
        name
        type {
          name
        }
      }
    }
  }
}
```

**Response:**

```json
{
  "data": {
    "__schema": {
      "types": [
        {
          "name": "User",
          "fields": [
            {"name": "id", "type": {"name": "ID"}},
            {"name": "username", "type": {"name": "String"}},
            {"name": "email", "type": {"name": "String"}},
            {"name": "ssn", "type": {"name": "String"}},
            {"name": "creditCard", "type": {"name": "String"}},
            {"name": "isAdmin", "type": {"name": "Boolean"}}
          ]
        }
      ]
    }
  }
}
```

**Risk**: Attacker learns entire API structure, including sensitive fields.

**Prevention:** Disabling introspection is hardening, not
authorization. It raises the cost of mapping the schema, but field
names can still be guessed or recovered from client bundles and
error messages, so every sensitive field still needs its own
authorization check.

```javascript
// Apollo Server - Disable introspection in production
const server = new ApolloServer({
  typeDefs,
  resolvers,
  introspection: process.env.NODE_ENV !== 'production',
  playground: process.env.NODE_ENV !== 'production'
});
```

#### 2. Batching Attacks (Authentication Bypass)

**Definition**: GraphQL allows multiple queries in a single request, enabling brute-force attacks that bypass rate limiting.

**Attack Payload:**

```json
[
  {"query":"mutation{login(username:\"admin\",password:\"p1\"){token}}"},
  {"query":"mutation{login(username:\"admin\",password:\"p2\"){token}}"},
  {"query":"mutation{login(username:\"admin\",password:\"p3\"){token}}"},
  ...
  {"query":"mutation{login(username:\"admin\",password:\"pN\"){token}}"}
]
```

**Result**: 10,000 login attempts in a single HTTP request, bypassing traditional rate limiting.

**Prevention:**

```javascript
// graphql-armor protection
const { ApolloArmor } = require('@escape.tech/graphql-armor');

const armor = new ApolloArmor({
  maxDepth: {
    enabled: true,
    n: 10  // Max query depth
  },
  costLimit: {
    enabled: true,
    maxCost: 5000  // Max query cost
  },
  batching: {
    enabled: true,
    maxBatchSize: 5  // Limit batched queries
  }
});

const server = new ApolloServer({
  ...armor.protect(),
  typeDefs,
  resolvers
});
```

#### 3. Query Depth / Complexity DoS

**Definition**: Deeply nested queries exhaust server resources, causing denial of service.

**Attack Query:**

```graphql
query {
  user(id: 1) {
    friends {
      friends {
        friends {
          friends {
            friends {
              friends {
                friends {
                  friends {
                    posts {
                      comments {
                        author {
                          friends {
                            # ... continues recursively
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
```

**Impact**: Exponential database queries, server crash, DoS.

**Prevention:**

```javascript
// Query depth limiting
const depthLimit = require('graphql-depth-limit');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [depthLimit(10)]  // Max depth: 10
});

// Query complexity analysis
const {
  createComplexityLimitRule
} = require('graphql-validation-complexity');

const ComplexityLimitRule = createComplexityLimitRule(1000, {
  onCost: (cost) => {
    console.log('Query cost:', cost);
  },
  formatErrorMessage: (cost) => {
    return `Query too complex: ${cost}. Maximum allowed: 1000`;
  }
});

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [ComplexityLimitRule]
});
```

#### 4. Authorization Bypass in Resolvers

**Vulnerable Resolver:**

```javascript
const resolvers = {
  Query: {
    // VULNERABLE: No authorization check
    user: (parent, { id }, context) => {
      return db.User.findById(id);
    },

    // VULNERABLE: Returns all users regardless of permissions
    users: () => {
      return db.User.findAll();
    }
  },

  User: {
    // VULNERABLE: Exposes sensitive field to everyone
    ssn: (user) => {
      return user.ssn;
    }
  }
};
```

**Secure Resolver:**

```javascript
const resolvers = {
  Query: {
    user: (parent, { id }, context) => {
      const { currentUser } = context;

      // Check authentication
      if (!currentUser) {
        throw new AuthenticationError('Not authenticated');
      }

      const user = db.User.findById(id);

      // Check authorization
      if (user.id !== currentUser.id && !currentUser.isAdmin) {
        throw new ForbiddenError('Not authorized');
      }

      return user;
    }
  },

  User: {
    // Field-level authorization
    ssn: (user, args, context) => {
      const { currentUser } = context;

      // Only user themselves or admin can see SSN
      if (user.id !== currentUser.id && !currentUser.isAdmin) {
        return null;  // or throw ForbiddenError
      }

      return user.ssn;
    }
  }
};
```

#### 5. Injection in GraphQL

**SQL Injection via GraphQL:**

```javascript
// VULNERABLE resolver
const resolvers = {
  Query: {
    searchUsers: (parent, { query }) => {
      // Direct SQL concatenation
      const sql = `SELECT * FROM users WHERE username LIKE '%${query}%'`;
      return db.query(sql);
    }
  }
};
```

**Attack Query:**

```graphql
query {
  searchUsers(query: "' OR '1'='1") {
    username
    email
  }
}
```

**Prevention:**

```javascript
// Use parameterized queries
const resolvers = {
  Query: {
    searchUsers: (parent, { query }) => {
      // Safe: Using ORM or parameterized query
      return db.User.findAll({
        where: {
          username: {
            [Op.like]: `%${query}%`
          }
        }
      });
    }
  }
};
```

---

### GraphQL Security Best Practices

```javascript
// Comprehensive GraphQL security setup
const { ApolloServer } = require('apollo-server');
const { ApolloArmor } = require('@escape.tech/graphql-armor');
const depthLimit = require('graphql-depth-limit');

const armor = new ApolloArmor({
  maxDepth: { enabled: true, n: 10 },
  costLimit: { enabled: true, maxCost: 5000 },
  batching: { enabled: true, maxBatchSize: 5 },
  characterLimit: { enabled: true, maxLength: 15000 }
});

const server = new ApolloServer({
  typeDefs,
  resolvers,

  // Disable introspection in production
  introspection: process.env.NODE_ENV !== 'production',

  // Apply security rules
  ...armor.protect(),
  validationRules: [depthLimit(10)],

  // Authentication context
  context: async ({ req }) => {
    const token = req.headers.authorization?.replace('Bearer ', '');
    const currentUser = await authenticateToken(token);

    return { currentUser };
  },

  // Error handling (don't expose internals)
  formatError: (error) => {
    console.error(error);

    if (process.env.NODE_ENV === 'production') {
      return new Error('Internal server error');
    }

    return error;
  }
});
```

---

## JWT Security

**JSON Web Tokens (JWT)** are the most common authentication mechanism for modern APIs. However, improper implementation can lead to critical vulnerabilities.

### JWT Structure

A JWT is three base64url segments joined by dots:

```text
  segment 1  header     eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
       "."
  segment 2  payload    eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6
                        IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ
       "."
  segment 3  signature  SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_ad
                        Qssw5c

  signature = HMAC_or_RSA( base64url(header) + "." +
                           base64url(payload) )

  The signature covers the first two segments, so neither can be
  changed without detection -- but both are only ENCODED, never
  encrypted. Anyone holding the token can read every claim, so a
  JWT payload is not a place for secrets.
```

**Decoded Structure:**

```json
// Header
{
  "alg": "HS256",
  "typ": "JWT"
}

// Payload
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022,
  "exp": 1516242622,
  "role": "user"
}

// Signature (HMAC-SHA256)
HMACSHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  secret
)
```

---

### JWT Vulnerabilities

#### 1. None Algorithm Attack

**Definition**: The JWT specification includes an `alg` value of
`none`, meaning "unsigned". Code that reads the algorithm out of the
token's own header will happily verify such a token against no
signature at all.

**Vulnerable Code:**

```python
import jwt

def verify_token(token):
    # VULNERABLE: the attacker's own header decides how their
    # token is checked.
    header = jwt.get_unverified_header(token)
    return jwt.decode(token, SECRET_KEY, algorithms=[header['alg']])
```

**Attack:**

```python
import base64
import json

# Create token with alg=none
header = {"alg": "none", "typ": "JWT"}
payload = {"sub": "123", "role": "admin"}

token = base64.urlsafe_b64encode(
    json.dumps(header).encode()).decode().rstrip('=')
token += '.'
token += base64.urlsafe_b64encode(
    json.dumps(payload).encode()).decode().rstrip('=')
token += '.'  # Empty signature

# Use token to gain admin access
```

**Prevention:**

```python
import jwt

def verify_token(token):
    try:
        # Whitelist exactly the one algorithm this key is for.
        # Listing an HMAC and an RSA algorithm together with a
        # single key is what enables the algorithm confusion
        # attack shown below.
        payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        return payload
    except jwt.InvalidTokenError:
        return None
```

#### 2. Weak Secret Keys

**Vulnerable:**

```python
# WEAK: Easily cracked
SECRET_KEY = "secret"
SECRET_KEY = "123456"
SECRET_KEY = "myapp"
```

**Cracking Weak JWT:**

```bash
# Using hashcat
hashcat -m 16500 jwt.txt wordlist.txt

# Using jwt_tool
python3 jwt_tool.py <JWT> -C -d wordlist.txt
```

**Prevention:**

```python
import secrets

# Generate strong secret key (256 bits)
SECRET_KEY = secrets.token_urlsafe(32)

# Store in environment variable, never in code
SECRET_KEY = os.getenv('JWT_SECRET_KEY')
```

#### 3. Missing or Excessive Expiration

**Vulnerable:**

```python
# No expiration - token valid forever!
payload = {
    'sub': user.id,
    'username': user.username
}
token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')
```

**Attack**: Stolen token usable indefinitely.

**Prevention:**

```python
import datetime

def create_token(user):
    now = datetime.datetime.now(datetime.timezone.utc)

    payload = {
        'sub': user.id,
        'username': user.username,
        'iat': now,                               # Issued at
        'exp': now + datetime.timedelta(hours=1)  # Expires in 1 h
    }

    token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')
    return token

# Validate expiration
def verify_token(token):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        # jwt.decode automatically validates exp claim
        return payload
    except jwt.ExpiredSignatureError:
        return None  # Token expired
    except jwt.InvalidTokenError:
        return None
```

#### 4. Algorithm Confusion (HS256 vs RS256)

**Definition**: Attacker changes algorithm from RS256 (asymmetric) to HS256 (symmetric), using public key as HMAC secret.

```text
  Intended (RS256, asymmetric)
    sign   with PRIVATE key  (server only)
    verify with PUBLIC  key  (may be published at /jwks.json)

  Confusion attack (RS256 -> HS256)
    1. attacker obtains the PUBLIC key -- it is not a secret
    2. attacker builds {"alg":"HS256"} with "role":"admin" and
       HMAC-signs it, using the public key bytes AS the secret
    3. server reads "alg" from the attacker's header, selects
       HMAC, and feeds its stored public key in as the HMAC key
    4. the HMAC matches -- the forged admin token is accepted

  Root cause: the token told the server which algorithm to use.
  Fix: the server decides, and pins one algorithm per key.
```

**Scenario:**

```python
# Server expects RS256 (RSA public/private key)
PUBLIC_KEY = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...
-----END PUBLIC KEY-----
"""

# VULNERABLE: Accepts any algorithm
def verify_token(token):
    payload = jwt.decode(token, PUBLIC_KEY)  # No algorithm specified
    return payload
```

**Attack:**

```python
import jwt

# Attacker creates token with HS256 using public key as secret
payload = {"sub": "123", "role": "admin"}
malicious_token = jwt.encode(payload, PUBLIC_KEY, algorithm='HS256')

# Server validates with public key, thinking it's HMAC secret
```

**Prevention:**

```python
# Always specify expected algorithm
def verify_token(token):
    try:
        payload = jwt.decode(token, PUBLIC_KEY, algorithms=['RS256'])
        return payload
    except jwt.InvalidTokenError:
        return None
```

#### 5. Token Storage (Client-Side)

**Vulnerable:**

```javascript
// localStorage is vulnerable to XSS
localStorage.setItem('token', jwtToken);

// Later...
fetch('/api/data', {
  headers: {
    'Authorization': `Bearer ${localStorage.getItem('token')}`
  }
});
```

**Attack**: Any XSS vulnerability can steal token from localStorage.

**Better Approach:**

```javascript
// Use HttpOnly cookies (not accessible via JavaScript)
// Server sets cookie:
res.cookie('token', jwtToken, {
  httpOnly: true,
  secure: true,  // HTTPS only
  sameSite: 'strict',
  maxAge: 3600000  // 1 hour
});

// Browser automatically sends cookie with requests
fetch('/api/data', {
  credentials: 'include'  // Include cookies
});
```

Neither option is simply "safe". `localStorage` is readable by any
injected script, so one XSS equals one stolen token. Cookies are not
readable by script, but they are sent automatically, which
reintroduces CSRF, so cookie-based API auth needs `SameSite`
plus either a CSRF token or a custom header the browser will not
send cross-site.

---

### JWT Best Practices

```python
import jwt
import datetime
import secrets

class JWTManager:
    def __init__(self):
        self.secret = os.getenv('JWT_SECRET_KEY')
        self.algorithm = 'HS256'
        self.token_expiry = datetime.timedelta(hours=1)
        self.refresh_expiry = datetime.timedelta(days=30)

    def create_access_token(self, user):
        payload = {
            'sub': str(user.id),
            'username': user.username,
            'role': user.role,
            'type': 'access',
            'iat': datetime.datetime.utcnow(),
            'exp': datetime.datetime.utcnow() + self.token_expiry,
            'jti': secrets.token_urlsafe(16)  # Unique token ID
        }

        return jwt.encode(payload, self.secret, algorithm=self.algorithm)

    def create_refresh_token(self, user):
        payload = {
            'sub': str(user.id),
            'type': 'refresh',
            'iat': datetime.datetime.utcnow(),
            'exp': datetime.datetime.utcnow() + self.refresh_expiry,
            'jti': secrets.token_urlsafe(16)
        }

        return jwt.encode(payload, self.secret, algorithm=self.algorithm)

    def verify_token(self, token, token_type='access'):
        try:
            payload = jwt.decode(
                token,
                self.secret,
                algorithms=[self.algorithm],
                options={
                    'verify_exp': True,
                    'verify_iat': True,
                    'require': ['exp', 'iat', 'sub', 'type']
                }
            )

            # Verify token type
            if payload.get('type') != token_type:
                return None

            # Check if token is revoked (check against blacklist/database)
            if self.is_token_revoked(payload.get('jti')):
                return None

            return payload

        except jwt.ExpiredSignatureError:
            return None
        except jwt.InvalidTokenError:
            return None

    def is_token_revoked(self, jti):
        # Check Redis or database for revoked tokens
        return redis_client.exists(f'revoked_token:{jti}')

    def revoke_token(self, jti, exp):
        # Store in Redis with expiration
        ttl = exp - datetime.datetime.utcnow()
        redis_client.setex(
            f'revoked_token:{jti}', int(ttl.total_seconds()), '1'
        )
```

---

## OAuth 2.0 & OpenID Connect

**OAuth 2.0** is an authorization framework that enables third-party applications to obtain limited access to a service. **OpenID Connect (OIDC)** builds on OAuth 2.0 to add authentication.

### OAuth 2.0 Flows

#### 1. Authorization Code Flow (Most Secure)

**Use Case**: Web applications with backend server

**Flow:**

```text
  FRONT CHANNEL -- everything here travels through the browser,
  so it is visible to the user and to anything on their machine.

  (1) User clicks "Log in with Provider"
        Browser ──▶ Client App

  (2) Client App redirects the browser to the Auth Server
        ?client_id &redirect_uri &scope &state &code_challenge

  (3) User authenticates and grants consent at the Auth Server

  (4) Auth Server redirects the browser back to redirect_uri
        ?code=<authorization code> &state=<echoed back>

  BACK CHANNEL -- server to server over TLS, never in the browser.

  (5) Client App  ──▶ Auth Server
        code + client_secret + code_verifier
      Auth Server ──▶ Client App
        access token (+ id_token for OIDC)

  (6) Client App   ──▶ Resource Server  Bearer <access token>
      Resource Server ──▶ Client App    protected resource

  Only the short-lived CODE crosses the browser; the TOKEN never
  does. Step 5 is where the client proves who it is -- which is
  exactly what the implicit flow skipped.
```

**Implementation:**

```python
from flask import Flask, redirect, request, session
import requests

app = Flask(__name__)

OAUTH_CONFIG = {
    'client_id': 'your_client_id',
    'client_secret': 'your_client_secret',
    'authorization_endpoint': 'https://oauth.example.com/authorize',
    'token_endpoint': 'https://oauth.example.com/token',
    'redirect_uri': 'https://yourapp.com/callback'
}

@app.route('/login')
def login():
    # Step 1: Redirect to authorization endpoint
    auth_url = (
        f"{OAUTH_CONFIG['authorization_endpoint']}"
        f"?response_type=code"
        f"&client_id={OAUTH_CONFIG['client_id']}"
        f"&redirect_uri={OAUTH_CONFIG['redirect_uri']}"
        f"&scope=openid profile email"
        f"&state={generate_state_token()}"  # CSRF protection
    )

    return redirect(auth_url)

@app.route('/callback')
def callback():
    # Step 2: Receive authorization code
    code = request.args.get('code')
    state = request.args.get('state')

    # Validate state token (CSRF protection)
    if not validate_state(state):
        return 'Invalid state', 400

    # Step 3: Exchange code for access token
    token_response = requests.post(
        OAUTH_CONFIG['token_endpoint'],
        data={
            'grant_type': 'authorization_code',
            'code': code,
            'redirect_uri': OAUTH_CONFIG['redirect_uri'],
            'client_id': OAUTH_CONFIG['client_id'],
            'client_secret': OAUTH_CONFIG['client_secret']
        }
    )

    tokens = token_response.json()
    access_token = tokens['access_token']
    id_token = tokens.get('id_token')  # OIDC

    # Step 4: Use access token to get user info
    user_info = requests.get(
        'https://oauth.example.com/userinfo',
        headers={'Authorization': f'Bearer {access_token}'}
    ).json()

    # Create session
    session['user_id'] = user_info['sub']

    return redirect('/dashboard')
```

---

### OAuth 2.0 Vulnerabilities

#### 1. Redirect URI Manipulation

**Vulnerable Configuration:**

```python
# VULNERABLE: Substring matching
ALLOWED_REDIRECT_URIS = ['https://app.example.com']

def validate_redirect_uri(redirect_uri):
    for allowed in ALLOWED_REDIRECT_URIS:
        if allowed in redirect_uri:  # WRONG!
            return True
    return False

# Attack redirect_uri:
# https://evil.com?url=https://app.example.com
# Passes validation!
```

**Attack:**

```url
https://oauth.example.com/authorize
  ?client_id=legitimate_app
  &redirect_uri=https://attacker.com?url=https://app.example.com
  &response_type=code
```

**Result**: Authorization code sent to attacker's server.

**Prevention:**

```python
# Exact match only
ALLOWED_REDIRECT_URIS = [
    'https://app.example.com/callback',
    'https://app.example.com/oauth/callback'
]

def validate_redirect_uri(redirect_uri):
    return redirect_uri in ALLOWED_REDIRECT_URIS
```

#### 2. State Parameter Missing (CSRF)

**Vulnerable Flow:**

```python
@app.route('/login')
def login():
    # VULNERABLE: No state parameter
    auth_url = (
        f"{AUTH_ENDPOINT}?client_id={CLIENT_ID}"
        f"&redirect_uri={REDIRECT_URI}"
        f"&response_type=code"
    )
    return redirect(auth_url)

@app.route('/callback')
def callback():
    code = request.args.get('code')
    # VULNERABLE: No state validation
    # Exchange code for token...
```

**Attack:**

1. Attacker initiates OAuth flow, gets authorization code
2. Attacker tricks victim into visiting: `https://app.com/callback?code=ATTACKER_CODE`
3. Victim's account linked to attacker's OAuth account

**Prevention:**

```python
import secrets

@app.route('/login')
def login():
    # Generate CSRF token
    state = secrets.token_urlsafe(32)
    session['oauth_state'] = state

    auth_url = (
        f"{AUTH_ENDPOINT}?client_id={CLIENT_ID}"
        f"&redirect_uri={REDIRECT_URI}"
        f"&response_type=code"
        f"&state={state}"  # Include state
    )
    return redirect(auth_url)

@app.route('/callback')
def callback():
    code = request.args.get('code')
    state = request.args.get('state')

    # Validate state
    if state != session.get('oauth_state'):
        return 'Invalid state', 400

    # Clear state
    session.pop('oauth_state', None)

    # Exchange code for token...
```

#### 3. Implicit Flow (Deprecated, Insecure)

**Vulnerable:**

```url
# Access token in URL fragment (bad!)
https://app.com/callback#access_token=eyJhbGci...&token_type=Bearer
```

**Issues:**

- Token exposed in browser history
- Token in URL can leak via Referer header
- No client authentication

**Prevention:** Use Authorization Code Flow with PKCE instead.

#### 4. Open Redirect via OAuth

**Scenario:**

```python
@app.route('/callback')
def callback():
    # ... get access token ...

    # VULNERABLE: Unvalidated redirect
    next_url = request.args.get('next', '/')
    return redirect(next_url)

# Attack:
# /callback?code=...&next=https://evil.com
```

---

### OAuth 2.0 Best Practices

```python
# Complete secure OAuth 2.0 implementation
from flask import Flask, redirect, request, session, abort
import requests
import secrets
import time

class OAuth2Client:
    def __init__(self, config):
        self.config = config
        self.session_key = 'oauth_state'

    def generate_auth_url(self):
        # Generate state for CSRF protection
        state = secrets.token_urlsafe(32)
        session[self.session_key] = {
            'state': state,
            'timestamp': time.time()
        }

        # Use PKCE for additional security
        code_verifier = secrets.token_urlsafe(64)
        code_challenge = self._generate_code_challenge(code_verifier)
        session['code_verifier'] = code_verifier

        params = {
            'response_type': 'code',
            'client_id': self.config['client_id'],
            'redirect_uri': self.config['redirect_uri'],
            'scope': self.config['scope'],
            'state': state,
            'code_challenge': code_challenge,
            'code_challenge_method': 'S256'
        }

        from urllib.parse import urlencode

        endpoint = self.config['authorization_endpoint']
        return f"{endpoint}?{urlencode(params)}"

    def handle_callback(self, code, state):
        # Validate state
        if not self._validate_state(state):
            abort(400, 'Invalid state')

        # Exchange code for token
        code_verifier = session.pop('code_verifier', None)

        token_data = {
            'grant_type': 'authorization_code',
            'code': code,
            'redirect_uri': self.config['redirect_uri'],
            'client_id': self.config['client_id'],
            'client_secret': self.config['client_secret'],
            'code_verifier': code_verifier
        }

        response = requests.post(
            self.config['token_endpoint'],
            data=token_data,
            timeout=10
        )

        if response.status_code != 200:
            abort(400, 'Token exchange failed')

        return response.json()

    def _validate_state(self, state):
        saved_state = session.pop(self.session_key, None)

        if not saved_state:
            return False

        # Check state matches
        if saved_state['state'] != state:
            return False

        # Check state not expired (5 minutes)
        if time.time() - saved_state['timestamp'] > 300:
            return False

        return True

    def _generate_code_challenge(self, verifier):
        import hashlib
        import base64

        digest = hashlib.sha256(verifier.encode()).digest()
        return base64.urlsafe_b64encode(digest).decode().rstrip('=')
```

---

## OWASP API Security Top 10:2023

### API1:2023 - Broken Object Level Authorization

**Covered extensively in REST API section above.**

### API2:2023 - Broken Authentication

**Examples:**

- Weak password requirements
- No rate limiting on authentication endpoints
- Missing MFA
- Predictable session tokens

**Prevention:** See JWT and OAuth sections above.

### API3:2023 - Broken Object Property Level Authorization

**Example:**

```python
# User can update their profile
@app.route('/api/users/<user_id>', methods=['PUT'])
def update_user(user_id):
    if int(user_id) != current_user.id:
        abort(403)

    # VULNERABLE: User can set any property
    for key, value in request.json.items():
        setattr(current_user, key, value)

    db.session.commit()

# Attack: {"is_admin": true, "balance": 9999999}
```

**Prevention:** Whitelist allowed fields (mass assignment prevention shown earlier).

### API4:2023 - Unrestricted Resource Consumption

**Prevention:** Rate limiting, resource quotas, pagination.

```python
@app.route('/api/search')
@limiter.limit("100 per hour")
def search():
    # Enforce pagination
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)
    per_page = min(per_page, 100)  # Hard upper bound

    results = Model.query.paginate(page=page, per_page=per_page)
    return jsonify(results)
```

### API5:2023 - Broken Function Level Authorization

**Example:**

```python
# VULNERABLE: Admin function without authorization check
@app.route('/api/admin/delete-user/<user_id>', methods=['DELETE'])
def delete_user(user_id):
    # Missing authorization check!
    User.query.filter_by(id=user_id).delete()
    db.session.commit()
    return jsonify({'status': 'deleted'})
```

**Prevention:**

```python
def require_admin(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if not current_user.is_admin:
            abort(403, 'Admin access required')
        return f(*args, **kwargs)
    return decorated

@app.route('/api/admin/delete-user/<user_id>', methods=['DELETE'])
@require_authentication
@require_admin
def delete_user(user_id):
    User.query.filter_by(id=user_id).delete()
    db.session.commit()
    return jsonify({'status': 'deleted'})
```

### API6:2023 - Unrestricted Access to Sensitive Business Flows

**Example:** Automated ticket purchasing bots

**Prevention:**

```python
# CAPTCHA for sensitive operations
@app.route('/api/tickets/purchase', methods=['POST'])
@require_authentication
@limiter.limit("5 per hour")
def purchase_ticket():
    # Verify CAPTCHA
    if not verify_captcha(request.json.get('captcha_token')):
        abort(400, 'Invalid CAPTCHA')

    # Behavioral analysis
    if is_suspicious_behavior(current_user):
        abort(429, 'Suspicious activity detected')

    # Process purchase...
```

### API7:2023 - Server-Side Request Forgery

Covered in Lecture 4 - Server-Side Vulnerabilities

### API8:2023 - Security Misconfiguration

**Examples:**

- Default credentials
- Verbose error messages
- CORS misconfiguration
- Missing security headers

**Prevention:**

```python
# Secure configuration
app.config['DEBUG'] = False
app.config['TESTING'] = False

@app.errorhandler(Exception)
def handle_error(error):
    # Don't expose stack traces
    if app.config['DEBUG']:
        return str(error), 500
    return 'Internal server error', 500

@app.after_request
def set_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['Strict-Transport-Security'] = 'max-age=31536000'

    # Restrictive CORS
    allowed_origins = ['https://app.example.com']
    origin = request.headers.get('Origin')

    if origin in allowed_origins:
        response.headers['Access-Control-Allow-Origin'] = origin
        response.headers['Access-Control-Allow-Credentials'] = 'true'

    return response
```

### API9:2023 - Improper Inventory Management

**Issue:** Unknown/undocumented API endpoints

**Prevention:**

- Maintain API documentation (OpenAPI/Swagger)
- Version APIs properly
- Decommission old API versions
- Regular API endpoint audits

```yaml
# OpenAPI specification
openapi: 3.0.0
info:
  title: My API
  version: 1.0.0
paths:
  /api/users:
    get:
      summary: List users
      security:
        - bearerAuth: []
      responses:
        '200':
          description: Success
```

### API10:2023 - Unsafe Consumption of APIs

**Issue:** Trusting third-party API responses without validation

**Example:**

```python
# VULNERABLE: Trust external API blindly
def get_user_data(user_id):
    response = requests.get(f'https://external-api.com/users/{user_id}')
    data = response.json()

    # Directly use without validation
    User.query.filter_by(id=user_id).update(data)
    db.session.commit()
```

**Prevention:**

```python
from marshmallow import Schema, fields, ValidationError

class ExternalUserSchema(Schema):
    username = fields.Str(required=True, validate=lambda x: len(x) <= 50)
    email = fields.Email(required=True)
    age = fields.Int(validate=lambda x: 0 < x < 150)

def get_user_data(user_id):
    try:
        response = requests.get(
            f'https://external-api.com/users/{user_id}',
            timeout=5  # Timeout
        )
        response.raise_for_status()

        data = response.json()

        # Validate external data
        schema = ExternalUserSchema()
        validated_data = schema.load(data)

        # Only update whitelisted fields
        User.query.filter_by(id=user_id).update({
            'username': validated_data['username'],
            'email': validated_data['email']
        })
        db.session.commit()

    except requests.RequestException:
        # Handle API failures gracefully
        pass
    except ValidationError as err:
        # Handle validation errors
        pass
```

---

## API Security Testing

### Tools

**1. Burp Suite:**

- Intercept API requests
- Test for BOLA/IDOR
- Automated scanning (Pro)

**2. Postman:**

- API testing and automation
- Collection runner for fuzzing
- Pre-request scripts for auth

**3. OWASP ZAP:**

- Free alternative to Burp
- API scanning
- Automation via CLI

**4. Custom Scripts:**

```python
# BOLA/IDOR testing script
import requests

def test_bola(base_url, token_a, token_b):
    """Test if user A can access user B's resources"""

    for user_id in range(1, 1000):
        # Request with user A's token
        response_a = requests.get(
            f'{base_url}/api/users/{user_id}/profile',
            headers={'Authorization': f'Bearer {token_a}'}
        )

        if response_a.status_code == 200:
            # Try accessing same resource with user B's token
            response_b = requests.get(
                f'{base_url}/api/users/{user_id}/profile',
                headers={'Authorization': f'Bearer {token_b}'}
            )

            if response_b.status_code == 200:
                print(f'BOLA found! User B can access user {user_id}')

# Rate limiting test
def test_rate_limiting(url, headers):
    """Test if endpoint has rate limiting"""

    for i in range(1000):
        response = requests.post(url, headers=headers)

        if response.status_code == 429:
            print(f'Rate limit hit after {i} requests')
            return

    print('WARNING: No rate limiting detected after 1000 requests!')
```

---

## Key Takeaways

1. APIs carry the bulk of modern application traffic, and API flaws are behind some of the largest breaches on record.

2. BOLA is API1:2023, the first entry on the OWASP list. Validate authorization at the object level on every request; authenticating the caller is not enough.

3. Introspection, batching, and query complexity attacks are specific to GraphQL and need controls of their own.

4. Algorithm confusion, weak secrets, and missing expiration are the usual JWT implementation mistakes.

5. OAuth 2.0 needs CSRF protection: always use the state parameter and validate redirect URIs exactly.

6. Without proper rate limits, APIs are open to brute force and DoS.

7. Never trust external APIs or client input; always validate and sanitize.

8. Combine authentication, authorization, rate limiting, input validation, and monitoring.

9. Maintain an accurate inventory of all API endpoints and versions.

10. Use automated tools and manual testing continuously to find API vulnerabilities.

---

## Hands-On Exercises

1. **REST API Security Lab**:
   - Deploy a vulnerable REST API (e.g., crAPI, VAmPI)
   - Test for BOLA/IDOR vulnerabilities
   - Exploit mass assignment
   - Implement fixes and retest

2. **GraphQL Exploitation**:
   - Set up DVGA (Damn Vulnerable GraphQL Application)
   - Perform introspection to map schema
   - Execute batching attack for brute force
   - Craft deeply nested query for DoS
   - Implement protections (depth limiting, cost analysis)

3. **JWT Attacks**:
   - Create vulnerable JWT implementation
   - Test none algorithm attack
   - Crack weak JWT secret
   - Perform algorithm confusion attack
   - Implement secure JWT handling

4. **OAuth 2.0 Security**:
   - Build OAuth 2.0 authorization server
   - Test redirect URI manipulation
   - Exploit missing state parameter (CSRF)
   - Implement PKCE flow

5. **API Security Assessment**:
   - Choose a public API or bug bounty target
   - Test OWASP API Top 10 vulnerabilities
   - Document findings in professional report
   - Submit responsible disclosure if vulnerabilities found

---

## Resources

### Official Documentation

- **OWASP API Security Top 10:2023**: <https://owasp.org/API-Security/editions/2023/en/0x11-t10/>
- **GraphQL Security**: <https://graphql.org/learn/security/>
- **JWT Best Practices**: <https://tools.ietf.org/html/rfc8725>
- **OAuth 2.0 Security**: <https://tools.ietf.org/html/rfc6749>
- **OAuth 2.0 Threat Model**: <https://tools.ietf.org/html/rfc6819>

### Practice Labs

- **PortSwigger API Testing Labs**: <https://portswigger.net/web-security/all-labs#api-testing>
- **crAPI (Completely Ridiculous API)**: <https://github.com/OWASP/crAPI>
- **VAmPI (Vulnerable API)**: <https://github.com/erev0s/VAmPI>
- **DVGA (Damn Vulnerable GraphQL App)**: <https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application>
- **Juice Shop (includes APIs)**: <https://github.com/juice-shop/juice-shop>

### Security Tools

- **Burp Suite**: <https://portswigger.net/burp>
- **Postman**: <https://www.postman.com/>
- **OWASP ZAP**: <https://www.zaproxy.org/>
- **jwt_tool**: <https://github.com/ticarpi/jwt_tool>
- **GraphQL Armor**: <https://github.com/Escape-Technologies/graphql-armor>
- **Arjun (API endpoint discovery)**: <https://github.com/s0md3v/Arjun>

### Learning Resources

- **APIsecurity.io**: <https://apisecurity.io/>
- **GraphQL Security Report 2024**: <https://escape.tech/blog/the-state-of-graphql-security-2024/>
- **JWT Security Cheat Sheet**: <https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html>
- **OAuth 2.0 Playground**: <https://www.oauth.com/playground/>

### Books

- "API Security in Action" by Neil Madden
- "Hacking APIs" by Corey Ball
- "OAuth 2 in Action" by Justin Richer and Antonio Sanso
