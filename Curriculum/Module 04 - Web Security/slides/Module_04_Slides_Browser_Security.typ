#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 04: Web Security],
    subtitle: [Browser Security Features],
    authors: [*Marcel Schnideritsch*],
    extra: [],
    footer: [Module 04 - Web Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "Same-Origin Policy (SOP)")

#slide(title: "What is Same-Origin Policy?")[
  *The cornerstone of web security*

  - Prevents malicious scripts from one origin accessing data from another
  - One of the oldest and most fundamental security mechanisms
  - Enforced by all modern browsers

  *Purpose:*
  - Isolate origins from each other
  - Prevent data theft between websites
  - Foundation for browser security model
]

#slide(title: "What Defines an Origin?")[
  Three components must match:

  1. *Protocol Scheme*: `http` vs `https`
  2. *Host Name*: Domain or IP address
  3. *Port Number*: 80, 443, 8080, etc.

  *Example:*
  ```
  https://example.com:443/page
  ^^^^^^  ^^^^^^^^^^^  ^^^
  scheme     host      port
  ```

  All three must be identical for same origin!
]

#slide(title: "Origin Comparison Examples")[
  Base URL: `http://normal-website.com:80/example/`

  #table(
    columns: (auto, auto, auto),
    inset: 6pt,
    stroke: 0.5pt,
    align: left,
    [*URL*], [*Same Origin?*], [*Reason*],
    [`http://normal-website.com/example2/`], [✅ Yes], [All match],
    [`https://normal-website.com/example/`], [❌ No], [Different scheme],
    [`http://en.normal-website.com/example/`], [❌ No], [Different subdomain],
    [`http://normal-website.com:8080/`], [❌ No], [Different port],
  )
]

#slide(title: "What SOP Restricts")[
  *Cannot access:*
  - Responses from different origin (XHR/Fetch)
  - DOM of documents from different origin
  - Cookies set by different origin

  *Can do:*
  - Send requests to any origin (response is opaque)
  - Embed resources (images, scripts, stylesheets)
  - Navigate to different origins (links, forms)
  - Use `postMessage` for controlled cross-origin communication
]

#slide(title: "SOP Bypass: postMessage API")[
  *Secure cross-origin communication:*

  ```javascript
  // Sender (origin A)
  targetWindow.postMessage('Hello!', 'https://trusted-origin.com');

  // Receiver (origin B)
  window.addEventListener('message', (event) => {
    // CRITICAL: Always verify origin!
    if (event.origin !== 'https://trusted-origin.com') {
      return;
    }

    console.log('Received:', event.data);
  });
  ```

  *Security: Always validate `event.origin`!*
]

#section-slide(title: "CORS (Cross-Origin Resource Sharing)")

#slide(title: "What is CORS?")[
  - Mechanism to relax SOP for specific origins
  - Allows servers to explicitly permit cross-origin requests
  - Controlled via HTTP headers

  *Use Cases:*
  - APIs accessed from different domains
  - CDNs serving content
  - Microservices architecture
  - Third-party integrations
]

#slide(title: "CORS Headers")[
  *Response Headers:*
  - `Access-Control-Allow-Origin`: Which origins can access
  - `Access-Control-Allow-Credentials`: Allow cookies/auth
  - `Access-Control-Allow-Methods`: Allowed HTTP methods
  - `Access-Control-Allow-Headers`: Allowed custom headers
  - `Access-Control-Max-Age`: Preflight cache duration

  *Request Headers:*
  - `Origin`: Request origin (set by browser)
  - `Access-Control-Request-Method`: Method for actual request
  - `Access-Control-Request-Headers`: Headers for actual request
]

#slide(title: "CORS Simple vs Preflight")[
  *Simple Requests (no preflight):*
  - GET, HEAD, POST
  - Only simple headers
  - Content-Type: text/plain, application/x-www-form-urlencoded

  *Preflight Required (OPTIONS):*
  - PUT, DELETE, PATCH
  - Custom headers
  - Content-Type: application/json
  - Credentials included

  Browser sends OPTIONS request first to check permissions
]

