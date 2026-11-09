#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 04: Web Security],
    subtitle: [API Security],
    authors: [*Marcel Schnideritsch*],
    extra: [],
    footer: [Module 04 - Web Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "Why API Security Matters")

#slide(title: "The API Security Crisis")[
  *Statistics:*
  - *83% of web traffic* is API traffic
  - *69% of API services* vulnerable to DoS attacks
  - *APIs are 200% more vulnerable* than web apps
  - *API attacks increased 400%* from 2022 to 2024
  - *60%+ of enterprises* will use GraphQL by 2027

  *Real-World Breaches:*
  - T-Mobile (2023): 37 million records
  - Optus (2022): 9.8 million records
  - Peloton (2021): All user data exposed
  - Facebook (2019): 50 million accounts
]

#slide(title: "Why APIs Are Targeted")[
  1. *Direct Database Access*: APIs often connect directly to databases
  2. *Authentication Complexity*: Token-based auth introduces new vectors
  3. *Insufficient Testing*: APIs lack same security rigor as web UIs
  4. *Documentation Exposure*: API docs reveal attack surface
  5. *Third-Party Integration*: External APIs introduce supply chain risks
  6. *Rate Limiting Gaps*: Resource exhaustion easier than traditional web
  7. *Multiple Clients*: Mobile, web, IoT all consume APIs
]

#section-slide(title: "REST API Security")

#slide(title: "REST API Fundamentals")[
  *REST (Representational State Transfer)*

  - Most common API architectural style
  - Uses HTTP methods for CRUD operations
  - Stateless (each request contains all necessary info)
  - Resource-based (`/users/123`)

  *Typical Endpoint:*
  ```http
  GET /api/v1/users/123 HTTP/1.1
  Host: api.example.com
  Authorization: Bearer eyJhbGci...
  Accept: application/json
  ```
]

#slide(title: "BOLA (Broken Object Level Authorization)")[
  #set text(size: 16pt)
  *#1 OWASP API Security Top 10:2023*

  *Vulnerable Code:*
  ```python
  @app.route('/api/users/<user_id>/profile')
  @require_authentication
  def get_profile(user_id):
      # VULNERABLE: No authorization check!
      user = User.query.get(user_id)
      return jsonify(user.to_dict())
  ```

  *Attack:*
  ```http
  # Authenticated as user 456
  GET /api/users/123/profile
  Authorization: Bearer <attacker_token>

  # Returns user 123's data!
  ```
]

#slide(title: "BOLA Prevention")[
  *Always validate authorization:*

  ```python
  @app.route('/api/users/<user_id>/profile')
  @require_authentication
  def get_profile(user_id):
      user = User.query.get(user_id)

      # Check authorization
      if user.id != current_user.id and not current_user.is_admin:
          return jsonify({'error': 'Forbidden'}), 403

      return jsonify(user.to_dict())
  ```

  *Test with different tokens for same resource ID!*
]

#slide(title: "Excessive Data Exposure")[
  #local(inset: 0.12em)[
  #split([
  *Vulnerable:*
  ```javascript
  app.get('/api/users', async (req, res) => {
      // Returns entire user object (including sensitive fields!)
      const users = await User.find({});
      res.json(users);
  });
  ```

  ], [
  *Prevention (Data Transfer Objects):*
  ```javascript
  class UserDTO {
      constructor(user) {
          this.id = user.id;
          this.username = user.username;
          this.email = user.email;
          // Explicitly exclude: password_hash, ssn, credit_card
      }
  }

  app.get('/api/users', async (req, res) => {
      const users = await User.find({});
      const dtos = users.map(u => new UserDTO(u));
      res.json(dtos);
  });
  ```
  ])
  ]
]

#slide(title: "Mass Assignment")[
  #split([
  *Vulnerable:*
  ```python
  @app.route('/api/users/<user_id>', methods=['PUT'])
  def update_user(user_id):
      user = User.query.get(user_id)

      # VULNERABLE: Updates any field from request
      for key, value in request.json.items():
          setattr(user, key, value)

      db.session.commit()
  ```

  ], [
  *Attack:*
  ```json
  {
    "username": "alice",
    "is_admin": true,
    "balance": 1000000
  }
  ```

  *Prevention:* Whitelist allowed fields!
  ])
]

