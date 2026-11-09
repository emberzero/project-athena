# Introduction to Web Security

## The World Wide Web

The World Wide Web is a distributed client/server information system built on top of the Internet. The two terms are often used interchangeably in everyday speech, but they are not the same thing: the Internet is the underlying network of networks, and the Web is one of the services that runs on it. The Web works on a request-response architecture: clients, typically web browsers, ask servers (web hosts) for information, and the servers answer.

![The Web](images/TheWeb.png)

**The Web Ecosystem:**

- **Clients**: Web browsers, mobile apps, APIs, curl, wget, and other HTTP clients
- **Servers**: Web servers (Apache, Nginx, IIS, Node.js), application servers, APIs
- **Infrastructure**: DNS, CDNs, load balancers, firewalls, proxies
- **Protocols**: HTTP/HTTPS, WebSockets, HTTP/2, HTTP/3 (QUIC)
- **Content**: HTML, CSS, JavaScript, images, videos, APIs (REST, GraphQL)

Multiple applications run concurrently over the Web: web browsing, email, file transfer, streaming media, real-time communication, and countless web applications. For proper communication, clients and servers must agree on application-level protocols like HTTP, FTP, SMTP, POP3, IMAP, WebSocket, and others.

## HyperText Transfer Protocol (HTTP)

HTTP (Hypertext Transfer Protocol) is the foundation of data communication on the World Wide Web. Originally designed by Tim Berners-Lee at CERN in 1989, HTTP has evolved through multiple versions to become the most widely used application protocol on the Internet.

![HTTP](images/HTTP.png)

### HTTP Fundamentals

**Key Characteristics:**

1. **Asymmetric Request-Response Protocol**
   - Client sends HTTP request to server
   - Server processes request and returns HTTP response
   - **Pull Protocol**: Client initiates and "pulls" information from server
   - Contrast with push protocols where server initiates data transfer

2. **Stateless Protocol**
   - Each request is independent and self-contained
   - Server doesn't retain information about previous requests
   - Benefits: Simplicity, scalability, reliability
   - Challenges: Requires mechanisms (cookies, sessions) to maintain state

3. **Text-Based Protocol** (HTTP/1.x)
   - Human-readable request and response messages
   - Easy to debug and understand
   - HTTP/2 and HTTP/3 use binary framing for efficiency

4. **Extensible Through Headers**
   - Headers convey metadata about request/response
   - Custom headers allow application-specific functionality
   - Negotiation of content types, encodings, languages

5. **Supports Multiple Request Methods**
   - Different methods (GET, POST, PUT, DELETE, etc.) for different operations
   - RESTful architecture leverages HTTP methods

**RFC 2616 Definition:**

RFC 2616 is quoted below because its wording is the clearest short definition of
HTTP. Note that it is no longer the current specification: it was obsoleted by
RFC 7230-7235 in 2014, and those in turn by RFC 9110-9112 in 2022.

> "The Hypertext Transfer Protocol (HTTP) is an application-level protocol for distributed, collaborative, hypermedia information systems. It is a generic, stateless protocol which can be used for many tasks beyond its use for hypertext, such as name servers and distributed object management systems, through extension of its request methods, error codes and headers."

## HTTP Request Structure

![HTTP Request](images/http_request.png)

An HTTP request has several components that together specify which resource is requested and how it should be handled.

### Request Components

#### 1. Request Line

The first line of an HTTP request contains three elements:

```http
GET /index.html HTTP/1.1
```

- **HTTP Method**: The action to perform (GET, POST, PUT, DELETE, etc.)
- **Request Target**: The path to the resource (typically a URL path)
- **HTTP Version**: The protocol version (HTTP/1.0, HTTP/1.1, HTTP/2, HTTP/3)

#### 2. HTTP Methods

HTTP defines several methods indicating the desired action:

**Safe and Idempotent Methods:**

