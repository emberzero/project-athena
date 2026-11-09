# Assignment 1: Hardening and Auditing a Containerised Service

## Objective

You will take a deliberately badly built container image, measure what is wrong with it, and
rebuild it so that the same application runs with a minimal base image, a non-root user, no
secrets baked into the layers and no known high-severity vulnerabilities. You will then place the
image into a pipeline check that fails on a bad build, write a least-privilege deployment identity
for it, and state which parts of the resulting cloud deployment are yours to secure and which
belong to the provider.

## Logistics

- **Work:** individual, or in pairs. Pairs hand in one report naming both authors, and each
  partner's own image digests must appear in it.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module17_Assignment1.pdf`.

## Setup

Everything in this assignment runs on your own machine and costs nothing.

- **Docker** (Docker Desktop, Docker Engine, Podman or Rancher Desktop). All examples use the
  `docker` command; `podman` accepts the same arguments.
- **Trivy** or **Grype** for image scanning. Both are open source and both run as a container, so
  no separate install is required:

  ```bash
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
    aquasec/trivy image --severity HIGH,CRITICAL <your-image-tag>
  ```

- A **Git repository** you own, on GitHub or GitLab, for Task 5. A free account is enough. If you
  cannot or do not want to create one, Task 5 may be handed in as the pipeline file plus a local
  run of the same commands in a shell, with the output pasted into the report.
- No cloud account is needed. Tasks 4 and 6 are written against a cloud deployment on paper,
  because a provider free tier requires a credit card and you are not asked to supply one.

Mounting the Docker socket into the scanner container is exactly the pattern Lecture 4 warns
about. State in your report, in one sentence, why it is acceptable here and would not be in
production.

## The starting image

Create this file yourself as `vuln.Dockerfile`. Do not fix anything in it yet.

```dockerfile
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y python3 python3-pip curl git

ARG API_TOKEN=athena-demo-token-replace-me
RUN mkdir -p /app && echo "API_TOKEN=${API_TOKEN}" > /app/.env

WORKDIR /app
COPY app.py /app/app.py

EXPOSE 8080
CMD ["python3", "/app/app.py"]
```

And `app.py`, the application you must keep working:

```python
from http.server import BaseHTTPRequestHandler, HTTPServer
import os


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.end_headers()
        self.wfile.write(f"ok uid={os.getuid()}\n".encode())


HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
```

Build it as `athena-bad:<your-lastname>` so your tags and digests are your own.

## Rules of engagement

- Everything runs in containers on your own machine, against your own repository.
- Do not scan, pull apart or point tooling at a school system, a classmate's machine, or any
  third-party registry account that is not yours.
- Do not put a real credential anywhere in this assignment, not even a revoked one. The token in
  the starting Dockerfile is a placeholder and must stay a placeholder.
- The legal frame is the one from Module 01: StGB §118a, §126a and §126b apply to systems that are
  not yours, including ones you can reach by accident from a container.

## Tasks

### 1. Baseline the bad image

Build `athena-bad` and record, in a table: image size, the user the process runs as, the base image
and its tag, and the number of HIGH and CRITICAL findings from your scanner. Then show that the
build-time secret is still readable in the finished image:

```bash
docker history --no-trunc athena-bad:<lastname>
docker run --rm athena-bad:<lastname> cat /app/.env
docker run --rm athena-bad:<lastname> id
```

**Deliverable:** the baseline table plus the three command outputs, with the leaked token line and
the `uid=0` visible.

### 2. Name the defects

List at least six distinct security defects in `vuln.Dockerfile`. For each one give the line, the
concrete consequence (not "it is insecure"), and the control that removes it. Use the categories
from Lecture 4: image provenance, patch level, least privilege, secrets, filesystem, capabilities.

**Deliverable:** a table with the columns defect, line, consequence, control.

### 3. Rebuild it properly

Write `hardened.Dockerfile` so that the same `GET /` response still works. It must at minimum:

