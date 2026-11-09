# Secure DevOps in the Cloud

## Introduction

DevSecOps, a blend of development, security, and operations, means building security into every step of creating and running software, instead of treating it as a review gate shortly before release. The practical argument for it is cost: a flaw found while the developer is still writing the code is cheap to fix, the same flaw found in production is not.

![DevSecOps | CyberRes](https://pnx-assets-prod.s3.amazonaws.com/2022-03/security_matters_in_devops_0.png)

## Security Checks Along the Pipeline

In practice, DevSecOps means each stage of the pipeline has its own automated
security check, and a failing check breaks the build like any other test:

```text
  Plan  -->  Code  -->  Build  -->  Test  -->  Deploy  -->  Operate
   |          |          |           |           |            |
   v          v          v           v           v            v
  threat     secret     dependency  DAST and   signed       runtime
  model,     scanning,  (SCA) scan, IaC        images,      monitoring,
  security   SAST in    image scan  config     least-       log review,
  stories    the IDE                checks     privilege    drift
                                               deploy       detection
```

Each stage also needs a named owner and a defined failure action, otherwise
the checks turn into a wall of warnings that everyone learns to ignore. The
approach involves bringing security people in at the planning stage,
automating the checks above, and giving developers feedback inside their own
tooling rather than in a report weeks later.

![Software Development Life Cycle Models and Methodologies - Mohamed Sami](https://i0.wp.com/melsatar.blog/wp-content/uploads/2012/03/sdlc.png?fit=830%2C374&ssl=1)

## Automation

To handle the complexity of short and frequent development cycles, organizations turn to automation. Automating repetitive tasks speeds the work up and applies the security checks consistently, from source control through to deployment.

## Security for Containers and Microservices

With the rise of container technologies, like Docker, and microservices, DevSecOps needs to adapt. Security must now be continuous and integrated at every stage. This means securing the environment, data, and the entire continuous integration/continuous delivery (CI/CD) process.

## Simple Steps for DevSecOps

1. **Environment and Data Security:**
   - Keep things standardized and automated.
   - Control user access centrally.
   - Isolate containers and encrypt data between apps and services.
   - Implement secure API gateways to increase visibility.
1. **CI/CD Process Security:**
   - Integrate security scanners for containers.
   - Automate security testing in the CI process.
   - Include security tests in the acceptance test process.
   - Automate updates for known vulnerabilities.
   - Implement automated system and service configuration management.