- **GET**: Retrieve a resource
  - Safe (doesn't modify server state)
  - Idempotent (multiple identical requests have same effect as single request)
  - Parameters typically in URL query string
  - Example: `GET /api/users?id=123 HTTP/1.1`

- **HEAD**: Retrieve headers only, no body
  - Useful for checking if resource exists or getting metadata
  - Example: `HEAD /large-file.zip HTTP/1.1`

- **OPTIONS**: Discover allowed methods for a resource
  - Used in CORS preflight requests
  - Example: `OPTIONS /api/users HTTP/1.1`

**Unsafe Methods** (they are expected to change server state; some of them are
still idempotent, as noted per method):

- **POST**: Submit data to create a resource or trigger processing
  - Not idempotent (multiple requests may create multiple resources)
  - Data typically in request body
  - Example: Creating a new user account

- **PUT**: Replace/update a resource entirely
  - Idempotent (multiple identical requests have same effect)
  - Example: `PUT /api/users/123 HTTP/1.1`

- **PATCH**: Partially update a resource
  - Not necessarily idempotent
  - Example: `PATCH /api/users/123 HTTP/1.1`

- **DELETE**: Remove a resource
  - Idempotent
  - Example: `DELETE /api/users/123 HTTP/1.1`

**Less Common Methods:**

- **TRACE**: Echo back the received request (debugging, rarely enabled)
- **CONNECT**: Establish tunnel to server (used for HTTPS proxying)

#### 3. Request Headers

Headers provide additional information about the request or the client:

**Common Request Headers:**

```http
Host: example.com
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)
Accept: text/html,application/xhtml+xml,application/xml
Accept-Language: en-US,en;q=0.9
Accept-Encoding: gzip, deflate, br
Connection: keep-alive
Cookie: session_id=abc123xyz; user_pref=dark_mode
Referer: https://example.com/previous-page
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
Content-Length: 348
```

**Important Headers Explained:**

- **Host**: Required in HTTP/1.1, specifies the domain name (enables virtual hosting)
- **User-Agent**: Client software identification (browser, version, OS)
- **Accept**: Content types client can process (MIME types)
- **Accept-Language**: Preferred languages for response
- **Accept-Encoding**: Compression algorithms supported (gzip, br)
- **Connection**: Control options for current connection (keep-alive, close)
- **Cookie**: Send cookies to server
- **Referer**: URL of page that linked to current request (often misspelled, should be "Referrer")
- **Authorization**: Credentials for HTTP authentication (Basic, Bearer, etc.)
- **Content-Type**: MIME type of request body (for POST, PUT, PATCH)
- **Content-Length**: Size of request body in bytes
- **Origin**: Origin of request (used in CORS)
- **X-Forwarded-For**: Original client IP when behind proxy
- **Cache-Control**: Directives for caching mechanisms

#### 4. Request Body

For methods like POST, PUT, and PATCH, the request body contains the data being sent:

**JSON Example:**

```http
POST /api/users HTTP/1.1
Host: api.example.com
Content-Type: application/json
Content-Length: 78

{
  "username": "john_doe",
  "email": "john@example.com",
  "age": 30
}
```

**Form Data Example:**

```http
POST /submit-form HTTP/1.1
Host: example.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 45

name=John+Doe&email=john%40example.com&age=30
```

**Multipart Form Data (File Upload):**

```http
POST /upload HTTP/1.1
Host: example.com
Content-Type: multipart/form-data; boundary=----Boundary7MA4YWxkTrZu0gW
Content-Length: 1234

------Boundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="file"; filename="document.pdf"
Content-Type: application/pdf

[Binary file content]
------Boundary7MA4YWxkTrZu0gW--
```

### Complete Request Example

```http
POST /api/v1/users/login HTTP/1.1
Host: api.example.com
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36
Accept: application/json
Accept-Language: en-US,en;q=0.9
Accept-Encoding: gzip, deflate, br
Connection: keep-alive
Content-Type: application/json
Content-Length: 58
Origin: https://app.example.com
Referer: https://app.example.com/login

{
  "username": "alice",
  "password": "secretpassword123"
}
```

## HTTP Response Structure

![HTTP Response](images/http_response.png)

An HTTP response contains the server's answer to the client's request, including the requested resource or an error message.

### Response Components

#### 1. Status Line

The first line contains:

```http
HTTP/1.1 200 OK
```

- **HTTP Version**: Protocol version used
- **Status Code**: Three-digit code indicating result
- **Reason Phrase**: Human-readable description

#### 2. HTTP Status Codes

Status codes are grouped into five categories:

##### 1xx: Informational

- `100 Continue`: Server received request headers, client should send body
- `101 Switching Protocols`: Server switching protocols (e.g., upgrading to WebSocket)
- `103 Early Hints`: Used with Link header for preloading resources

##### 2xx: Success

- `200 OK`: Request successful, response contains requested data
- `201 Created`: Resource successfully created (POST requests)
- `202 Accepted`: Request accepted for processing, not yet completed
- `204 No Content`: Request successful, no content to return (DELETE requests)
- `206 Partial Content`: Partial resource returned (range requests)

##### 3xx: Redirection

- `301 Moved Permanently`: Resource permanently moved to new URL
- `302 Found`: Resource temporarily at different URL
- `303 See Other`: Response can be found at different URL using GET
- `304 Not Modified`: Resource hasn't changed since last request (caching)
- `307 Temporary Redirect`: Same as 302 but method must not change
- `308 Permanent Redirect`: Same as 301 but method must not change

##### 4xx: Client Errors

- `400 Bad Request`: Malformed request syntax
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Server understood request but refuses to authorize
- `404 Not Found`: Resource doesn't exist
- `405 Method Not Allowed`: HTTP method not supported for resource
- `408 Request Timeout`: Client didn't send request in time
- `409 Conflict`: Request conflicts with current state (e.g., duplicate username)
- `410 Gone`: Resource permanently deleted
- `413 Payload Too Large`: Request body too large
- `415 Unsupported Media Type`: Content-Type not supported
- `422 Unprocessable Entity`: Syntax correct but semantically invalid
- `429 Too Many Requests`: Rate limit exceeded

##### 5xx: Server Errors

- `500 Internal Server Error`: Generic server error
- `501 Not Implemented`: Server doesn't support functionality
- `502 Bad Gateway`: Invalid response from upstream server
- `503 Service Unavailable`: Server temporarily unavailable (maintenance, overload)
- `504 Gateway Timeout`: Upstream server didn't respond in time
- `505 HTTP Version Not Supported`: HTTP version not supported

#### 3. Response Headers

Headers provide metadata about the response:

**Common Response Headers:**

```http
HTTP/1.1 200 OK
Date: Mon, 11 Nov 2024 10:30:00 GMT
Server: nginx/1.18.0
Content-Type: text/html; charset=UTF-8
Content-Length: 3421
Content-Encoding: gzip
Connection: keep-alive
Cache-Control: public, max-age=3600
ETag: "33a64df551425fcc55e4d42a148795d9f25f89d4"
Last-Modified: Mon, 11 Nov 2024 09:00:00 GMT
Set-Cookie: session_id=abc123; HttpOnly; Secure; SameSite=Strict
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'
Access-Control-Allow-Origin: https://app.example.com
```

**Important Headers Explained:**

- **Date**: When response was generated
- **Server**: Web server software (often removed for security)
- **Content-Type**: MIME type of response body
- **Content-Length**: Size of response body in bytes
- **Content-Encoding**: Compression applied (gzip, br, deflate)
- **Connection**: Connection management (keep-alive, close)
- **Cache-Control**: Directives for caching behavior
- **ETag**: Unique identifier for resource version (caching)
- **Last-Modified**: When resource was last modified
- **Set-Cookie**: Send cookies to client
- **Location**: URL for redirects (3xx responses)
- **WWW-Authenticate**: Authentication challenge (401 responses)

**Security Headers:**

- **X-Frame-Options**: Prevent clickjacking (DENY, SAMEORIGIN)
- **X-Content-Type-Options**: Prevent MIME sniffing (nosniff)
- **X-XSS-Protection**: Legacy XSS filter (deprecated, use CSP instead)
- **Strict-Transport-Security (HSTS)**: Enforce HTTPS
- **Content-Security-Policy (CSP)**: Control resource loading
- **Access-Control-Allow-Origin**: CORS policy

#### 4. Response Body

The response body contains the actual content:

**HTML Response:**

```http
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html>
<html>
<head>
    <title>Example Page</title>
</head>
<body>
    <h1>Welcome!</h1>
</body>
</html>
```

**JSON API Response:**

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "success",
  "data": {
    "user": {
      "id": 123,
      "username": "alice",
      "email": "alice@example.com"
    }
  }
}
```

**Error Response:**

```http
HTTP/1.1 404 Not Found
Content-Type: application/json

