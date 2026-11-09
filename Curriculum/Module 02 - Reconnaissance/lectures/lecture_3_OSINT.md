# Open Source Intelligence (OSINT)

Open Source Intelligence (OSINT) is the practice of collecting, analyzing, and making decisions based on publicly available information. Unlike classified intelligence that requires special access or covert operations, OSINT uses data that anyone can legally access: social media profiles, public records, satellite imagery, financial disclosures and much more. Because so much organizational and personal detail is now published by default, OSINT is a core working method for cybersecurity professionals, investigators, journalists, and organizations.

## What is OSINT?

OSINT means gathering and analyzing information from publicly accessible sources to produce usable intelligence for a specific purpose: a security assessment, threat analysis, competitive intelligence or an investigation.

Everything it uses is legally accessible without unauthorized access, and it comes from many channels at once: the web, social media, government records and others. Raw data on its own is not intelligence; it has to be processed, validated and put in context. Done properly, the work stays inside legal boundaries. It is also never finished, because the information changes while you are collecting it.

**Purpose in Cybersecurity**:

- **Pre-engagement reconnaissance**: Understand target before penetration testing
- **Threat intelligence**: Identify threat actors and their TTPs (Tactics, Techniques, Procedures)
- **Vulnerability assessment**: Discover exposed assets and information leakage
- **Social engineering preparation**: Gather information for targeted attacks
- **Incident response**: Investigate breaches and attribute attacks
- **Brand protection**: Monitor for impersonation and data leaks

## Types of OSINT

### 1. Personal OSINT (PERSINT)

Gathering information about individuals for various purposes including background checks, threat assessment, or social engineering preparation.

**Sources**:

- Social media profiles (LinkedIn, Twitter, Facebook, Instagram, TikTok)
- Professional networking sites
- Public records (property records, court documents, voter registration)
- Data breach databases (Have I Been Pwned, Dehashed)
- People search engines (Spokeo, Pipl, TruePeopleSearch)
- Username enumeration across platforms
- Resume and portfolio websites
- GitHub, Stack Overflow profiles
- Photo metadata and geolocation data

**Information to Collect**:

- Full name and aliases
- Email addresses and phone numbers
- Physical addresses (current and historical)
- Employment history and organizational roles
- Family members and associates
- Interests, hobbies, and affiliations
- Travel patterns and locations frequented
- Technical skills and knowledge areas
- Security questions answers (pet names, birth places)

**Example Workflow**:

1. Start with known identifier (email, username, phone)
2. Search social media platforms
3. Use reverse image search on profile photos
4. Check data breach databases
5. Search public records and people search engines
6. Map relationships and connections
7. Timeline activities and behavioral patterns

### 2. Organizational OSINT (CORPINT)

Information related to companies, businesses, government agencies, or other organizations.

**Sources**:

- Corporate websites and press releases
- SEC filings and financial reports (for public companies)
- Job postings and career pages
- LinkedIn company pages and employee profiles
- Business registrations and incorporation records
- Patent and trademark databases
- News articles and media coverage
- Conference presentations and whitepapers
- Technology stack indicators (job posts, error messages)
- Vendor and partner relationships

**Information to Collect**:

- Organizational structure and hierarchy
- Key personnel and decision makers
- Office locations and facilities
- Technology infrastructure and vendors
- Business partners and suppliers
- Financial health and investments
- Mergers, acquisitions, and expansion plans
- Security products and policies
- Compliance requirements and certifications
- Historical data and changes over time

**Example Use Case**:

Before a penetration test, collect:

- Employee names for username wordlists
- Email format (`first.last@company.com`)
- Technologies in use (from job postings: "Experience with AWS, Terraform required")
- Office locations for physical security assessment
- Organizational chart for targeted social engineering

### 3. Technical OSINT (TECHINT)

Information about networks, domains, IP addresses, and technical infrastructure.

**Sources**:

