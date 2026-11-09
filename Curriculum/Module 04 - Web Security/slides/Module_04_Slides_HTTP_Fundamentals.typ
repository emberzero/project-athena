#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 04: Web Security],
    subtitle: [HTTP/HTTPS Fundamentals],
    authors: [*Marcel Schnideritsch*],
    extra: [],
    footer: [Module 04 - Web Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "The World Wide Web")

#slide(title: "What is the Web?")[
  - Massive distributed client/server information system
  - Request-response architecture
  - Clients: Browsers, mobile apps, APIs, command-line tools
  - Servers: Web servers, application servers, APIs
  - Infrastructure: DNS, CDNs, load balancers, proxies, firewalls
  - Protocols: HTTP/HTTPS, WebSockets, HTTP/2, HTTP/3
]

#slide(title: "Web Ecosystem Components")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 5mm,
  )[
    *Clients*
    - Web browsers
    - Mobile applications
    - API consumers
    - curl, wget
  ][
    *Servers*
    - Apache, Nginx
    - Node.js, IIS
    - Application servers
    - REST/GraphQL APIs
  ]

  #v(1em)

  *Content Types*
  - HTML, CSS, JavaScript
  - Images, videos, media
  - APIs (REST, GraphQL, SOAP)
]

#section-slide(title: "HTTP Protocol")

#slide(title: "HTTP: Hypertext Transfer Protocol")[
  *Key Characteristics:*

  - Asymmetric Request-Response Protocol
  - Stateless (each request is independent)
  - Text-based (HTTP/1.x, human-readable)
  - Extensible through headers
  - Multiple request methods (GET, POST, PUT, DELETE)
  - Client "pulls" information from server
]

#slide(title: "HTTP Request Structure")[
  ```http
  GET /index.html HTTP/1.1
  Host: example.com
  User-Agent: Mozilla/5.0
  Accept: text/html
  Accept-Language: en-US
  Cookie: session_id=abc123
  Authorization: Bearer eyJhbGci...

  [Request Body for POST/PUT]
  ```

  *Components:*
  1. Request line (method, path, version)
  2. Headers (metadata)
  3. Body (optional, for POST/PUT)
]

#slide(title: "HTTP Methods")[
  #table(
    columns: (auto, auto, auto),
    inset: 8pt,
    stroke: 0.5pt,
    [*Method*], [*Purpose*], [*Safe/Idempotent*],
    [GET], [Retrieve resource], [Safe, Idempotent],
    [POST], [Create resource], [Not idempotent],
    [PUT], [Replace resource], [Idempotent],
    [PATCH], [Partial update], [Not necessarily],
    [DELETE], [Remove resource], [Idempotent],
    [HEAD], [Get headers only], [Safe, Idempotent],
    [OPTIONS], [Allowed methods], [Safe, Idempotent],
  )
]

#slide(title: "Important HTTP Headers")[
  #set text(size: 18pt)
  *Request Headers:*
  - `Host`: Domain name (required in HTTP/1.1)
  - `User-Agent`: Client software identification
  - `Authorization`: Authentication credentials
  - `Cookie`: Send cookies to server
  - `Content-Type`: Type of request body
  - `Origin`: CORS origin header

  *Response Headers:*
  - `Set-Cookie`: Send cookies to client
  - `Content-Type`: Type of response body
  - `Cache-Control`: Caching directives
  - `Location`: Redirect URL
]

#slide(title: "HTTP Response Structure")[
  #set text(size: 18pt)
  ```http
  HTTP/1.1 200 OK
  Date: Mon, 01 Dec 2025 10:30:00 GMT
  Server: nginx/1.18.0
  Content-Type: text/html; charset=UTF-8
  Content-Length: 3421
  Set-Cookie: session_id=xyz789; HttpOnly; Secure
  X-Frame-Options: DENY

  <!DOCTYPE html>
  <html>...</html>
  ```

  *Components:*
  1. Status line (version, code, reason)
  2. Headers (metadata)
  3. Body (content)
]

#slide(title: "HTTP Status Codes")[
  #table(
    columns: (auto, auto),
    inset: 8pt,
    stroke: 0.5pt,
    [*Code*], [*Meaning*],
    [1xx], [Informational (100 Continue)],
    [2xx], [Success (200 OK, 201 Created)],
    [3xx], [Redirection (301, 302, 304)],
    [4xx], [Client Error (400, 401, 403, 404)],
    [5xx], [Server Error (500, 502, 503)],
  )
]