{
  "status": "error",
  "message": "User not found",
  "code": "USER_NOT_FOUND"
}
```

## HTTP Sessions and State Management

HTTP is stateless, but web applications need to maintain state across requests. Several mechanisms exist to achieve this:

### Cookies

**Definition**: Small pieces of data stored by the browser and sent with every request to the originating server.

**Cookie Attributes:**

```http
Set-Cookie: session_id=abc123xyz;
            Domain=example.com;
            Path=/;
            Expires=Wed, 11 Nov 2025 10:30:00 GMT;
            Max-Age=31536000;
            Secure;
            HttpOnly;
            SameSite=Strict
```

**Cookie Attributes Explained:**

- **Domain**: Which hosts receive the cookie
  - `Domain=example.com` sends it to `example.com` *and every subdomain*
  - A leading dot (`.example.com`) is ignored by modern browsers and has the
    same effect; it is not a way to broaden or narrow scope
  - Omitting `Domain` is the stricter choice: a host-only cookie, sent back
    only to the exact host that set it
  - Note that cookies ignore scheme and port, so they are not origin-scoped

- **Path**: URL path cookie applies to
  - `/` applies to entire site
  - `/admin` only for admin section

- **Expires**: Absolute expiration date/time
- **Max-Age**: Relative expiration in seconds (takes precedence over Expires)

- **Secure**: Cookie only sent over HTTPS
  - Critical for sensitive cookies
  - Prevents interception on HTTP

- **HttpOnly**: Cookie not accessible via JavaScript
  - Prevents XSS attacks from stealing cookies
  - Still sent with HTTP requests

- **SameSite**: CSRF protection
  - `Strict`: Never sent on cross-site requests
  - `Lax`: Sent on top-level navigation (GET)
  - `None`: Always sent (requires Secure attribute)

**Cookie Security Best Practices:**

1. Always use `Secure` attribute for sensitive cookies
2. Always use `HttpOnly` for session cookies
3. Set appropriate `SameSite` policy
4. Use short expiration times for sensitive sessions
5. Generate cryptographically random session IDs
6. Regenerate session ID after login
7. Clear cookies on logout

### Session Management

**Server-Side Sessions:**

1. **Session Creation**:
   - User authenticates (login)
   - Server generates unique session ID
   - Server stores session data (in-memory, database, Redis)
   - Server sends session ID to client as cookie

2. **Session Usage**:
   - Client sends session ID cookie with each request
   - Server looks up session data using session ID
   - Server authorizes request based on session

3. **Session Termination**:
   - User logs out: the server deletes the session data *server-side*; clearing
     the cookie in the browser is not enough
   - Session expires: automatic cleanup after an idle and an absolute timeout
   - Binding a session to the client IP or User-Agent is sometimes suggested as
     anti-hijacking defence, but it is weak: mobile clients change IP
     constantly, and the User-Agent is supplied by the attacker along with the
     stolen cookie. The defences that actually work are HTTPS everywhere,
     `HttpOnly`, short lifetimes, and rotating the session ID on privilege
     change

**Example Session Flow:**

```http
# 1. User logs in
POST /login HTTP/1.1
Content-Type: application/json