#slide(title: "CORS Misconfigurations")[
  #set text(size: 18pt)
  *Common Vulnerabilities:*

  1. *Wildcard with credentials*:
     ```http
     Access-Control-Allow-Origin: *
     Access-Control-Allow-Credentials: true
     ```
     (Browser rejects this)

  2. *Reflecting arbitrary origins*:
     ```javascript
     res.setHeader('Access-Control-Allow-Origin', req.headers.origin);
     ```

  3. *Null origin*:
     ```http
     Access-Control-Allow-Origin: null
     ```

  4. *Insufficient validation*:
     ```javascript
     if (origin.includes('example.com')) { /* WRONG! */ }
     ```
]

#section-slide(title: "Content Security Policy (CSP)")

#slide(title: "What is CSP?")[
  *Content Security Policy*

  - Powerful security feature to mitigate XSS and code injection
  - Controls which resources can be loaded and executed
  - Specified via HTTP header or meta tag

  ```http
  Content-Security-Policy:
    default-src 'self';
    script-src 'self' https://cdn.example.com;
    style-src 'self' 'unsafe-inline'
  ```
]

#slide(title: "CSP Directives")[
  *Fetch Directives:*
  - `default-src`: Fallback for other directives
  - `script-src`: JavaScript sources
  - `style-src`: CSS sources
  - `img-src`: Image sources
  - `connect-src`: XHR, WebSocket, fetch()
  - `font-src`: Font sources
  - `frame-src`: iframe sources
  - `media-src`: audio, video sources
]

#slide(title: "CSP Source Values")[
  #set text(size: 16pt)
  *Keywords:*
  - `'none'`: Block all
  - `'self'`: Same origin only
  - `'unsafe-inline'`: Allow inline scripts/styles (dangerous!)
  - `'unsafe-eval'`: Allow eval() (dangerous!)
  - `'strict-dynamic'`: Trust dynamically added scripts

  *Hosts:*
  - `https://example.com`: Specific domain
  - `https://*.example.com`: Subdomain wildcard
  - `https:`: Any HTTPS source
  - `data:`, `blob:`: Data URIs

  *Nonces & Hashes:*
  - `'nonce-random123'`: Cryptographic nonce
  - `'sha256-hash'`: Hash of inline script
]

#slide(title: "Strict CSP (Recommended)")[
  ```http
  Content-Security-Policy:
    default-src 'self';
    script-src 'nonce-{random}' 'strict-dynamic';
    object-src 'none';
    base-uri 'none';
    require-trusted-types-for 'script';
  ```

  *HTML with Nonce:*
  ```html
  <script nonce="random123">
    // This script is allowed
    alert('Hello!');
  </script>
  ```

  Scripts without nonce are blocked!
]

#slide(title: "CSP Bypasses to Avoid")[
  #set text(size: 18pt)
  *Common Mistakes:*

  1. *'unsafe-inline'*: Defeats XSS protection
  2. *'unsafe-eval'*: Allows eval(), setTimeout with strings
  3. *JSONP endpoints*: Can execute arbitrary code
  4. *AngularJS CDN*: Template injection
  5. *No base-uri*: Base tag hijacking
  6. *Wildcard subdomains*: Compromised subdomain = bypass

  *Always:*
  - Use nonces or hashes instead of 'unsafe-inline'
  - Whitelist carefully (fewer is better)
  - Set `base-uri 'none'` or `'self'`
  - Set `object-src 'none'` (blocks Flash, Java)
]

#section-slide(title: "Other Security Headers")

