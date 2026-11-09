# User and Permission Management in Cloud Platforms

All three major providers solve the same problem in the same shape: an identity is granted a named set of permissions on a scoped resource. Only the vocabulary differs.

## 1. Google Cloud Platform (GCP)

### 1.1. Identity and Access Management (IAM)

<https://cloud.google.com/iam>

![Google IAM Overview](https://storage.googleapis.com/gweb-cloudblog-publish/images/image1_copy_3.max-2000x2000.jpg)

- **Roles**: Predefined sets of permissions that determine what actions are allowed on resources.

  - **Basic Roles** (older documentation calls these *primitive* roles): Owner, Editor, Viewer. They are very broad and should not be used in production projects.
  - **Predefined Roles**: Specific to GCP services (e.g., `roles/pubsub.publisher`, CloudSQL Admin/Viewer)
  - **Custom Roles**: Customized sets of permissions.

- **Policies**: Define who (identity) has what access (role) for resources.

- **Members** (newer documentation calls these *principals*): individual
  user accounts, groups (multiple users), a whole domain (every account in a
  Google Workspace or Cloud Identity domain), or service accounts (identities
  used by programs and services rather than people).

A binding ties those three things together:

```text
  Who                     may do what            on which resource
  +-------------------+   +-----------------+   +-----------------+
  | user, group,      |   | role: a named   |   | organisation,   |
  | whole domain, or  | + | set of          | + | folder, project |
  | service account   |   | permissions     |   | or one bucket   |
  +-------------------+   +-----------------+   +-----------------+
             |
             +--> the three together form one IAM policy binding,
                  attached to the resource and inherited by every
                  child resource below it in the hierarchy
```

Inheritance is the part most often misunderstood: a role granted at the
organisation or folder level applies to every project underneath it. IAM
allow policies only ever add permissions, so a broad grant higher up
cannot be withdrawn by a narrower allow policy further down. Restricting it
again needs a separate mechanism (an IAM deny policy or an organisation
policy constraint).

### 1.2. Cloud Identity

- Provides identity services like user enrollment, account recovery, and multi-factor authentication.
- Manages users and groups and ties in with IAM for permissions.

### 1.3. Organization

![Organization](https://ermetic.com/wp-content/uploads/2022/04/image3-1.png)

## 2. Amazon Web Services (AWS)

### 2.1. Identity and Access Management (IAM)

<https://aws.amazon.com/de/iam/>

- **Users**: End-users or services that interact with AWS resources.

- **Groups**: Collections of users with shared permissions.

- **Roles**: Not tied to a specific user or group, but can be assumed by authorized entities.

- **Policies**: JSON documents that define permissions. Can be attached to users, groups, or roles.

### 2.2. Organizations & Service Control Policies (SCPs)

- **Organizations**: Allow managing multiple AWS accounts centrally.

- **SCPs**: Control the maximum available permissions for accounts in an organization.

### 2.3. AWS IAM Identity Center (formerly AWS Single Sign-On)

- Centralized management for user access to AWS accounts and business applications.

## 3. Microsoft Azure

<https://www.microsoft.com/de-de/security/business/identity-access/microsoft-entra-id>

### 3.1. Microsoft Entra ID (formerly Azure Active Directory)

- **Users**: Individuals with a profile in Entra ID.

- **Groups**: Collections of users with shared access.

- **Enterprise Applications**: Pre-integrated SaaS apps.

- **App Registrations**: Integrations for custom-developed applications.

### 3.2. Role-Based Access Control (RBAC)

- **Roles**: Collections of permissions that can be assigned to users, groups, or service principals.

  - Built-in roles like Owner, Contributor, Reader.
  - Custom roles.

- **Scope**: Levels at which access can be granted - Management group, Subscription, Resource group, Resource.

### 3.3. Azure Policy & Blueprints

- **Azure Policy**: Create, assign, and manage policies to enforce organizational requirements.

- **Blueprints**: Package artifacts like policies, role assignments, and templates to speed up environment setup.
