# Search Engines for Reconnaissance

Two kinds of search engine are useful for reconnaissance: traditional web search, and specialized platforms built for security work. Both can be used to find vulnerable devices, exposed data, network infrastructure, and sensitive information. This lecture covers how attackers and security professionals use them to map attack surfaces and identify security weaknesses without directly interacting with target systems.

## Traditional Search Engines for Reconnaissance

### Google Dorking (Google Hacking)

**Definition**: Using advanced Google search operators to find security-related information, vulnerabilities, and sensitive data indexed by Google's web crawlers.

**Why It Works**: Organizations often unintentionally expose sensitive information on public-facing web servers. Google's aggressive crawling indexes this data, making it searchable through specific query operators.

### Google Search Operators

#### Basic Operators

**site:** - Limit results to specific domain

```text
site:example.com
site:example.com -www
site:*.example.com
```

**filetype:** or **ext:** - Search for specific file types

```text
site:example.com filetype:pdf
site:example.com ext:xls
site:example.com (filetype:doc OR filetype:pdf OR filetype:xls)
```

**inurl:** - Search for terms in URL

```text
inurl:admin
inurl:login
inurl:config
site:example.com inurl:admin
```

**intitle:** - Search for terms in page title

```text
intitle:"index of"
intitle:"dashboard" inurl:admin
intitle:"Apache Status" "Apache Server Status for"
```

**intext:** - Search for terms in page body

```text
intext:"confidential" site:example.com
intext:"password" filetype:log
```

**cache:** - View Google's cached version of a page. Google retired this
operator and the "Cached" link in 2024; use the Wayback Machine instead for
historical copies.

```text
cache:example.com
```

**link:** - Find pages linking to a specific URL. Also no longer supported by
Google; it is listed here because older dork lists still contain it. Backlink
discovery now needs a dedicated service.

```text
link:example.com
```

#### Advanced Combinations

**Exposed Directories**:

```text
intitle:"index of" "parent directory"
intitle:"index of" "backup"
intitle:"index of" ".git"
intitle:"index of" "database"
```

**Configuration Files**:

```text
site:example.com ext:conf OR ext:config OR ext:cfg
site:example.com inurl:web.config
filetype:env "DB_PASSWORD"
```

**Database Files**:

```text
filetype:sql "INSERT INTO" "VALUES"
filetype:sql "CREATE TABLE" intext:password
site:example.com ext:sql
```

**Credentials and Sensitive Data**:

```text
site:example.com intext:"password" filetype:xls
site:example.com filetype:txt "username" "password"
"index of" intext:credentials
filetype:log intext:password
```

**Server Information**:

```text
intitle:"Apache Status" "Server Version"
intitle:"IIS7" "Detailed Error"
intitle:"phpinfo()" "PHP Version"
```

**Vulnerable Applications**:

```text
inurl:wp-admin site:example.com
"Powered by WordPress" site:example.com
inurl:jmx-console site:example.com
```

**API Keys and Tokens**:

```text
site:github.com "API_KEY"
site:github.com "aws_secret_access_key"
site:github.com "authorization: Bearer"
filetype:env "API_KEY"
```

**Backup Files**:

```text
site:example.com ext:bak
site:example.com inurl:backup
site:example.com filetype:old
intitle:"index of" "backup" site:example.com
```

### Google Hacking Database (GHDB)

The **Exploit Database** maintains the Google Hacking Database, a curated collection of useful Google dorks categorized by purpose:

- **Footholds**: Finding login pages and vulnerable apps
- **Files containing usernames**: Exposed user lists
- **Sensitive directories**: Configuration and backup directories
- **Web server detection**: Server version and type
- **Vulnerable files**: Known vulnerable file locations
- **Vulnerable servers**: Server misconfigurations
- **Error messages**: Information disclosure through errors
- **Files containing juicy info**: Passwords, financial data, PII
- **Files containing passwords**: Direct password exposures
- **Sensitive online shopping info**: E-commerce vulnerabilities