- pin a minimal base image by digest, not by a floating tag
- install nothing it does not need, and leave no package manager cache behind
- create and run as a non-root user
- contain no secret in any layer
- declare a `HEALTHCHECK`

Then run the container with a read-only root filesystem, all capabilities dropped, and no new
privileges:

```bash
docker run --rm -p 8080:8080 --read-only --cap-drop ALL \
  --security-opt no-new-privileges hardened:<lastname>
curl -s localhost:8080
```

**Deliverable:** the full `hardened.Dockerfile`, the `curl` output showing a non-zero uid, the new
size and scan counts next to the baseline ones, and the output of `docker history` showing no token.
Prove the secret is gone from the layers, not merely deleted in a later one.

### 4. Supply the secret at runtime instead

Pass the placeholder token to the running container without it entering the image, using an
environment file or a mounted secret, and show that `docker history` on the image still reveals
nothing. Then name, from Lecture 4, the managed secret store you would use for each of the three
providers in production, and explain in two sentences why a Kubernetes `Secret` on its own is not
one.

**Deliverable:** the run command, the proof the image is clean, and the short written answer.

### 5. Make the pipeline enforce it

Add a CI workflow to your own repository that builds `hardened.Dockerfile` and fails the job when
the scanner reports a HIGH or CRITICAL finding. Prove it works both ways: one run that passes, and
one deliberately broken run (an old base image, for instance) that fails.

**Deliverable:** the workflow file, and a screenshot or log excerpt of both runs with their commit
hashes. Map each step of your workflow onto the pipeline stages in Lecture 6.

### 6. Draw the responsibility line

Assume the hardened image is deployed as a managed container service in one provider of your
choice. Produce a shared-responsibility table with at least eight rows covering: host kernel
patching, base-image patching, the application code, network rules, secrets, logs, backups and
identity. Mark each row provider or customer, and justify the three you find least obvious.

Then write the deployment identity as a least-privilege policy: the identity the pipeline uses to
push the image and update the service, and nothing else. Use the real syntax of your chosen
provider, name the resource scope explicitly, and say in one sentence what the identity could do if
you had instead granted a basic or broad role.

**Deliverable:** the table, the policy document, and the one-sentence consequence.

## Report

Structure it as: introduction, baseline, defect table, hardened build with before and after
numbers, runtime secret handling, pipeline evidence, responsibility table and policy, conclusion.
Every claim about your own build needs the command and its output next to it. Export to PDF.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| Baseline evidence | 10% | Baseline table complete, and the leaked token plus `uid=0` shown from the student's own tagged image. |
| Defect analysis | 20% | Six or more distinct real defects, each with a concrete consequence and the matching control, no padding. |
| Hardened image | 25% | Digest-pinned minimal base, non-root, no secret in any layer, healthcheck, runs read-only with capabilities dropped, and the service still answers. |
| Secret handling | 10% | Secret supplied at runtime with proof the image is clean, and the managed-store answer is correct for all three providers. |
| Pipeline | 15% | Workflow fails on a HIGH or CRITICAL finding and passes otherwise, both runs evidenced, stages mapped to the lecture pipeline. |
| Responsibility and IAM | 15% | Eight-row table with correct allocation, and a policy that grants only push and update on a named scope. |
| Report quality | 5% | Clear structure, readable, every assertion backed by its own output. |

## Bonus (up to +20%)

Pick one:

- **Rootless and distroless.** Rebuild as a multi-stage image on a distroless or `scratch` base,
  run the container rootless, and report the size and attack-surface difference against your
  Task 3 image. Explain what you lost by removing the shell.
- **Runtime detection.** Run your hardened container, trigger something a container should never do
  (writing to the root filesystem, or an unexpected outbound connection), and show it being caught
  by a free runtime monitoring or logging setup of your choice. Include the alert or log line and
  state what you would have it page a human for.