#slide(title: "Rate Limiting")[
  #show raw.where(block: true): set text(size: 11pt)
  *Essential for APIs:*

  ```python
  from flask_limiter import Limiter

  limiter = Limiter(app, key_func=lambda: request.remote_addr)

  @app.route('/api/login', methods=['POST'])
  @limiter.limit("5 per minute")
  def login():
      # Only 5 login attempts per minute
      pass

  @app.route('/api/expensive-operation')
  @limiter.limit("10 per hour")
  def expensive():
      pass
  ```

  *Without rate limiting:* Brute force, DoS, resource exhaustion
]

#section-slide(title: "GraphQL Security")

#slide(title: "GraphQL Overview")[
  #set text(size: 15pt)
  *What is GraphQL?*
  - Query language for APIs
  - Client specifies exactly what data needed
  - Single endpoint (`/graphql`)
  - Flexible but introduces unique security challenges

  *Basic Query:*
  ```graphql
  query {
    user(id: 123) {
      username
      email
      posts {
        title
      }
    }
  }
  ```
]

#slide(title: "GraphQL Introspection Abuse")[
  #split([
  *Issue:* GraphQL exposes entire schema

  *Introspection Query:*
  ```graphql
  query {
    __schema {
      types {
        name
        fields {
          name
        }
      }
    }
  }
  ```

  ], [
  *Result:* Attacker learns entire API structure, including sensitive fields

  *Prevention:*
  ```javascript
  const server = new ApolloServer({
    introspection: process.env.NODE_ENV !== 'production'
  });
  ```
  ])
]

#slide(title: "GraphQL Batching Attacks")[
  #show raw.where(block: true): set text(size: 11pt)
  #set text(size: 18pt)
  *Issue:* Multiple queries in single request bypass rate limiting

  *Attack (10,000 login attempts in one request):*
  ```graphql
  [
    {"query": "mutation { login(username: \"admin\", password: \"pass1\") }"},
    {"query": "mutation { login(username: \"admin\", password: \"pass2\") }"},
    ...
    {"query": "mutation { login(username: \"admin\", password: \"pass10000\") }"}
  ]
  ```

  *Prevention:*
  ```javascript
  const armor = new ApolloArmor({
    batching: {
      enabled: true,
      maxBatchSize: 5  // Limit batched queries
    }
  });
  ```
]