- WHOIS databases
- DNS records and zone files
- SSL/TLS certificates (Certificate Transparency logs)
- Shodan, Censys (internet-connected device search engines)
- IP geolocation databases
- BGP routing data
- Subdomain enumeration tools
- Web archives (Wayback Machine)
- Pastebin and GitHub code leaks
- Dark web monitoring
- CVE databases and exploit frameworks

**Information to Collect**:

- Domain registration details
- IP address ranges and netblocks
- Subdomains and hidden services
- Open ports and exposed services
- SSL certificate details
- Email servers (MX records)
- SPF, DKIM, DMARC configurations
- ASN (Autonomous System Number) information
- Historical DNS changes
- Exposed credentials or API keys in code repositories

**Tools and Techniques**:

```bash
# WHOIS lookup
whois example.com

# DNS enumeration
dig example.com ANY
host -t mx example.com

# Subdomain discovery
sublist3r -d example.com
amass enum -d example.com

# Certificate transparency
https://crt.sh/?q=%25.example.com

# Shodan search
shodan search "hostname:example.com"

# GitHub secret search
truffleHog --regex --entropy=False https://github.com/org/repo
```

### 4. Geospatial OSINT (GEOINT)

Information related to physical locations, geography, and spatial relationships.

**Sources**:

- Google Maps / Google Earth
- Satellite imagery (Planet Labs, Sentinel Hub)
- Street view services
- Geotagged social media posts
- Photo metadata (EXIF data)
- Flight tracking (FlightRadar24, FlightAware)
- Ship tracking (Marine Traffic)
- Webcams and public cameras
- Weather data and historical patterns

**Information to Collect**:

- Facility layouts and building structures
- Entry/exit points and physical security measures
- Employee parking areas and vehicle information
- Nearby landmarks and reference points
- Timezone and working hours patterns
- Historical changes to facilities
- Surveillance camera positions
- Physical security weaknesses

**Example Application**:

1. Locate target facility using address from public records
2. Analyze satellite imagery for layout and security cameras
3. Use street view to identify entry points
4. Check geotagged social media posts from inside facility
5. Extract EXIF data from employee-posted photos
6. Map employee parking to identify vehicle types
7. Observe patterns in facility activity over time

## OSINT Tools and Frameworks

### Search Engines and Aggregators

**Google Advanced Search Operators** (Google Dorking):

```text
site:example.com filetype:pdf
"confidential" site:example.com
inurl:admin site:example.com
intitle:"index of" site:example.com
site:example.com -www
```

(Google's `cache:` operator was retired in 2024; use the Wayback Machine for
historical copies of a page.)

**Specialized Search Engines**:

- **Shodan**: Search engine for internet-connected devices
- **Censys**: Internet-wide scan data and analysis
- **ZoomEye**: Cyberspace search engine
- **FOFA**: Search engine for cyber assets
- **Binary Edge**: Internet scanning and data collection
- **Greynoise**: Internet background noise analysis

### Social Media Intelligence (SOCMINT) Tools

- **Twint**: Twitter intelligence tool (no API required; unmaintained since
  Twitter's API and access changes broke it, but it is mentioned here because you
  will still find it referenced in older tutorials)
- **Social-Searcher**: Multi-platform social media search
- **Sherlock**: Find usernames across social networks
- **Maigret**: Collect information about accounts by username
- **IntelX**: Search engine for data breaches, leaks, and public records

### Username and Email Investigation

```bash
# Sherlock - username search across platforms
sherlock username123

# theHarvester - email harvesting
theHarvester -d example.com -b google,linkedin,bing

# h8mail - email breach search
h8mail -t target@example.com

# Holehe - check email across services
holehe email@example.com
```

### Domain and Network Tools

- **Whois**: Domain registration information
- **DNSdumpster**: DNS reconnaissance and research
- **SecurityTrails**: DNS and domain data
- **Sublist3r**: Subdomain enumeration
- **Amass**: In-depth attack surface mapping
- **Spiderfoot**: Automated OSINT collection