{"username": "alice", "password": "secret"}

# 2. Server creates session, sends cookie
HTTP/1.1 200 OK
Set-Cookie: SESSIONID=a1b2c3d4e5f6; HttpOnly; Secure; SameSite=Strict

# 3. Subsequent requests include cookie
GET /dashboard HTTP/1.1
Cookie: SESSIONID=a1b2c3d4e5f6

# 4. Server validates session, authorizes request
HTTP/1.1 200 OK
...
```

**Token-Based Authentication** (JWT, OAuth):

Instead of server-side sessions, modern APIs often use tokens:

```http
# 1. User logs in
POST /api/auth/login HTTP/1.1
{"username": "alice", "password": "secret"}

# 2. Server returns JWT token
HTTP/1.1 200 OK
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600
}

# 3. Client includes token in Authorization header
GET /api/users/me HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# 4. Server validates token, authorizes request
HTTP/1.1 200 OK
{"id": 123, "username": "alice"}
```

### Session Security Concerns

**Session Hijacking:**

- Attacker steals session ID
- Uses stolen ID to impersonate victim
- **Prevention**: HTTPS, HttpOnly, SameSite, session binding

**Session Fixation:**

- Attacker sets victim's session ID
- Victim authenticates with attacker-known ID
- **Prevention**: Regenerate session ID after login

**Cross-Site Request Forgery (CSRF):**

- Attacker tricks victim's browser into making requests
- Browser automatically includes session cookies
- **Prevention**: CSRF tokens, SameSite cookies

## Modern HTTP Versions

The three versions in use today carry the same HTTP semantics (the same
methods, headers and status codes) over increasingly different transports:

```text
  HTTP/1.1              HTTP/2                HTTP/3
  +----------------+    +----------------+    +----------------+
  | HTTP, as text  |    | HTTP, binary   |    | HTTP, binary   |
  | one request    |    | framing,       |    | framing,       |
  | per connection |    | multiplexed    |    | multiplexed    |
  | at a time      |    | streams        |    | streams        |
  +----------------+    +----------------+    +----------------+
  | TLS (optional) |    | TLS (optional  |    | QUIC, with     |
  |                |    | in the spec,   |    | TLS 1.3 built  |
  |                |    | required by    |    | into the       |
  |                |    | every browser) |    | transport      |
  +----------------+    +----------------+    +----------------+
  | TCP            |    | TCP            |    | UDP            |
  +----------------+    +----------------+    +----------------+
   Head-of-line         HOL blocking          No HOL blocking:
   blocking per         pushed down into       QUIC streams are
   connection           TCP: one lost          independent
                        packet stalls
                        every stream
