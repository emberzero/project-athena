# Comparison of Server Types: Cloud, Dedicated, and Shared Servers

## Introduction

In the realm of web hosting and server management, selecting the right type of server is crucial for the performance, security, and scalability of your applications and websites. This document compares three popular types of servers: cloud, dedicated, and shared servers, highlighting their pros and cons.

## Cloud Servers

Cloud Server: You pay for a service to scale your application
Dedicated Server: A single server for a application (not scalable)
Shared Server: A single server hosting multiple applications/projects

### Which one to use?

| Aspect                  | Cloud Servers                                         | Dedicated Servers                                      | Shared Servers                                                    |
| ----------------------- | ----------------------------------------------------- | ------------------------------------------------------ | ----------------------------------------------------------------- |
| **Pros**                |                                                       |                                                        |                                                                   |
| Scalability             | Easily scale resources up or down based on demand.    | -                                                      | -                                                                 |
| Cost-Effective          | Pay only for the resources you use.                   | -                                                      | Most affordable option, ideal for small websites.                 |
| High Availability       | Distributed architecture enhances reliability.        | -                                                      | -                                                                 |
| Flexibility             | Offers various services like storage and computing.   | -                                                      | -                                                                 |
| Speed of Deployment     | Quick setup and provisioning.                         | -                                                      | -                                                                 |
| Performance             | -                                                     | Dedicated resources ensure high performance.           | -                                                                 |
| Security                | -                                                     | More secure as resources are not shared.               | -                                                                 |
| Customization           | -                                                     | Full control to customize hardware and software.       | -                                                                 |
| Consistency             | -                                                     | Predictable performance without external influences.   | -                                                                 |
| No Resource Contention  | -                                                     | No competition for resources with other users.         | -                                                                 |
| Maintenance-Free        | -                                                     | -                                                      | Hosting provider manages maintenance and updates.                 |
| Ease of Use             | -                                                     | -                                                      | Simple to set up, often with user-friendly control panels.        |
| Integrated Services     | -                                                     | -                                                      | Often comes with bundled services like email hosting.             |
| **Cons**                |                                                       |                                                        |                                                                   |
| Variable Costs          | Can become expensive with increased usage.            | -                                                      | -                                                                 |
| Complexity              | Requires technical knowledge for management.          | -                                                      | -                                                                 |
| Security Concerns       | Shared infrastructure might pose data security risks. | -                                                      | Shared environment increases vulnerability.                       |
| Performance Variability | Performance can vary based on other users' workloads. | -                                                      | Performance can be affected by other websites on the same server. |
| Cost                    | -                                                     | Generally more expensive than cloud or shared options. | -                                                                 |
| Maintenance             | -                                                     | Requires more effort in maintenance and updates.       | -                                                                 |
| Inflexibility           | -                                                     | Scaling resources can be slow and costly.              | -                                                                 |
| Physical Limitations    | -                                                     | Limited by the physical hardware capabilities.         | -                                                                 |
| Limited Resources       | -                                                     | -                                                      | Shared resources can lead to performance issues.                  |
| Limited Control         | -                                                     | -                                                      | Less control over server configuration and software.              |

## Examples

### What to use when

| Scenario                            | Server Type               | Reason                                                                                                                  |
| ----------------------------------- | ------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **Student Project**                 | Shared Server             | Cost-effective and simple, suitable for low traffic and minimal resource needs.                                         |
| **Scalable High-Traffic App**       | Cloud Server              | Ideal for handling traffic spikes and growth, offers scalability and flexibility.                                       |
| **Small Developer's App**           | Shared, then Cloud Server | Start with shared for cost-efficiency, move to cloud for scalability as the app grows.                                  |
| **Business with Sensitive Data**    | Dedicated Server          | Provides robust security, high performance, and full customization for handling sensitive information and high traffic. |
| **Media-Rich Websites/Communities** | Dedicated Server          | Ensures fast loading of media content and can handle many concurrent users due to dedicated resources.                  |

### Price development

Prices are not accurate. Goal is to understand the development of the prices.

### Assumptions for the Scenario

1. **Starting DAUs (Daily Active Users)**: 500, increasing monthly.
1. **Growth Rate**: 20% increase in DAUs each month.
1. **Server Requirements**: Scale up as DAUs increase.

### Cloud Servers

- **Initial Setup**: 2 vCPUs, 4GB RAM, 50GB Storage.
- **Cost**: Starts at $50/month.
- **Scaling**: Upgrades as DAUs increase, impacting cost.

### Dedicated Servers

- **Initial Setup**: 4 vCPUs, 8GB RAM, 200GB Storage.
- **Cost**: Fixed at $200/month.
- **Scaling**: Limited by physical hardware; may need additional servers.

### Shared Servers

- **Initial Setup**: Standard shared hosting p\[ackage.
- **Cost**: Fixed at $20/month.
- **Scaling**: Limited; performance may degrade as DAUs increase.\]()

### Table: Monthly Overview of DAUs, Server Requirements, and Costs

| Month   | DAUs | Cloud Server Specs       | Cloud Cost | Dedicated Server Specs  | Dedicated Cost | Shared Server Specs | Shared Cost |
| ------- | ---- | ------------------------ | ---------- | ----------------------- | -------------- | ------------------- | ----------- |
| Month 1 | 500  | 2 vCPUs, 4GB RAM, 50GB   | $50        | 4 vCPUs, 8GB RAM, 200GB | $200           | Standard package    | $20         |
| Month 2 | 600  | 2 vCPUs, 4GB RAM, 50GB   | $50        | 4 vCPUs, 8GB RAM, 200GB | $200           | Standard package    | $20         |
| Month 3 | 720  | 4 vCPUs, 8GB RAM, 100GB  | $100       | 4 vCPUs, 8GB RAM, 200GB | $200           | Standard package    | $20         |
| Month 4 | 864  | 4 vCPUs, 8GB RAM, 100GB  | $100       | 4 vCPUs, 8GB RAM, 200GB | $200           | Standard package    | $20         |
| Month 5 | 1037 | 6 vCPUs, 12GB RAM, 150GB | $150       | 4 vCPUs, 8GB RAM, 200GB | $200           | Standard package    | $20         |
| Month 6 | 1244 | 8 vCPUs, 16GB RAM, 200GB | $200       | 4 vCPUs, 8GB RAM, 200GB | $200           | Standard package    | $20         |

![Graph](https://i.imgur.com/2taNsqp.png)

### Sources

<https://morefield.com/blog/pros-and-cons-of-cloud-computing/>
<https://www.cloudways.com/blog/wordpress-shared-vs-dedicated-vs-cloud-hosting/>
