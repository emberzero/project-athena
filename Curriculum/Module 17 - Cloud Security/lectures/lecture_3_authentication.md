# User and Permission Management in Cloud Platforms

How to manage users easily and securely in the cloud?

## 1. Google Cloud Platform (GCP)

### 1.1. **Identity and Access Management (IAM)**

<https://cloud.google.com/iam>

![Google IAM Overview](https://storage.googleapis.com/gweb-cloudblog-publish/images/image1_copy_3.max-2000x2000.jpg)

- **Roles**: Predefined sets of permissions that determine what actions are allowed on resources.

  - **Primitive Roles**: Basic roles like Owner, Editor, Viewer.
  - **Predefined Roles**: Specific to GCP services (e.g., `roles/pubsub.publisher`, CloudSQL Admin/Viewer)
  - **Custom Roles**: Customized sets of permissions.

- **Policies**: Define who (identity) has what access (role) for resources.

- **Members**: Users, groups (multiple users), domains (projects belong to a domain), or service accounts (accounts for programs to automate tasks or to represent services).

### 1.2. **Cloud Identity**

- Provides identity services like user enrollment, account recovery, and multi-factor authentication.
- Manages users and groups and ties in with IAM for permissions.

### 1.3. **Organization**

![Organization](https://ermetic.com/wp-content/uploads/2022/04/image3-1.png)

## 2. Amazon Web Services (AWS)

### 2.1. **Identity and Access Management (IAM)**

<https://aws.amazon.com/de/iam/>

- **Users**: End-users or services that interact with AWS resources.

- **Groups**: Collections of users with shared permissions.

- **Roles**: Not tied to a specific user or group, but can be assumed by authorized entities.

- **Policies**: JSON documents that define permissions. Can be attached to users, groups, or roles.

### 2.2. **Organizations & Service Control Policies (SCPs)**

- **Organizations**: Allow managing multiple AWS accounts centrally.

- **SCPs**: Control the maximum available permissions for accounts in an organization.

### 2.3. **AWS Single Sign-On (SSO)**

- Centralized management for user access to AWS accounts and business applications.

## 3. Microsoft Azure

<https://www.microsoft.com/de-de/security/business/identity-access/microsoft-entra-id>

### 3.1. **Azure Active Directory (Azure AD)**

- **Users**: Individuals with a profile in Azure AD.

- **Groups**: Collections of users with shared access.

- **Enterprise Applications**: Pre-integrated SaaS apps.

- **App Registrations**: Integrations for custom-developed applications.

### 3.2. **Role-Based Access Control (RBAC)**

- **Roles**: Collections of permissions that can be assigned to users, groups, or service principals.

  - Built-in roles like Owner, Contributor, Reader.
  - Custom roles.

- **Scope**: Levels at which access can be granted - Management group, Subscription, Resource group, Resource.

### 3.3. **Azure Policy & Blueprints**

- **Azure Policy**: Create, assign, and manage policies to enforce organizational requirements.

- **Blueprints**: Package artifacts like policies, role assignments, and templates to speed up environment setup.