```

### HTTP/1.1 (1997)

**Features:**

- Persistent connections (Connection: keep-alive)
- Pipelining (send multiple requests without waiting)
- Chunked transfer encoding
- Additional cache control mechanisms
- Host header (virtual hosting support)

**Limitations:**

- Head-of-line blocking (requests must complete in order)
- No multiplexing (one request per connection at a time)
- Verbose headers (repeated in every request)
- No server push

### HTTP/2 (2015)

**Major Improvements:**

1. **Binary Protocol**: Binary framing instead of text
   - More efficient to parse
   - Less error-prone

2. **Multiplexing**: Multiple concurrent requests over single connection
   - Eliminates head-of-line blocking at application layer
   - Better utilization of connections

3. **Header Compression (HPACK)**: Reduces overhead
   - Significant bandwidth savings
   - Especially important for mobile

4. **Server Push**: Server can proactively send resources
   - Send CSS/JS before browser requests them
   - In practice this failed: it was hard to avoid pushing resources the
     client already had cached, and Chrome disabled it by default in 2022.
     The `103 Early Hints` response is the replacement

5. **Stream Prioritization**: Specify resource importance
   - Critical resources loaded first

**Security:**

- Requires HTTPS in practice (though not in spec)
- Better security due to HTTPS requirement

### HTTP/3 (2022)

**Based on QUIC Protocol:**

1. **UDP Instead of TCP**:
   - Eliminates TCP head-of-line blocking
   - Faster connection establishment (0-RTT, 1-RTT)
   - Better performance on lossy networks

2. **Built-in Encryption**: Always encrypted (TLS 1.3)

3. **Connection Migration**: Survives IP address changes
   - Important for mobile devices

4. **Improved Performance**:
   - Lower latency
   - Better for video streaming, gaming
   - Resilient to packet loss

**Adoption:**

- Growing support in browsers and servers
- Particularly beneficial for mobile users

## HTTPS (HTTP Secure)

### HTTPS = HTTP + TLS/SSL

**Purpose:**

- **Confidentiality**: Encrypt data in transit
- **Integrity**: Detect tampering
- **Authentication**: Verify server identity

**TLS Handshake (Simplified):**

```text
  Client                                           Server
    |                                                 |
    | 1. ClientHello                                  |
    |    TLS versions, cipher suites, SNI, random     |
    | ----------------------------------------------> |
    |                                                 |
    | 2. ServerHello + Certificate (+ key share)      |
    | <---------------------------------------------- |
    |                                                 |
    | 3. Verify the certificate locally:              |
    |    chain to a trusted CA, name match, validity, |
    |    revocation. No message is sent in this step  |
    |    -- which is why a client that skips it sees  |
    |    no error at all.                             |
    |                                                 |
    | 4. Key agreement (ECDHE)                        |
    | <---------------------------------------------> |
    |                                                 |
    | 5. Both sides derive the same session keys      |
    |                                                 |
    | 6. HTTP request / response, now encrypted       |
    | <=============================================> |