### Framework and Platforms

**Maltego**:

- Visual link analysis and data mining
- Transform data relationships into graphs
- Integrates with numerous data sources
- Commercial and community editions

**Recon-ng**:

- Web reconnaissance framework
- Modular Python-based tool
- Database-driven methodology
- Extensive module library

```bash
# Recon-ng usage
recon-ng
workspaces create example_investigation
db insert domains
  domain: example.com
modules load recon/domains-hosts/hackertarget
modules load recon/domains-contacts/whois_pocs
modules load recon/hosts-hosts/resolve
run
show hosts
```

**OSINT Framework** (<https://osintframework.com/>):

- Comprehensive directory of OSINT tools
- Organized by category and use case
- Regularly updated resource list
- Free and accessible online

**SpiderFoot**:

- Automated OSINT collection
- 200+ modules for different data sources
- Web-based interface
- Correlation and relationship mapping

### Specialized Tools

**Image and Metadata Analysis**:

- **ExifTool**: Read/write metadata in images and files
- **Google Images Reverse Search**: Find similar images
- **TinEye**: Reverse image search
- **Yandex Images**: Often finds results Google misses
- **Jeffrey's Image Metadata Viewer**: Online EXIF viewer

**Dark Web and Monitoring**:

- **OnionScan**: Dark web OSINT tool
- **Hunchly**: Web capture tool for investigations
- **DarkOwl**: Dark web data intelligence
- **Intel 471**: Adversary and malware intelligence

**Data Breach Databases**:

- **Have I Been Pwned**: Check if email in known breaches
- **Dehashed**: Search for hashed and dehashed databases
- **LeakCheck**: Leaked credentials database
- **Snusbase**: Data breach search engine

## Practical OSINT Workflows

### Workflow 1: Company Reconnaissance

**Objective**: Gather comprehensive intelligence about target organization for penetration test.

A single starting point, the domain name, pivots into every other kind of
finding. Each arrow is a lookup whose output becomes the next lookup's input:

```text
  example.com
      │
      ├─ whois ──────────▶ registrant, netblocks, name servers
      │
      ├─ amass / crt.sh ─▶ subdomains ──▶ resolved IPs
      │                                       │
      │                                       ▼
      │                                shodan / censys:
      │                                open ports, banners,
      │                                software versions
      │
      ├─ LinkedIn ───────▶ employee names ──▶ email format,
      │                                       checked with
      │                                       theHarvester
      │
      └─ job ads, GitHub ▶ technology stack, internal tooling
```

**Steps**:

1. **Domain Discovery**:

   ```bash
   whois example.com
   amass enum -d example.com
   sublist3r -d example.com
   ```

2. **Employee Enumeration**:
   - Search LinkedIn for employees
   - Extract names and roles
   - Generate email addresses based on format
   - Use theHarvester for email validation

3. **Technology Stack Identification**:
   - Analyze job postings for required skills
   - Check Wappalyzer on company websites
   - Review GitHub repositories
   - Search BuiltWith and similar services

4. **Infrastructure Mapping**:

   ```bash
   shodan search "hostname:example.com"
   censys search "parsed.names:example.com"
   ```

5. **Document and Analyze**:
   - Create relationship maps in Maltego
   - Document findings in structured format
   - Identify potential entry points
   - Prioritize targets

### Workflow 2: Person of Interest Investigation

**Objective**: Build comprehensive profile of individual for security assessment.

**Steps**:

1. **Initial Discovery**:
   - Search full name in search engines
   - Check social media platforms
   - Run username through Sherlock

2. **Social Media Analysis**:
   - Collect all public posts and interactions
   - Note connections and relationships
   - Identify patterns in behavior and interests
   - Extract photos for metadata analysis

3. **Public Records Search**:
   - Property records
   - Court documents
   - Voter registration
   - Business registrations

4. **Digital Footprint**:

   ```bash
   # Check data breaches
   h8mail -t person@email.com

   # Username enumeration
   sherlock person_username

   # Historical data
   # Check Wayback Machine for old profiles
   ```

5. **Synthesis**:
   - Create timeline of activities
   - Map relationships and associations
   - Identify security questions answers
   - Note potential social engineering vectors

### Workflow 3: Threat Actor Attribution

**Objective**: Identify and profile threat actor based on available indicators.

**Steps**:

1. **IOC Collection**: Gather IP addresses, domains, usernames from incident
2. **Infrastructure Analysis**: Map threat actor infrastructure using passive DNS
3. **OPSEC Failures**: Look for re-used credentials, usernames, patterns
4. **Dark Web Research**: Search forums, marketplaces for related activity
5. **Correlation**: Link findings to known threat groups using MISP, AlienVault OTX

## Hands-on Exercise

### Exercise 1: Self-OSINT Audit

Perform comprehensive OSINT on yourself to understand your digital footprint:

1. **Google yourself**: Use your name in quotes with variations
2. **Social media audit**: List all platforms where you have accounts
3. **Data breach check**: Run email through Have I Been Pwned
4. **Username search**: Use Sherlock on your common usernames
5. **Image search**: Reverse search your profile photos
6. **Public records**: Search for your name in public databases
7. **Professional presence**: Check LinkedIn, GitHub, portfolio sites

**Document**:

- What information is publicly available?
- What could be used for social engineering?
- What should be removed or made private?
- How accurate is the information?

### Exercise 2: Company OSINT

Choose a company (with permission) and conduct basic OSINT:

1. Run WHOIS and DNS enumeration
2. Enumerate subdomains using Sublist3r
3. Search Shodan for exposed services
4. Identify 5-10 employees on LinkedIn
5. Determine email format
6. Identify technologies from job postings
7. Create simple organizational chart

### Exercise 3: Geolocation Challenge

Take a photo (or find one online) and attempt to geolocate it:

1. Extract EXIF data using ExifTool
2. Identify landmarks and distinctive features
3. Use Google Images reverse search
4. Compare with Google Street View
5. Determine approximate location
6. Verify using multiple sources

## Ethical Considerations

### Legal Boundaries

- **Public vs. Private**: Just because information is accessible doesn't mean collecting it is legal
- **Terms of Service**: Scraping websites may violate ToS (civil, not criminal issue)
- **Computer Misuse Laws**: The CFAA (U.S.) and the Computer Misuse Act (U.K.)
  target unauthorised *access*, not search itself. Collecting data from a page
  that is open to everyone is a different act from logging in, guessing a URL
  behind an access control, or using credentials found in a breach dump. The
  second group is where criminal liability starts
- **Data Protection**: GDPR in EU restricts certain types of data collection
- **Purpose Matters**: Collecting for security research vs. harassment has different legal implications

### Ethical Guidelines

1. **Respect Privacy**: Don't cross into stalking or harassment
2. **Use Responsibly**: Information can harm individuals if misused
3. **Consider Impact**: Think about consequences of your OSINT activities
4. **Lawful Purpose**: Only conduct OSINT for legitimate reasons
5. **Transparent Intent**: Be honest about why you're collecting information
6. **Secure Storage**: Protect gathered intelligence appropriately
7. **Minimize Harm**: Avoid unnecessary exposure of personal information

### OSINT for Defense

Organizations should conduct OSINT on themselves:

- **Information Leakage Audit**: What's exposed about your organization?
- **Employee Exposure**: Are staff oversharing on social media?
- **Shadow IT Discovery**: Find forgotten or unknown assets
- **Brand Monitoring**: Detect impersonation and fraud
- **Data Breach Monitoring**: Check for leaked credentials
- **Competitive Intelligence**: Understand how competitors see you

## Defensive Measures

### Personal Protection

- **Privacy Settings**: Configure social media for maximum privacy
- **Separate Accounts**: Use different emails/usernames for different purposes
- **Photo Metadata**: Remove EXIF data before posting images
- **Information Hygiene**: Limit what you share publicly
- **Unique Passwords**: Prevent credential stuffing from breaches
- **Google Yourself**: Regular self-OSINT to find exposures
- **Data Broker Opt-Out**: Remove yourself from people search sites

### Organizational Protection

- **Employee Training**: Educate on OSINT risks and social media best practices
- **Information Classification**: Limit what's publicly disclosed
- **Job Posting Review**: Don't reveal too much technical detail
- **WHOIS Privacy**: Use privacy protection on domain registrations
- **Breach Monitoring**: Monitor for credential leaks
- **Vendor Assessment**: Understand third-party data exposure
- **Regular Audits**: Perform self-OSINT quarterly

## OSINT in the Kill Chain

OSINT *is* the Reconnaissance stage of the Cyber Kill Chain. It performs no
action against the target itself, but its output is what makes the next three
stages precise instead of generic:

```text
  OSINT output            Kill chain stage
  ─────────────────────   ──────────────────────────────────
  names, email format ──▶ Reconnaissance
  tech stack, versions ─▶ Weaponization   (which exploit, which lure)
  contact channels ─────▶ Delivery        (mail, phone, USB, portal)
  exposed services ─────▶ Exploitation    (where to aim it)
```

Note that only the first row is OSINT itself. The later rows are attacker
decisions *informed* by OSINT; the intelligence does not compromise anything
on its own.

Defenders should focus OSINT efforts on:

- Understanding attacker perspective
- Reducing attack surface exposure
- Detecting reconnaissance activities
- Building threat intelligence

## Key Takeaways

- OSINT turns publicly available information into intelligence you can act on
- Four main types: Personal, Organizational, Technical, and Geospatial
- Specialized tools exist for each OSINT task
- The legal and ethical limits matter as much as the technique
- OSINT serves both offensive and defensive security
- Everyone should understand their own digital footprint
- Organizations must balance transparency with security
- OSINT skills are transferable across many domains

## Additional Resources

### Books

- **"Open Source Intelligence Techniques"** by Michael Bazzell - Comprehensive OSINT methodology
- **"OSINT Essentials"** by Justin Seitz - Practical techniques and automation
- **"We Are Bellingcat"** by Eliot Higgins - Real-world OSINT investigations

### Websites and Frameworks

- **OSINT Framework**: <https://osintframework.com/> - Comprehensive tool directory
- **Bellingcat's Online Investigation Toolkit**: <https://bellingcat.gitbook.io/toolkit>
- **Intel Techniques**: <https://inteltechniques.com/> - Michael Bazzell's resources
- **Awesome OSINT**: <https://github.com/jivoi/awesome-osint> - Curated list of tools

### Online Courses and Training

- **SANS SEC487**: Open-Source Intelligence (OSINT) Gathering and Analysis
- **TryHackMe OSINT Room**: <https://tryhackme.com/room/ohsint>
- **Trace Labs**: OSINT CTF for missing persons (legal, ethical OSINT practice)

### Communities

- **r/OSINT** (Reddit): Active OSINT community
- **OSINT Curious**: Podcast and community project
- **Bellingcat**: Investigative journalism collective

### Tools Collections

- **Recon-ng Marketplace**: Built-in module marketplace
- **SpiderFoot Modules**: 200+ data source integrations
- **Maltego Transforms**: Extensible data transformation library

### Practice Resources

- **Sector035 OSINT Challenges**: Weekly OSINT puzzles
- **Geoguessr**: Geography and geolocation practice
- **Geolocation CTF Challenges**: Various online challenges

## Conclusion

OSINT matters more every year, because more information is published by default. A penetration tester uses it before an engagement, a defender uses it to see their own attack surface, and an incident responder uses it to attribute an attack. In all three cases the result depends less on the tools than on the analysis applied to what they return, and on staying inside the ethical and legal limits while collecting it.
