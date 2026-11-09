# Assignment 2: Secure Code Review and Remediation

## Objective

You will review eight short pieces of vulnerable application code, identify every security flaw in
them, prove each flaw with a concrete attack input, and then rewrite the code so the flaw is gone.
Afterwards you will be able to read unfamiliar code with an attacker's eye and hand a developer a
fix that actually closes the hole rather than filtering one payload.

## Logistics

- **Work:** individual. You may discuss vulnerability classes with classmates; the analysis and
  the rewritten code must be yours.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module04_Assignment2.pdf`.

## Setup

- No target system is involved. Every snippet below is in this file, and the work is reading,
  writing and explaining code. Nothing to install, nothing to pay for, nothing to attack.
- If you choose to run a snippet to confirm a flaw, run it **only on your own machine or in a
  container you built yourself**, never on school infrastructure and never reachable from the
  network. Module 01 and Austrian StGB §118a, §126a and §126b cover why that boundary exists.
- Useful references: the OWASP Cheat Sheet Series, and lectures 3, 4 and 5 of this module, which
  cover every vulnerability class present below.
- The languages used are Python (Flask, Django), JavaScript (Express, Apollo) and PHP. You are not
  expected to be fluent in all three; the flaws do not depend on language trivia.

## Tasks

For **each** of the eight snippets, your report contains the following, under a heading naming the
snippet.

### 1. Findings

A table of every vulnerability you found in that snippet:

| # | Vulnerability | CWE | Line or construct | Severity |
| --- | --- | --- | --- | --- |

Several snippets contain more than one flaw, and some contain flaws from more than one class.

### 2. Explanation

For each finding, two to four sentences: what the code does wrong, what an attacker controls, and
what they reach as a result. Explain the mechanism, not the category name.

### 3. Proof of concept

For each finding, the concrete input or request that triggers it, in a code block - a payload
string, a JSON body, a crafted URL, a filename. State what you expect the application to do with
it. A finding without a proof of concept is an assertion, not a finding.

### 4. Secure rewrite

The corrected code for the whole snippet, as a code block, with short inline comments marking each
security-relevant change. Then three or four sentences on:

- which mechanism you relied on for each fix - prepared statements, an allow-list, output encoding,
  an authorisation check, a signed token with a verified algorithm, and so on;
- why that mechanism makes the attack impossible rather than merely inconvenient;
- any trade-off your fix introduces, such as broken existing behaviour or added dependencies.

Keep the rewrite recognisably the same program. Deleting a feature to remove its flaw is not a fix,
unless you argue the feature should not exist and say so.

### 5. Closing analysis

One page at the end of the report, answering:

- Which root cause appears in the largest number of the eight snippets, and what single practice
  would have prevented all of its instances?
- Two of the snippets fail in a way that no amount of input filtering would fix. Name them and
  explain what they need instead.

## Code Snippets to Analyze

### Snippet 1: User Authentication (Python/Flask)

```python
from flask import Flask, request, session, redirect
import sqlite3

app = Flask(__name__)
app.secret_key = 'dev'

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']

    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()

    query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
    cursor.execute(query)
    user = cursor.fetchone()

    if user:
        session['user_id'] = user[0]
        session['username'] = user[1]
        return redirect('/dashboard')
    else:
        return 'Invalid credentials', 401
```

### Snippet 2: User Profile Update (Node.js/Express)

```javascript
const express = require('express');
const app = express();

app.post('/api/users/:id', (req, res) => {
    const userId = req.params.id;
    const userData = req.body;

    // Check if user is authenticated
    if (!req.session.userId) {
        return res.status(401).json({ error: 'Not authenticated' });
    }

    // Update user in database
    User.findByIdAndUpdate(userId, userData, (err, user) => {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }
        res.json({ message: 'User updated', user: user });
    });
});
```

### Snippet 3: File Upload Handler (PHP)

```php
<?php
session_start();

if (!isset($_SESSION['user_id'])) {
    die('Not authenticated');
}

