# Overview of Cloud Security

Cloud security covers the policies, technologies, and procedures that protect data, applications, and infrastructure in cloud environments. What makes it different from classic on-premises security is that you no longer control the whole stack: the provider runs part of it, and you are responsible for the rest. Which part is yours depends on the service model.

## Cloud Security

The goals are the familiar ones: confidentiality, integrity, and availability of data, applications, and networks, applied to resources that run on someone else's hardware.

### Key Concepts

Three service models are in common use.

- **IaaS (Infrastructure as a Service)**: virtualized computing resources delivered over the
  internet. Examples are Google Cloud Compute Engine, Amazon EC2 (Elastic Compute Cloud) and
  Microsoft Azure Virtual Machines, all of which hand you scalable virtual machines on demand.
- **PaaS (Platform as a Service)**: a platform for developing and running applications, with the
  runtime and the operating system managed for you. Examples are Google App Engine, Heroku (which
  supports several programming languages) and Microsoft Azure App Service.
- **SaaS (Software as a Service)**: finished software applications delivered over the internet.
  Examples are Google Workspace (Gmail, Drive and the collaboration tools), Salesforce for customer
  relationship management, and Dropbox for file storage.

The service model decides where the provider's responsibility stops and
yours begins. Read the stack from the bottom (hardware) upwards:

```text
  Layer                        IaaS      PaaS      SaaS
  ------------------------------------------------------------
  Your data + user accounts    you       you       you
  Application code             you       you       provider
  Runtime / libraries          you       provider  provider
  Operating system             you       provider  provider
  Hypervisor / virtualisation  provider  provider  provider
  Servers, storage, network    provider  provider  provider
  Physical data centre         provider  provider  provider
```

Note that the top row never moves: no service model takes responsibility
for your data classification, access rules, or user accounts away from you.

The deployment model says who owns the hardware and who else runs on it.

- **Public cloud**: a third-party provider owns and operates the resources and sells them to anyone.
  Google Cloud Platform (GCP), Amazon Web Services (AWS) and Microsoft Azure all do this across
  compute, storage and networking.
- **Private cloud**: cloud resources dedicated to a single organization. VMware Cloud on AWS puts
  VMware's private cloud stack on AWS infrastructure; Oracle Cloud at Customer puts Oracle's public
  cloud services in the organization's own data center.
- **Hybrid cloud**: public and private resources used together. AWS Outposts runs AWS infrastructure
  on premises, Azure Arc extends Azure management to other infrastructure, and Google Anthos manages
  on-premises and other public clouds from GCP.

### Services in the public cloud

- **Serverless computing**: run code without managing the infrastructure under it. It scales with
  demand, and you are billed only for the resources the code actually consumes while running.
- **Object storage**: scalable storage for large amounts of unstructured data such as documents,
  images and videos, with high durability and availability.
- **Virtual machines (compute)**: on-demand computing resources for running applications in a
  virtualized environment, with a free choice of operating system and software configuration.
- **Managed container orchestration**: deployment, scaling and management of containerized
  applications, including automatic load balancing, rolling updates and self-healing.
- **Managed database services**: scalable databases where the provider handles patching, backups
  and maintenance.
- **Integration and workflow**: services that connect applications and systems to each other, so
  business processes, data flows and communication between components can be automated.
- **Serverless file storage**: managed, scalable file systems that remove the need to run file
  servers and integrate with serverless applications.
- **Content delivery network (CDN)**: distributes content such as images and videos across servers
  worldwide, cutting latency by serving each user from the nearest one.
- **Machine learning and AI services**: tools, frameworks, pre-built models, APIs and infrastructure
  for building, training and deploying machine learning models inside an application.
- **Serverless event processing**: creation, routing and processing of events at scale, used to
  build event-driven architectures for real-time applications.

### Sources

1. [Wikipedia "Cloud Computing"](https://en.wikipedia.org/wiki/Cloud_computing)
1. [GCP Documentation](https://cloud.google.com/docs?hl=en)
