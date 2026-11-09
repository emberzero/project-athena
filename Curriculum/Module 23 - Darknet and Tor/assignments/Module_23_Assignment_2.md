# Assignment: Host and Analyse Your Own Onion Service

## Objective

In this lab you run your own onion service in Docker, reach it through Tor, and observe what the network can and cannot see. You will connect what you see to Lectures 2 and 3: onion addresses, circuits, and the difference between Tor and a direct connection.

## Logistics

- **Work:** individual or in pairs (state both names).
- **Deadline:** _set by your instructor_.
- **Submission:** one PDF, named `Lastname_Firstname_Module23_Assignment2.pdf`, with screenshots and answers to all questions.
- **Requirements:** Docker with Docker Compose, and Tor Browser (<https://www.torproject.org/download/>).

**Rules:**

- Your onion service must only serve the harmless page provided (you may change its text). Do not host anything else.
- Visit only your own service, a classmate's service, and the legitimate services named in this assignment.
- Stop and delete the lab when you are done (step 7).

> **Note for instructors:** school networks often block Tor. If students cannot bootstrap, try the built-in Snowflake or obfs4 bridges in Tor Browser and add `UseBridges` lines to the `torrc`, or let students do the lab at home.

## Lab Files

The folder `Assignment_2/` contains:

```text
Assignment_2/
  docker-compose.yml   nginx (the website) and tor (the onion service)
  Dockerfile           Debian with tor and curl
  torrc                Tor configuration
  site/index.html      the page your service will serve
```

The `tor` container shares the network of the `web` container, so for Tor the website is simply `127.0.0.1:80`. The web server publishes **no port** on your computer: the page is only reachable through Tor.

## Instructions

### 1. Read the Configuration

Open `torrc` and `docker-compose.yml`.

- Explain each line of `torrc` in your own words.
- Why does the web service have no `ports:` entry? What could happen to an onion service if its web server were also reachable on a public IP address? (Lecture 3)

### 2. Start the Service

Put your name in `site/index.html`, then start the lab:

```bash
docker compose up -d --build
docker compose logs -f tor        # wait for "Bootstrapped 100% (done)", then Ctrl+C
docker compose exec tor cat /var/lib/tor/hs/hostname
```

- Include the onion address in your report.
- How many characters does it have? Explain what the characters encode (public key, checksum, version).
- List the files in `/var/lib/tor/hs/` (`docker compose exec tor ls -l /var/lib/tor/hs/`). Which file must never leak, and what could an attacker do with it?

### 3. Reach Your Service

First from the command line, through Tor's SOCKS proxy inside the container:

```bash
ONION=$(docker compose exec tor cat /var/lib/tor/hs/hostname | tr -d '\r')
docker compose exec tor curl --socks5-hostname 127.0.0.1:9050 "http://$ONION/"
```

Then open the address in Tor Browser and take a screenshot.

- Click the site information (the icon left of the address) and view the Tor circuit. How many relays are shown, and why does Tor Browser show fewer than the six relays from Lecture 3?
- Use "New Tor circuit for this site" a few times. What changes, what stays the same, and why? (Hint: guards.)
- Why does a connection to an onion service not need HTTPS for authentication, even though it is `http://`?

### 4. What the Network Sees

Capture traffic in the shared network namespace while you fetch the page again. Open a second terminal:

```bash
docker run --rm --net container:$(docker compose ps -q web) nicolaka/netshoot \
  tcpdump -n -i eth0 -c 40 'not port 53'
```

In the first terminal, repeat the `curl` command from step 3.

Then capture a direct connection for comparison:

```bash
docker run --rm --net container:$(docker compose ps -q web) nicolaka/netshoot \
  tcpdump -n -i any -c 40 -A 'port 53 or port 80'
# second terminal:
docker compose exec tor curl -s http://example.com/ > /dev/null
```

- In the Tor capture, which IP addresses does your container talk to? Look one of them up in Relay Search (<https://metrics.torproject.org/rs.html>). What flags does it have?
- Can you find the onion address or any page content in the Tor capture? Why not?
- What can you read in the direct capture? Which of this would your ISP see?

### 5. Reach the Normal Internet Through Tor

```bash
docker compose exec tor curl -s --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/api/ip
docker compose exec tor curl -s https://check.torproject.org/api/ip
```

- Explain the difference between the two outputs.
- Replace `--socks5-hostname` with `--socks5` in the first command. It still works. What has changed, and why is this a leak? (Lecture 2)

### 6. Legitimate Onion Services

Look up the official onion addresses of **two** of the following on their normal websites, and open them in Tor Browser: The Tor Project, DuckDuckGo, BBC, Deutsche Welle, ProPublica.

- Where exactly did you find each address (URL)? Did the site offer an Onion-Location (".onion available") button?
- Why is it important to get the address from the organization's own website and not from a link list? (Lecture 3, phishing)

### 7. Clean Up

```bash
docker compose down -v
```

The `-v` deletes the volume with your service's private key. Explain why that means the onion address is gone for good, and what you would have to back up to keep the same address.

## Evaluation Criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Working service** | 20% | Onion address, curl output and Tor Browser screenshot are included and consistent. |
| **Configuration and addressing** | 20% | Correct explanations of `torrc`, the address structure and the role of the private key. |
| **Traffic analysis** | 30% | Captures are included and interpreted correctly; the difference between Tor and direct traffic is explained using the lecture concepts. |
| **Circuits, leaks and phishing** | 20% | Correct answers on circuits, guards, DNS leaks and verifying onion addresses. |
| **Report quality** | 10% | Clear structure, readable screenshots, every question answered. |
| **Bonus** | +15% | See below. |

## Bonus: Client Authorization

Restrict your service so that only you can reach it (Lecture 3, client authorization). Follow the Tor Project's guide: <https://community.torproject.org/onion-services/advanced/client-auth/>.

- Generate an x25519 key pair, put the public part in `/var/lib/tor/hs/authorized_clients/` and restart the service.
- Show that the address no longer opens in Tor Browser without the key, and does open once you enter the private key.
- Explain why an attacker who knows the address cannot even find the introduction points.