#slide(title: "X-Frame-Options")[
  *Prevents clickjacking by controlling iframe embedding*

  ```http
  X-Frame-Options: DENY
  ```
  Cannot be embedded in any iframe

  ```http
  X-Frame-Options: SAMEORIGIN
  ```
  Can only be embedded on same origin

  *Modern Alternative:*
  ```http
  Content-Security-Policy: frame-ancestors 'none';
  ```
  More flexible and powerful
]

#slide(title: "X-Content-Type-Options")[
  *Prevents MIME sniffing attacks*

  ```http
  X-Content-Type-Options: nosniff
  ```

  *Purpose:*
  - Forces browser to respect declared Content-Type
  - Prevents browser from interpreting files as different type
  - Blocks XSS via uploaded files

  *Without nosniff:*
  Upload HTML file as image → Browser might execute it

  *With nosniff:*
  Browser strictly follows Content-Type header
]

#slide(title: "Strict-Transport-Security (HSTS)")[
  #set text(size: 18pt)
  *Forces HTTPS usage*

  ```http
  Strict-Transport-Security: max-age=31536000;
                             includeSubDomains;
                             preload
  ```

  *Directives:*
  - `max-age`: Duration in seconds (1 year = 31536000)
  - `includeSubDomains`: Apply to all subdomains
  - `preload`: Include in browser's preload list

  *Benefits:*
  - Prevents SSL stripping attacks
  - Prevents accidental HTTP access
  - Improves SEO
]

#slide(title: "Referrer-Policy")[
  *Controls Referer header sent with requests*

  ```http
  Referrer-Policy: strict-origin-when-cross-origin
  ```

  *Values:*
  - `no-referrer`: Never send
  - `same-origin`: Only for same-origin
  - `strict-origin`: Origin only, not on HTTPS→HTTP
  - `strict-origin-when-cross-origin`: Recommended default
  - `unsafe-url`: Always send full URL (don't use!)

  *Privacy & Security:*
  - Prevents URL leakage to third parties
  - May contain sensitive information in query params
]

#slide(title: "Permissions-Policy")[
  #set text(size: 17pt)
  *Controls which browser features can be used*

  ```http
  Permissions-Policy:
    geolocation=(),
    microphone=(),
    camera=(self)
  ```

  *Features:*
  - `geolocation`, `microphone`, `camera`
  - `payment`, `usb`, `fullscreen`
  - `autoplay`, `picture-in-picture`

  *Values:*
  - `()`: Blocked for all
  - `(self)`: Same origin only
  - `*`: Allowed for all (not recommended)
]

#section-slide(title: "Cookie Security")

#slide(title: "Cookie Security Attributes")[
  ```http
  Set-Cookie: session=abc123;
              Secure;
              HttpOnly;
              SameSite=Strict;
              Path=/;
              Max-Age=3600
  ```

  *Security Attributes:*
  - *Secure*: Only sent over HTTPS
  - *HttpOnly*: Not accessible via JavaScript
  - *SameSite*: CSRF protection
]

#slide(title: "SameSite Cookie Attribute")[
  #table(
    columns: (auto, auto, auto, auto),
    inset: 6pt,
    stroke: 0.5pt,
    [*Scenario*], [*Strict*], [*Lax*], [*None*],
    [Link from external site], [❌], [✅], [✅],
    [Form POST from external], [❌], [❌], [✅],
    [AJAX from external], [❌], [❌], [✅],
    [Iframe from external], [❌], [❌], [✅],
  )

  - *Strict*: Best security, but breaks some legitimate flows
  - *Lax*: Good balance (default in modern browsers)
  - *None*: No protection (requires Secure attribute)
]

#slide(title: "Cookie Prefixes")[
  #set text(size: 18pt)
  *\_\_Secure- Prefix:*
  ```http
  Set-Cookie: __Secure-session=abc123; Secure; Path=/
  ```
  - Must have Secure attribute
  - Must be set over HTTPS

  *\_\_Host- Prefix:*
  ```http
  Set-Cookie: __Host-session=abc123; Secure; Path=/
  ```
  - Must have Secure attribute
  - Must be set over HTTPS
  - Must NOT have Domain attribute
  - Path must be `/`

  *Benefits:* Prevents subdomain override attacks
]