**Access**: <https://www.exploit-db.com/google-hacking-database>

### Practical Google Dorking Workflow

#### **Phase 1: Domain Enumeration**

```text
site:example.com
site:*.example.com
```

#### **Phase 2: Subdomain Discovery**

```text
site:*.example.com -www
site:*.example.com -site:www.example.com
```

#### **Phase 3: Technology Identification**

```text
site:example.com "powered by"
site:example.com "built with"
site:example.com inurl:wp-content
```

#### **Phase 4: Sensitive File Discovery**

```text
site:example.com filetype:pdf confidential
site:example.com ext:sql
site:example.com intitle:"index of"
```

#### **Phase 5: Login Portal Discovery**

```text
site:example.com inurl:login
site:example.com inurl:admin
site:example.com intitle:dashboard
```

### Other Traditional Search Engines

**Bing** - Microsoft's search engine with unique operators:

```text
ip:192.168.1.1
contains:pdf site:example.com
url:admin site:example.com
```

**DuckDuckGo** - Privacy-focused; supports most of the same operators. It
draws on a different index than Google, so it is worth querying for coverage
rather than for stealth. No web search engine touches the target on your
behalf, so none of them is "more covert" than another:

```text
site:example.com
filetype:pdf site:example.com
```

**Yandex** - Russian search engine, excellent image search (reverse image search often better than Google):

```text
site:example.com
```

## Shodan: Search Engine for Internet-Connected Devices

### What is Shodan?

**Shodan** is the world's first search engine for internet-connected devices. Unlike traditional search engines that index web page content, Shodan continuously scans the entire IPv4 address space and indexes information about services, devices, and systems directly connected to the internet.

**Created**: By John Matherly in 2009
**Purpose**: Originally for security research, now used by security professionals, researchers, and unfortunately, attackers

**What Shodan Indexes**:

- Web servers and their banners
- Industrial Control Systems (ICS/SCADA)
- Network devices (routers, switches, firewalls)
- Internet of Things (IoT) devices
- Databases exposed to the internet
- Webcams and surveillance systems
- Smart home devices
- Medical equipment
- Building management systems
- Power grid components

### How Shodan Works

1. **Scanning**: Shodan continuously scans common ports across all IPv4 addresses
2. **Banner Grabbing**: Captures service banners containing software versions, configurations
3. **Indexing**: Stores data in searchable database
4. **Categorization**: Tags devices by type, location, organization
5. **Vulnerability Matching**: Cross-references with known vulnerabilities

**Common Ports Scanned**:

- 21 (FTP), 22 (SSH), 23 (Telnet), 25 (SMTP)
- 80 (HTTP), 443 (HTTPS), 8080, 8443 (HTTP alternates)
- 3306 (MySQL), 5432 (PostgreSQL), 27017 (MongoDB)
- 1883 (MQTT), 502 (Modbus), 102 (S7)
- And hundreds more...

### Shodan Search Syntax

#### Basic Searches

**Search by hostname**:

```text
hostname:example.com
```

**Search by IP address**:

```text
ip:192.168.1.1
net:192.168.1.0/24
```

**Search by port**:

```text
port:22
port:3389
```

**Search by country**:

```text
country:US
country:DE
```

**Search by city**:

```text
city:"New York"
city:London
```

**Search by organization**:

```text
org:"Amazon"
org:"Google"
```

#### Advanced Filters

**Operating System**:

```text
os:"Windows"
os:"Linux"
os:"Ubuntu"
```

**Product/Software**:

```text
product:"Apache"
product:"nginx"
product:"MySQL"
```

**Version**:

```text
version:"2.4.41"
product:Apache version:2.4
```

**Vulnerability (CVE)**: the `vuln:` filter is not available on free Shodan
accounts; it requires a paid or academic membership:

```text
vuln:CVE-2021-44228 (Log4Shell)
vuln:CVE-2017-0144 (EternalBlue)
```

Shodan infers these matches from banners and version strings, not by
exploiting anything. A `vuln:` hit is therefore a *candidate*, not a confirmed
vulnerable host: backported patches and vendor builds routinely keep the old
version string.