#slide(title: "GraphQL Query Depth DoS")[
  #show raw.where(block: true): set text(size: 11pt)
  #local(inset: 0.12em)[
  #split([
  *Attack:* Deeply nested queries exhaust resources

  ], [
  ```graphql
  query {
    user(id: 1) {
      friends {
        friends {
          friends {
            friends {
              friends {
                friends {
                  posts {
                    comments {
                      # ... continues
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

  *Result:* Exponential database queries, server crash
  ])
  ]
]

#slide(title: "GraphQL DoS Prevention")[
  #set text(size: 18pt)
  *Depth Limiting:*
  ```javascript
  const depthLimit = require('graphql-depth-limit');

  const server = new ApolloServer({
    validationRules: [depthLimit(10)]  // Max depth: 10
  });
  ```

  *Cost Analysis:*
  ```javascript
  const { createComplexityLimitRule } = require('graphql-validation-complexity');

  const ComplexityLimitRule = createComplexityLimitRule(1000);

  const server = new ApolloServer({
    validationRules: [ComplexityLimitRule]
  });
  ```
]

#slide(title: "GraphQL Authorization")[
  #local(inset: 0.12em)[
  #split(columns: (1fr, 1.5fr), [
  *Vulnerable Resolver:*
  ```javascript
  const resolvers = {
    Query: {
      user: (parent, { id }) => {
        // NO authorization check!
        return db.User.findById(id);
      }
    }
  };
  ```

  ], [
  *Secure Resolver:*
  ```javascript
  const resolvers = {
    Query: {
      user: (parent, { id }, context) => {
        if (!context.currentUser) {
          throw new AuthenticationError('Not authenticated');
        }

        const user = db.User.findById(id);

        if (user.id !== context.currentUser.id && !context.currentUser.isAdmin) {
          throw new ForbiddenError('Not authorized');
        }

        return user;
      }
    }
  };
  ```
  ])
  ]
]

#section-slide(title: "JWT Security")

#slide(title: "JWT Structure")[
  ```
  eyJhbGci...  .  eyJzdWIi...  .  SflKxwRJ...
  ^^^^^^^^       ^^^^^^^^^^       ^^^^^^^^^^
    Header        Payload         Signature
  ```

  *Decoded:*
  ```json
  // Header
  {"alg": "HS256", "typ": "JWT"}

  // Payload
  {"sub": "1234", "name": "John", "exp": 1516242622}

  // Signature
  HMACSHA256(header + payload, secret)
  ```
]

#slide(title: "JWT Vulnerabilities")[
  *1. None Algorithm Attack:*
  ```json
  {"alg": "none", "typ": "JWT"}
  ```
  No signature required!

  *2. Weak Secret Keys:*
  ```python
  SECRET_KEY = "secret"  # Easily cracked
  ```

  *3. Missing Expiration:*
  ```json
  {"sub": "123"}  // No exp claim - valid forever!
  ```

  *4. Algorithm Confusion (HS256 vs RS256)*
]

#slide(title: "JWT Best Practices")[
  #local(inset: 0.12em)[
  #show raw.where(block: true): set text(size: 11pt)
  ```python
  import jwt
  import datetime

  def create_token(user):
      payload = {
          'sub': str(user.id),
          'username': user.username,
          'iat': datetime.datetime.utcnow(),
          'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1),
          'jti': secrets.token_urlsafe(16)  // Unique token ID
      }
      return jwt.encode(payload, SECRET_KEY, algorithm='HS256')

  def verify_token(token):
      try:
          # Explicitly whitelist algorithms
          payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
          return payload
      except jwt.ExpiredSignatureError:
          return None
      except jwt.InvalidTokenError:
          return None
  ```
  ]
]

#slide(title: "JWT Storage")[
  *WRONG (XSS vulnerable):*
  ```javascript
  localStorage.setItem('token', jwtToken);
  ```
  Any XSS can steal token!

  *BETTER (HttpOnly cookie):*
  ```javascript
  // Server sets cookie
  res.cookie('token', jwtToken, {
    httpOnly: true,      // Not accessible via JavaScript
    secure: true,        // HTTPS only
    sameSite: 'strict',  // CSRF protection
    maxAge: 3600000      // 1 hour
  });
  ```

  *HttpOnly cookies protect against XSS!*
]

#section-slide(title: "OAuth 2.0 Security")

#slide(title: "OAuth 2.0 Authorization Code Flow")[
  1. User → Client: "Login with Google"
  2. Client → Auth Server: Redirect with `client_id`, `redirect_uri`
  3. User → Auth Server: Authenticates, grants permission
  4. Auth Server → Client: Authorization code
  5. Client → Auth Server: Exchange code for token
  6. Auth Server → Client: Access token
  7. Client → Resource Server: Request with token

  *Most secure OAuth 2.0 flow*
]

#slide(title: "OAuth 2.0 Vulnerabilities")[
  *1. Redirect URI Manipulation:*
  ```python
  # VULNERABLE: Substring matching
  if 'example.com' in redirect_uri:
      return True

  # Attack: https://evil.com?url=example.com
  ```

  *2. Missing State Parameter (CSRF):*
  ```
  /authorize?client_id=...&redirect_uri=...
  # No state parameter!
  ```

  *3. Implicit Flow (Deprecated):*
  Token in URL fragment (browser history, Referer leakage)
]

#slide(title: "OAuth 2.0 Best Practices")[
  #set text(size: 18pt)
  *1. Exact Redirect URI Matching:*
  ```python
  ALLOWED_URIS = ['https://app.example.com/callback']
  if redirect_uri not in ALLOWED_URIS:
      abort(400)
  ```

  *2. Always Use State Parameter:*
  ```python
  state = secrets.token_urlsafe(32)
  session['oauth_state'] = state

  # Later validate
  if state != session.get('oauth_state'):
      abort(400)
  ```

  *3. Use PKCE (Proof Key for Code Exchange):*
  Additional protection for Authorization Code flow
]

#section-slide(title: "OWASP API Security Top 10:2023")

#slide(title: "OWASP API Top 10 - 2023")[
  1. *API1:2023* - Broken Object Level Authorization (BOLA)
  2. *API2:2023* - Broken Authentication
  3. *API3:2023* - Broken Object Property Level Authorization
  4. *API4:2023* - Unrestricted Resource Consumption
  5. *API5:2023* - Broken Function Level Authorization
  6. *API6:2023* - Unrestricted Access to Sensitive Business Flows
  7. *API7:2023* - Server-Side Request Forgery (SSRF)
  8. *API8:2023* - Security Misconfiguration
  9. *API9:2023* - Improper Inventory Management
  10. *API10:2023* - Unsafe Consumption of APIs
]

#slide(title: "Key Changes from 2019")[
  *New Categories:*
  - API6: Unrestricted Access to Sensitive Business Flows
  - API7: SSRF (elevated from web app top 10)
  - API10: Unsafe Consumption of APIs

  *Removed:*
  - Insufficient Logging and Monitoring

  *Combined:*
  - API3 now includes Excessive Data Exposure + Mass Assignment
  - API4 expanded from just rate limiting

  *Emphasis on business logic and API dependencies*
]

#slide(title: "API Security Testing")[
  #set text(size: 17pt)
  *Tools:*
  - *Burp Suite*: Intercept, test, scan APIs
  - *Postman*: API testing, automation
  - *OWASP ZAP*: Free API security scanner
  - *Custom scripts*: Python for BOLA/IDOR testing

  *What to Test:*
  - Authentication & Authorization
  - Rate limiting
  - Input validation
  - Error handling (information disclosure)
  - BOLA/IDOR vulnerabilities
  - Mass assignment
  - Business logic flaws
]

#slide(title: "API Security Checklist")[
  ✅ *Authentication*: Strong tokens, proper validation \
  ✅ *Authorization*: Object-level and function-level checks \
  ✅ *Rate Limiting*: Prevent brute force and DoS \
  ✅ *Input Validation*: Whitelist approach, reject bad data \
  ✅ *Output Filtering*: DTOs, don't expose sensitive fields \
  ✅ *HTTPS Only*: Encrypt all API traffic \
  ✅ *Security Headers*: HSTS, CSP, etc. \
  ✅ *Error Handling*: Generic messages, log details \
  ✅ *Logging & Monitoring*: Detect attacks \
  ✅ *API Documentation*: Keep accurate inventory
]

#section-slide(title: "API Security Best Practices")

#slide(title: "Defense in Depth for APIs")[
  1. *Design*: Threat modeling, secure by design
  2. *Development*: Secure coding, code review
  3. *Testing*: SAST, DAST, penetration testing
  4. *Deployment*: WAF, API gateway, rate limiting
  5. *Monitoring*: Logging, alerting, SIEM
  6. *Response*: Incident response plan
  7. *Maintenance*: Patch management, updates
  8. *Documentation*: API inventory, change management
]

#slide(title: "API Gateway Benefits")[
  #set text(size: 17pt)
  *Centralized Security:*
  - Authentication & Authorization
  - Rate limiting & throttling
  - Input validation
  - Logging & monitoring
  - API versioning
  - Protocol translation

  *Popular Solutions:*
  - Kong
  - Amazon API Gateway
  - Azure API Management
  - Apigee
  - NGINX
]

#section-slide(title: "Key Takeaways")

#slide(title: "Summary")[
  #set text(size: 18pt)
  - *API security is critical* - 83% of web traffic is APIs
  - *BOLA is #1 threat* - Always validate authorization
  - *GraphQL needs special attention* - Depth limits, cost analysis
  - *JWT must be implemented correctly* - Strong secrets, expiration, proper algorithms
  - *OAuth 2.0 needs CSRF protection* - State parameter, exact redirect URI matching
  - *Rate limiting is essential* - Prevent brute force and DoS
  - *Validate all data* - Never trust external APIs or clients
  - *Defense in depth* - Multiple layers of security
  - *Maintain API inventory* - Know what endpoints exist
  - *Test continuously* - Automated and manual testing
]

#slide(title: "Resources")[
  #set text(size: 14pt)
  *Learning:*
  - OWASP API Security Top 10:2023
  - PortSwigger API Testing Labs
  - APIsecurity.io

  *Practice:*
  - crAPI (Completely Ridiculous API)
  - VAmPI (Vulnerable API)
  - DVGA (Damn Vulnerable GraphQL App)
  - Juice Shop (includes APIs)

  *Tools:*
  - Burp Suite
  - Postman
  - OWASP ZAP
  - jwt_tool
  - GraphQL Armor
  - Arjun (endpoint discovery)
]

#title-slide(
  author: [Marcel Schnideritsch],
  title: [API Security],
  subtitle: [Module 04 - Web Security],
)