#section-slide(title: "Subresource Integrity (SRI)")

#slide(title: "SRI: Subresource Integrity")[
  #set text(size: 16pt)
  *Ensures third-party resources haven't been tampered with*

  ```html
  <script src="https://cdn.example.com/library.js"
          integrity="sha384-hash_value_here"
          crossorigin="anonymous"></script>

  <link rel="stylesheet"
        href="https://cdn.example.com/style.css"
        integrity="sha384-hash_value_here"
        crossorigin="anonymous">
  ```

  *How it works:*
  1. Browser downloads resource
  2. Computes hash
  3. Compares with integrity attribute
  4. Blocks if mismatch
]

#slide(title: "Generating SRI Hashes")[
  ```bash
  # Generate SHA-384 hash
  openssl dgst -sha384 -binary library.js | openssl base64 -A
  ```

  Output: `sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K...`

  *Benefits:*
  - Protects against compromised CDNs
  - Detects tampering
  - Ensures resource authenticity

  *Requirements:*
  - Must use `crossorigin` attribute
  - CORS headers must be configured
]

#section-slide(title: "Security Best Practices")

#slide(title: "Comprehensive Security Headers")[
  ```http
  # Recommended security headers
  Strict-Transport-Security: max-age=31536000; includeSubDomains
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  Content-Security-Policy: default-src 'self'; script-src 'nonce-{random}'
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: geolocation=(), microphone=(), camera=()

  # Cookies
  Set-Cookie: session=...; Secure; HttpOnly; SameSite=Strict
  ```

  Test your headers: https://securityheaders.com/
]

#slide(title: "Defense in Depth")[
  *Multiple layers of security:*

  1. *SOP*: Foundation of browser security
  2. *CORS*: Controlled relaxation of SOP
  3. *CSP*: Mitigate XSS and injection
  4. *Security Headers*: Additional protections
  5. *Cookie Security*: Secure session management
  6. *SRI*: Third-party resource integrity
  7. *Input Validation*: Server-side validation still critical!

  No single control is sufficient!
]

#slide(title: "Common Pitfalls")[
  ❌ *Avoid:*
  - Reflecting arbitrary origins in CORS
  - Using 'unsafe-inline' or 'unsafe-eval' in CSP
  - Missing Secure/HttpOnly/SameSite on cookies
  - Substring matching for origin validation
  - Whitelisting JSONP endpoints in CSP
  - Not validating postMessage origins
  - Using `null` as allowed CORS origin
  - Missing security headers
]

#section-slide(title: "Key Takeaways")

#slide(title: "Summary")[
  - *SOP* is the foundation of web security
  - *CORS* must be configured carefully (exact origin matching)
  - *CSP* mitigates XSS through content restrictions
  - *Security headers* provide defense-in-depth
  - *Cookie attributes* are critical for session security
  - *SRI* protects against CDN compromise
  - Each feature has potential misconfigurations
  - Multiple layers of security are essential
  - Always validate inputs even with security features
  - Test configurations thoroughly
]

#slide(title: "Resources")[
  #set text(size: 18pt)
  *Documentation:*
  - MDN - Same-Origin Policy
  - MDN - CORS
  - MDN - Content Security Policy
  - OWASP Secure Headers Project

  *Testing Tools:*
  - Security Headers Checker: https://securityheaders.com/
  - CSP Evaluator: https://csp-evaluator.withgoogle.com/
  - Browser DevTools: Inspect headers and cookies

  *Practice:*
  - PortSwigger Web Security Academy
  - OWASP WebGoat
]

#title-slide(
  author: [Marcel Schnideritsch],
  title: [Browser Security Features],
  subtitle: [Module 04 - Web Security],
)