if (isset($_FILES['avatar'])) {
    $file = $_FILES['avatar'];
    $filename = $file['name'];
    $target = 'uploads/' . $filename;

    if ($file['size'] > 5000000) {
        die('File too large');
    }

    if (move_uploaded_file($file['tmp_name'], $target)) {
        $user_id = $_SESSION['user_id'];
        $query = "UPDATE users SET avatar='$target' WHERE id=$user_id";
        mysqli_query($conn, $query);

        echo "File uploaded successfully: <a href='$target'>View</a>";
    } else {
        echo 'Upload failed';
    }
}
?>
```

### Snippet 4: Search Functionality (Python/Django)

```python
from django.shortcuts import render
from django.http import HttpResponse
from .models import Product

def search(request):
    query = request.GET.get('q', '')

    if query:
        # Search products
        products = Product.objects.raw(
            f"SELECT * FROM products WHERE name LIKE '%{query}%' OR description LIKE '%{query}%'"
        )

        # Generate HTML response
        html = f"<h1>Search Results for: {query}</h1>"
        html += "<div class='results'>"

        for product in products:
            html += f"<div class='product'>"
            html += f"<h2>{product.name}</h2>"
            html += f"<p>{product.description}</p>"
            html += f"</div>"

        html += "</div>"

        return HttpResponse(html)

    return render(request, 'search.html')
```

### Snippet 5: API Endpoint (Node.js/Express)

```javascript
const express = require('express');
const app = express();
const jwt = require('jsonwebtoken');

const SECRET_KEY = 'mysecret';

app.post('/api/login', (req, res) => {
    const { username, password } = req.body;

    // Validate credentials (simplified)
    if (username === 'admin' && password === 'admin123') {
        const token = jwt.sign({ username, role: 'admin' }, SECRET_KEY);
        res.json({ token });
    } else {
        res.status(401).json({ error: 'Invalid credentials' });
    }
});

app.get('/api/admin/users', (req, res) => {
    const token = req.headers.authorization;

    if (token) {
        try {
            const decoded = jwt.decode(token);

            if (decoded.role === 'admin') {
                // Return all users
                User.find({}, (err, users) => {
                    res.json(users);
                });
            } else {
                res.status(403).json({ error: 'Forbidden' });
            }
        } catch (err) {
            res.status(401).json({ error: 'Invalid token' });
        }
    } else {
        res.status(401).json({ error: 'No token provided' });
    }
});
```

### Snippet 6: Password Reset (Python/Flask)

```python
from flask import Flask, request, render_template_string
import smtplib

app = Flask(__name__)

@app.route('/reset-password', methods=['GET', 'POST'])
def reset_password():
    if request.method == 'POST':
        email = request.form['email']

        # Check if email exists
        user = User.query.filter_by(email=email).first()

        if user:
            # Generate reset token
            reset_token = user.id  # SIMPLIFIED
            reset_link = f"https://example.com/reset/{reset_token}"

            # Send email
            message = f"Click here to reset your password: {reset_link}"
            send_email(email, "Password Reset", message)

            return f"Password reset link sent to {email}"
        else:
            return "Email not found"

    # GET request - show form
    template = """
    <html>
    <body>
        <h1>Password Reset</h1>
        <form method="POST">
            <input type="email" name="email" placeholder="Enter your email">
            <button type="submit">Reset Password</button>
        </form>
        <p>User searched for: %s</p>
    </body>
    </html>
    """ % request.args.get('search', '')

    return render_template_string(template)
```

### Snippet 7: Comment System (PHP)

```php
<?php
session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $comment = $_POST['comment'];
    $post_id = $_POST['post_id'];
    $user_id = $_SESSION['user_id'];

    // Save comment
    $query = "INSERT INTO comments (post_id, user_id, comment, created_at)
              VALUES ($post_id, $user_id, '$comment', NOW())";
    mysqli_query($conn, $query);

    header("Location: post.php?id=$post_id");
    exit;
}

// Display comments
$post_id = $_GET['id'];
$query = "SELECT c.comment, u.username, c.created_at
          FROM comments c
          JOIN users u ON c.user_id = u.id
          WHERE c.post_id = $post_id";

$result = mysqli_query($conn, $query);

echo "<h2>Comments</h2>";
while ($row = mysqli_fetch_assoc($result)) {
    echo "<div class='comment'>";
    echo "<strong>" . $row['username'] . "</strong> ";
    echo "<span>" . $row['created_at'] . "</span>";
    echo "<p>" . $row['comment'] . "</p>";
    echo "</div>";
}
?>