```

1. Client sends "Client Hello" (supported cipher suites, TLS version)
2. Server sends "Server Hello" (chosen cipher suite, certificate)
3. Client verifies certificate
4. Key exchange (Diffie-Hellman or RSA)
5. Generate session keys
6. Begin encrypted communication

**Certificate Verification:**

- Certificate signed by trusted Certificate Authority (CA)
- Domain matches certificate Common Name or SAN
- Certificate not expired
- Certificate not revoked (CRL, OCSP)

**Benefits:**

- Protection against eavesdropping
- Protection against man-in-the-middle attacks
- Required for modern web features (Service Workers, WebRTC)
- SEO benefits (Google prefers HTTPS)
- User trust (browser shows padlock)

**Security Headers for HTTPS:**

```http
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

- Forces browser to always use HTTPS
- Prevents downgrade attacks
- `preload`: Include in browser's HSTS preload list

## URL Structure

Understanding URLs is fundamental to web security:

```url
https://user:pass@www.example.com:443/path/page?query=value&foo=bar#sec
```

**Components:**

- **Scheme**: `https://` (protocol)
- **Credentials**: `user:pass@` (rarely used, security risk)
- **Host**: `www.example.com` (domain or IP)
- **Port**: `:443` (default 80 for HTTP, 443 for HTTPS)
- **Path**: `/path/page` (resource location)
- **Query**: `?query=value&foo=bar` (parameters)
- **Fragment**: `#sec` (client-side only, not sent to server)

**URL Encoding:**

Special characters must be percent-encoded:

- Space: `%20` (or `+`, but *only* inside
  `application/x-www-form-urlencoded` data; in a path, `+` is a literal
  plus sign)
- `&`: `%26`
- `=`: `%3D`
- `/`: `%2F`

Example: `hello world` → `hello%20world`

## Key Takeaways

- HTTP is the foundation of web communication
- HTTP is stateless; cookies and sessions provide state
- Understanding HTTP structure is critical for security testing
- Headers control behavior and security
- Status codes indicate request outcome
- Modern HTTP versions (HTTP/2, HTTP/3) improve performance
- HTTPS encrypts communication and verifies server identity
- Session management has direct security consequences
- Cookie attributes (Secure, HttpOnly, SameSite) provide security

## Security Implications

**Why Understanding HTTP Matters for Security:**

1. **Attack Surface**: Every HTTP endpoint is potential attack vector
2. **Input Validation**: All HTTP inputs (headers, body, cookies) must be validated
3. **Authentication**: Session management must be secure
4. **Encryption**: Sensitive data requires HTTPS
5. **Headers**: Security headers provide defense-in-depth
6. **Methods**: Unexpected methods can expose vulnerabilities
7. **Status Codes**: Information disclosure through error messages
8. **Cookies**: Session hijacking, CSRF, XSS all involve cookies

## Resources

### Official Specifications

- RFC 2616: HTTP/1.1 (original): <https://www.rfc-editor.org/rfc/rfc2616>
- RFC 7230-7235: HTTP/1.1 (updated): <https://www.rfc-editor.org/rfc/rfc7230>
- RFC 7540: HTTP/2: <https://www.rfc-editor.org/rfc/rfc7540>
- RFC 9114: HTTP/3: <https://www.rfc-editor.org/rfc/rfc9114>

### Learning Resources

- MDN Web Docs - HTTP: <https://developer.mozilla.org/en-US/docs/Web/HTTP>
- HTTP Basics Tutorial: <https://www3.ntu.edu.sg/home/ehchua/programming/webprogramming/http_basics.html>
- HTTP Overview (MDN): <https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview>
- HTTP/2 Explained: <https://http2-explained.haxx.se/>

### Security Resources

- OWASP Testing Guide: <https://owasp.org/www-project-web-security-testing-guide/>
- PortSwigger Web Security Academy: <https://portswigger.net/web-security>
- HTTP Security Headers: <https://securityheaders.com/>

### Tools for HTTP Analysis

- **Burp Suite**: Web application security testing
- **OWASP ZAP**: Free security scanner
- **curl**: Command-line HTTP client
- **Postman**: API testing tool
- **Browser DevTools**: Network tab for inspection
- **Wireshark**: Packet analysis