**Has Screenshot** (for services with web interfaces):

```text
has_screenshot:true
```

**HTTP Components**:

```text
http.title:"Dashboard"
http.status:200
http.favicon.hash:12345678
```

#### Practical Shodan Queries

**Find Webcams**:

```text
"webcam" has_screenshot:true
"Server: IP Webcam Server"
```

**Find Remote Desktop Services**:

```text
port:3389 country:US
"Remote Desktop Protocol" city:London
```

**Find Exposed Databases**:

```text
port:27017 product:"MongoDB"
"MongoDB Server Information" -authentication
port:3306 "MySQL" -authentication
port:6379 product:"Redis"
```

**Find Industrial Control Systems**:

```text
"Modbus"
port:502
"Siemens" country:US
```

**Find Vulnerable Systems**:

```text
vuln:CVE-2017-0144
"IIS/7.5" vuln:CVE-2015-1635
product:Apache version:2.4.49
```

**Find Specific Organizations**:

```text
org:"Target Corporation"
hostname:example.com has_screenshot:true
```

**Find Default Credentials**:

```text
"default password" port:23
"Authentication disabled" port:22
```

### Shodan CLI and API

**Shodan Command Line Interface**:

```bash
# Install
pip install shodan

# Initialize with API key
shodan init YOUR_API_KEY

# Search
shodan search "hostname:example.com"
shodan search "port:22 country:US" --limit 100

# Get host information
shodan host 8.8.8.8

# Count results
shodan count "apache"

# Stream real-time data
shodan stream
```

**Shodan API** (Python Example):

```python
import shodan

api = shodan.Shodan('YOUR_API_KEY')

# Search Shodan
results = api.search('hostname:example.com')

print(f'Results found: {results["total"]}')

for result in results['matches']:
    print(f'IP: {result["ip_str"]}')
    print(f'Port: {result["port"]}')
    print(f'Data: {result["data"]}')
```

### Shodan Alternatives