<form method="POST">
    <input type="hidden" name="post_id" value="<?php echo $_GET['id']; ?>">
    <textarea name="comment" required></textarea>
    <button type="submit">Post Comment</button>
</form>
```

### Snippet 8: GraphQL API (Node.js)

```javascript
const { ApolloServer, gql } = require('apollo-server');

const typeDefs = gql`
  type User {
    id: ID!
    username: String!
    email: String!
    password: String!
    ssn: String
    creditCard: String
    isAdmin: Boolean!
  }

  type Query {
    user(id: ID!): User
    users: [User]
  }

  type Mutation {
    updateUser(id: ID!, username: String, email: String, isAdmin: Boolean): User
  }
`;

const resolvers = {
  Query: {
    user: (parent, { id }, context) => {
      return User.findById(id);
    },
    users: () => {
      return User.find({});
    }
  },
  Mutation: {
    updateUser: (parent, args, context) => {
      const { id, ...updates } = args;
      return User.findByIdAndUpdate(id, updates, { new: true });
    }
  }
};

const server = new ApolloServer({
  typeDefs,
  resolvers,
  introspection: true,
  playground: true
});

server.listen().then(({ url }) => {
  console.log(`Server ready at ${url}`);
});
```

---

## Vulnerability classes in scope

These are the classes to look for. Which snippet holds which, and how many, is for you to find.

- SQL injection
- Cross-site scripting, reflected and stored
- Cross-site request forgery
- Insecure direct object reference and broken object level authorisation
- Mass assignment and excessive data exposure
- Path traversal and unrestricted file upload
- Broken authentication and insecure credential storage
- Broken function level authorisation
- Information disclosure
- Weak or missing cryptography, including predictable tokens
- Server-side template injection
- JWT verification and algorithm flaws
- GraphQL schema and authorisation exposure

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Completeness of findings** | 20% | Every significant flaw in all eight snippets found, including the second and third flaw in the snippets that have more than one, with no invented findings padding the table. |
| **Accuracy of classification** | 10% | Correct vulnerability class and a correct CWE identifier for each finding, anchored to the specific line or construct. |
| **Explanation quality** | 15% | Each explanation states what the attacker controls and what it reaches, describing the mechanism rather than restating the class name. |
| **Proofs of concept** | 15% | A concrete, plausible attack input for every finding, with the expected effect stated. |
| **Secure rewrites** | 25% | Every rewrite closes all of that snippet's flaws, preserves the original functionality, and would pass review in a real project. |
| **Reasoning about fixes** | 10% | The mechanism behind each fix named correctly, with a defensible argument for why it is sufficient and an honest note on trade-offs. |
| **Report quality** | 5% | Findings tables complete, closing analysis answered, all code in fenced blocks with the right language tag, readable throughout. |
| **Bonus** | +20% | See below. |

A rewrite that escapes a quote character scores badly where a prepared statement was available. The
assignment rewards fixes that remove the attacker's reach, not fixes that block today's payload.

## Bonus: Prove one fix works (up to +20%)

Pick **one** snippet. Build it, run it, break it, fix it, and fail to break it again.

1. Stand the vulnerable snippet up on your own machine or in a container you wrote the Dockerfile
   for. It must not be reachable from the network.
2. Demonstrate the exploit against the vulnerable version: the request you sent and the response or
   state change proving it worked.
3. Deploy your rewritten version and show the same attack failing, plus evidence that the feature
   still works for legitimate input.
4. Write a regression test - any framework, or a plain script with assertions - that fails against
   the vulnerable version and passes against yours. Include it in the report.

### Bonus evaluation

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Working exploit** | +7% | The attack demonstrated against the running vulnerable version with evidence of its effect. |
| **Verified fix** | +7% | The same attack shown failing against the rewrite, with legitimate functionality still working. |
| **Regression test** | +6% | A test that genuinely distinguishes the two versions, included in full and explained in two sentences. |

## Resources

- OWASP Cheat Sheet Series: <https://cheatsheetseries.owasp.org/>
- OWASP Top 10: <https://owasp.org/www-project-top-ten/>
- OWASP API Security Top 10: <https://owasp.org/www-project-api-security/>
- CWE list: <https://cwe.mitre.org/>
- PortSwigger Web Security Academy: <https://portswigger.net/web-security>