#section-slide(title: "Sessions & State Management")

#slide(title: "HTTP is Stateless")[
  *Problem:*
  - HTTP doesn't remember previous requests
  - Each request is independent
  - Web applications need to maintain state

  *Solutions:*
  - Cookies
  - Session tokens
  - JWT (JSON Web Tokens)
  - Local/Session Storage (client-side)
]

#slide(title: "Cookies")[
  ```http
  Set-Cookie: session_id=abc123;
              Domain=example.com;
              Path=/;
              Expires=Wed, 11 Nov 2026 10:30:00 GMT;
              Secure;
              HttpOnly;
              SameSite=Strict
  ```

  *Key Attributes:*
  - `Secure`: HTTPS only
  - `HttpOnly`: Not accessible via JavaScript
  - `SameSite`: CSRF protection (Strict/Lax/None)
  - `Domain`: Which domains can receive cookie
  - `Path`: URL path cookie applies to
]

#slide(title: "Session Management Flow")[
  1. *User logs in*
     - Sends credentials to server

  2. *Server creates session*
     - Generates unique session ID
     - Stores session data (in-memory, Redis, database)

  3. *Server sends session cookie*
     - `Set-Cookie: SESSIONID=abc123; HttpOnly; Secure`

  4. *Client sends cookie with requests*
     - Browser automatically includes cookie

  5. *Server validates session*
     - Looks up session data using session ID
]

#slide(title: "Session Security Concerns")[
  *Threats:*
  - *Session Hijacking*: Attacker steals session ID
  - *Session Fixation*: Attacker sets victim's session ID
  - *CSRF*: Cross-Site Request Forgery

  *Prevention:*
  - Use HTTPS (encrypt communication)
  - `HttpOnly` flag (prevent XSS theft)
  - `SameSite` attribute (CSRF protection)
  - Regenerate session ID after login
  - Bind session to IP/User-Agent
  - Short session timeout
]

#section-slide(title: "Modern HTTP Versions")

#slide(title: "HTTP/1.1 vs HTTP/2 vs HTTP/3")[
  #table(
    columns: (auto, auto, auto, auto),
    inset: 6pt,
    stroke: 0.5pt,
    align: left,
    [*Feature*], [*HTTP/1.1*], [*HTTP/2*], [*HTTP/3*],
    [Protocol], [Text-based], [Binary], [Binary],
    [Transport], [TCP], [TCP], [UDP (QUIC)],
    [Multiplexing], [❌], [✅], [✅],
    [Header Compression], [❌], [✅ (HPACK)], [✅ (QPACK)],
    [Server Push], [❌], [✅], [✅],
    [Encryption], [Optional], [De facto required], [Always (TLS 1.3)],
  )
]

#slide(title: "HTTP/2 Improvements")[
  *Key Features:*
  - *Binary Protocol*: More efficient to parse
  - *Multiplexing*: Multiple concurrent requests over single connection
  - *Header Compression*: HPACK reduces overhead
  - *Server Push*: Server sends resources before requested
  - *Stream Prioritization*: Critical resources loaded first

  *Benefits:*
  - Faster page loads
  - Reduced latency
  - Better mobile performance
]

#slide(title: "HTTP/3 (QUIC)")[
  *Built on UDP instead of TCP:*
  - Eliminates TCP head-of-line blocking
  - Faster connection establishment (0-RTT, 1-RTT)
  - Better performance on lossy networks
  - Connection migration (survives IP changes)

  *Security:*
  - Always encrypted (TLS 1.3 built-in)
  - No plaintext HTTP/3

  *Adoption:*
  - Growing browser and server support
  - Particularly beneficial for mobile users
]

#section-slide(title: "HTTPS (HTTP Secure)")

#slide(title: "HTTPS = HTTP + TLS/SSL")[
  *Purpose:*
  - *Confidentiality*: Encrypt data in transit
  - *Integrity*: Detect tampering
  - *Authentication*: Verify server identity

  *How it works:*
  1. Client connects to server
  2. TLS handshake (negotiate encryption)
  3. Certificate verification
  4. Establish encrypted connection
  5. Encrypted HTTP communication
]

#slide(title: "TLS Handshake (Simplified)")[
  1. *Client Hello*
     - Supported cipher suites, TLS version

  2. *Server Hello*
     - Chosen cipher suite, certificate

  3. *Certificate Verification*
     - Client verifies certificate with CA

  4. *Key Exchange*
     - Diffie-Hellman or RSA

  5. *Session Keys Generated*
     - Both parties derive symmetric keys

  6. *Encrypted Communication Begins*
]