**Censys** (<https://censys.io/>):

- Similar to Shodan but with focus on SSL/TLS certificates
- Better for finding subdomains via certificate transparency
- Free academic access
- More detailed SSL/TLS information

**Search syntax**:

```text
parsed.names: example.com
protocols: "443/https"
location.country: "United States"
```

**ZoomEye** (<https://www.zoomeye.org/>):

- Chinese alternative to Shodan
- Good coverage of Asian networks
- Web and host search capabilities

**BinaryEdge** (<https://www.binaryedge.io/>):

- Comprehensive internet scanning
- Includes DNS, Tor, and Torrents
- Historical data available

**Greynoise** (<https://www.greynoise.io/>):

- Focuses on internet background noise
- Distinguishes malicious vs. benign scanning
- Useful for threat intelligence

**FOFA** (<https://fofa.info/>):

- Cyberspace search engine
- Strong in Chinese networks
- Advanced query syntax

### Shodan for Defensive Reconnaissance

Organizations should use Shodan to discover their own exposed assets:

1. **Asset Discovery**:

   ```text
   org:"Your Organization Name"
   hostname:yourcompany.com
   ```

2. **Identify Exposed Services**:
   - Find services that shouldn't be public
   - Locate forgotten or shadow IT assets
   - Discover misconfigurations

3. **Vulnerability Assessment**:

   ```text
   org:"Your Organization" vuln:*
   ```

4. **Monitoring**:
   - Set up Shodan monitors for your IP ranges
   - Receive alerts when new services appear
   - Track changes over time

## Other Specialized Search Engines

### PublicWWW

**Purpose**: Search for specific code, scripts, or tracking IDs across websites

**Use Cases**:

- Find all websites using specific Google Analytics ID
- Discover sites using same advertising code
- Identify websites by technology footprint

**Example**:

```text
"UA-12345678" (Google Analytics ID)
"GTM-ABC123" (Google Tag Manager)
```

### Certificate Search (crt.sh)

**Purpose**: Search certificate transparency logs for SSL/TLS certificates

**Use Cases**:

- Subdomain enumeration
- Find all domains owned by organization
- Discover forgotten or test domains

**Example queries**:

```text
%.example.com
```

**URL**: <https://crt.sh/>

### Pastebin and Code Search

**GitHub Code Search**:

- Find leaked credentials in public repositories
- Discover API keys and tokens
- Identify technology stack from code

```text
org:company_name password
filename:.env DB_PASSWORD
```

**Pastebin Search** (<https://psbdmp.ws/>):

- Monitor pastes mentioning your organization
- Find leaked credentials or data
- Track data breaches

### Wayback Machine

**Internet Archive** (<https://archive.org/web/>):

- View historical versions of websites
- Recover deleted content
- Find old vulnerabilities or information

**Use Cases**:

- See old employee directories
- Find removed documentation
- Discover changed infrastructure

## Ethical and Legal Considerations

### Passive Nature

- Search engines for reconnaissance are generally passive
- You're querying a search engine, not the target directly
- Information is already publicly accessible

"Passive" describes the query, not the whole data path. Someone had to touch
the target to build the index, and the target may well have logged that:

```text
   Analyst ──query──▶  Search index  ◀──────── crawler or
                       (Google, Shodan,        Shodan scanner
                        crt.sh, Wayback)       visits the target
                             ▲                 and IS logged there
                             │
                       CAs publish issued certs to CT logs:
                       no contact with the target at all

   Your query never reaches the target. Opening one of the results
   does — and that request appears in the target's access log like
   any other visit.
```

So search-engine reconnaissance keeps *you* out of the target's logs, as long
as you only read the index. The moment you click through to a discovered
`/admin` page, you are doing active reconnaissance.

### Legal Gray Areas

- Accessing exposed data may still violate laws (CFAA in U.S.)
- Some jurisdictions consider accessing misconfigured systems illegal
- Terms of service violations can have legal consequences

### Responsible Use

1. **Don't access exposed systems**: Finding is reconnaissance; accessing is intrusion
2. **Responsible disclosure**: Report serious exposures to affected organizations
3. **Authorization required**: Only access systems you have permission to test
4. **Document findings**: Keep records of what you find and why

### Notification Dilemma

If you discover serious exposures (e.g., medical records, financial data):

- Consider responsible disclosure to organization
- May report to CERT/CC or similar organizations
- Balance risk of notification with risk of exposure
- Document decision-making process

## Defensive Measures

### Preventing Search Engine Exposure

**1. robots.txt Configuration**:

```text
User-agent: *
Disallow: /admin/
Disallow: /config/
Disallow: /backup/
```

**Note**: robots.txt only *requests* that well-behaved crawlers stay out; it
enforces nothing. Worse, it is itself a public file, so the example above
hands an attacker the three directory names you most wanted hidden. Use
authentication for anything sensitive and keep it out of robots.txt.

**2. Remove from Index**:

- Google Search Console: Request URL removal
- Meta tags: `<meta name="robots" content="noindex">`
- X-Robots-Tag HTTP header

**3. Authentication and Access Controls**:

- Require authentication for sensitive areas
- Don't rely on "security through obscurity"
- Use proper access controls instead of relying on hidden URLs

**4. Regular Monitoring**:

```text
site:yourcompany.com filetype:pdf confidential
site:yourcompany.com intitle:"index of"
```

**5. Information Disclosure Prevention**:

- Disable directory listing
- Remove verbose error messages
- Strip server version banners
- Don't expose internal file structures

### Shodan Protection

**1. Minimize Internet Exposure**:

- Only expose services that must be public
- Use VPN for administrative access
- Implement network segmentation

**2. Regular Shodan Audits**:

```bash
# Monitor your organization
shodan search 'org:"Your Company"'

# Monitor your IP ranges
shodan host YOUR_IP_ADDRESS
```

**3. Set Up Alerts**:

- Use Shodan monitoring service
- Alert on new exposed services
- Track changes in footprint

**4. Banner Modification**:

- Modify server banners to remove versions
- Use generic responses
- Don't advertise technology stack

## Practical Exercises

### Exercise 1: Google Dorking Challenge

**Objective**: Find sensitive information about a target organization (with permission)

1. Start with basic site search: `site:example.com`
2. Look for exposed directories: `site:example.com intitle:"index of"`
3. Find document types: `site:example.com (filetype:pdf OR filetype:xls OR filetype:doc)`
4. Search for login pages: `site:example.com (inurl:login OR inurl:admin)`
5. Look for technology indicators: `site:example.com "powered by"`

**Document**:

- What sensitive information did you find?
- What types of files are exposed?
- What technologies are in use?

### Exercise 2: Shodan Reconnaissance

**Objective**: Understand your organization's internet footprint

1. Search by organization name: `org:"Your Organization"`
2. Search by domain: `hostname:yourcompany.com`
3. Analyze exposed services and ports
4. Check for known vulnerabilities: `org:"Your Organization" vuln:*`
5. Document findings and risk assessment

### Exercise 3: Certificate Transparency

**Objective**: Enumerate subdomains via certificate logs

1. Visit <https://crt.sh>
2. Search for `%.example.com`
3. Compile list of discovered subdomains
4. Cross-reference with DNS enumeration results
5. Identify previously unknown assets

### Exercise 4: Self-OSINT via Search Engines

**Objective**: Understand what search engines reveal about you

1. Google your name in quotes with variations
2. Search your email address(es)
3. Search your username(s)
4. Check images (Google Images, your name)
5. Review what's accessible and consider privacy

## Integration with Reconnaissance Methodology

Search engine reconnaissance fits into the overall process:

1. **Passive Reconnaissance**: Querying the index generates no entries in the target's logs. Following a result does
2. **Early Phase**: Use before active scanning to understand scope
3. **Continuous**: Search engines index new content constantly
4. **Validation**: Confirm technical findings with search data
5. **Intelligence**: Combine with OSINT for a fuller picture

## Key Takeaways

- Traditional search engines (Google, Bing) can reveal sensitive data through dorking
- Shodan and similar platforms index internet-connected devices and services
- Search engine reconnaissance is largely passive but very effective
- Organizations must monitor their own search engine exposure
- Legal and ethical considerations apply even to public data
- Defensive reconnaissance helps organizations understand their attack surface
- Combine multiple search engines for broader coverage
- Regular monitoring and mitigation reduces exposure

## Additional Resources

### Google Hacking

- **Google Hacking Database**: <https://www.exploit-db.com/google-hacking-database>
- **"Google Hacking for Penetration Testers"** by Johnny Long - Definitive guide
- **Google Search Operators**: <https://support.google.com/websearch/answer/2466433>

### Shodan

- **Shodan**: <https://www.shodan.io/>
- **Shodan Documentation**: <https://help.shodan.io/>
- **Shodan CLI**: <https://cli.shodan.io/>
- **Book of Shodan**: <https://leanpub.com/shodan> - Comprehensive Shodan guide

### Alternatives and Tools

- **Censys**: <https://censys.io/>
- **ZoomEye**: <https://www.zoomeye.org/>
- **BinaryEdge**: <https://www.binaryedge.io/>
- **crt.sh**: <https://crt.sh/>
- **PublicWWW**: <https://publicwww.com/>

### Practice and Learning

- **HackTheBox**: Includes boxes requiring search engine reconnaissance
- **TryHackMe - Google Dorking Room**: Guided Google hacking exercises
- **Shodan Training**: Regular webinars and tutorials on Shodan.io

## Conclusion

Search engines let security professionals and attackers collect information without directly interacting with a target. Google dorking turns up misconfigured web servers, and Shodan turns up exposed critical infrastructure, which shows how effective passive reconnaissance can be. The same queries work against your own organization, so audit your search engine footprint regularly and put controls in place against sensitive information exposure. If a search engine can find it, so can an attacker, and unlike active reconnaissance these queries leave no traces on your systems.