#slide(title: "Certificate Verification")[
  *Requirements:*
  - Certificate signed by trusted Certificate Authority (CA)
  - Domain matches certificate Common Name or SAN
  - Certificate not expired
  - Certificate not revoked (CRL, OCSP)

  *Certificate Chain:*
  - Server Certificate
  - Intermediate Certificate(s)
  - Root CA Certificate (in browser trust store)
]

#slide(title: "Benefits of HTTPS")[
  - *Protection against eavesdropping*
  - *Protection against MITM attacks*
  - *Required for modern web features*:
    - Service Workers
    - WebRTC
    - Geolocation API
  - *SEO benefits* (Google prefers HTTPS)
  - *User trust* (browser shows padlock)
  - *HTTP/2 and HTTP/3 require it*
]

#slide(title: "HSTS (HTTP Strict Transport Security)")[
  ```http
  Strict-Transport-Security: max-age=31536000;
                             includeSubDomains;
                             preload
  ```

  *Purpose:*
  - Force browsers to always use HTTPS
  - Prevent SSL stripping attacks
  - Prevent accidental HTTP access

  *Directives:*
  - `max-age`: Duration in seconds
  - `includeSubDomains`: Apply to all subdomains
  - `preload`: Include in browser's preload list
]

#section-slide(title: "Security Implications")

#slide(title: "Why Understanding HTTP Matters for Security")[
  1. *Attack Surface*: Every HTTP endpoint is potential attack vector

  2. *Input Validation*: All HTTP inputs must be validated
     - Headers, body, cookies, query parameters

  3. *Authentication*: Session management must be secure

  4. *Encryption*: Sensitive data requires HTTPS

  5. *Headers*: Security headers provide defense-in-depth

  6. *Methods*: Unexpected methods can expose vulnerabilities

  7. *Status Codes*: Information disclosure through errors

  8. *Cookies*: Session hijacking, CSRF, XSS all involve cookies
]

#slide(title: "Common HTTP Security Issues")[
  - *Insecure cookies*: Missing Secure, HttpOnly, SameSite
  - *Session fixation*: Not regenerating session ID
  - *Information disclosure*: Verbose error messages
  - *Missing HTTPS*: Credentials sent over HTTP
  - *Weak session management*: Predictable session IDs
  - *CORS misconfiguration*: Overly permissive origins
  - *Missing security headers*: No CSP, HSTS, X-Frame-Options
  - *HTTP method abuse*: Unexpected methods enabled
]

#slide(title: "URL Structure & Security")[
  ```
  https://user:pass@www.example.com:443/path?query=value#section
  ```

  *Components:*
  - Scheme: `https://` (protocol)
  - Credentials: `user:pass@` (avoid! security risk)
  - Host: `www.example.com` (domain or IP)
  - Port: `:443` (default 80 for HTTP, 443 for HTTPS)
  - Path: `/path` (resource location)
  - Query: `?query=value` (parameters)
  - Fragment: `#section` (client-side, not sent to server)

  *Security Note:* Never put credentials in URLs!
]

#section-slide(title: "Key Takeaways")

#slide(title: "Summary")[
  - HTTP is foundation of web communication
  - HTTP is stateless; cookies/sessions provide state
  - Understanding HTTP structure is critical for security testing
  - Headers control behavior and security
  - Status codes indicate request outcome
  - HTTP/2 and HTTP/3 improve performance
  - HTTPS encrypts and authenticates
  - Proper session management is crucial
  - Cookie attributes (Secure, HttpOnly, SameSite) provide security
  - Always use HTTPS for production applications
]

#slide(title: "Resources")[
  *Official Specifications:*
  - RFC 7230-7235: HTTP/1.1
  - RFC 7540: HTTP/2
  - RFC 9114: HTTP/3

  *Learning Resources:*
  - MDN Web Docs - HTTP
  - HTTP Basics Tutorial (NTU Singapore)
  - PortSwigger Web Security Academy

  *Security Resources:*
  - OWASP Testing Guide
  - HTTP Security Headers (securityheaders.com)
]

#title-slide(
  author: [Marcel Schnideritsch],
  title: [HTTP/HTTPS Fundamentals],
  subtitle: [Module 04 - Web Security],
)
