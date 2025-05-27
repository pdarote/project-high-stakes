---
sidebar_position: 5
title: GitHub Actions Deployment Guide
description: How to effectively request GitHub Actions workflow generation from AI
---

# GitHub Actions Guide

## How to Ask AI for Deployment Workflow Generation

### 🤖 The Prompt Template
```markdown
Please create a GitHub Actions workflow for deploying [Platform] with these requirements:

1. Deployment Target:
   - Platform: [iOS/Android/Web]
   - Environment: [Development/Staging/Production]
   - Infrastructure: [Cloud Provider/Service]

2. Build Requirements:
   - Framework: [Flutter/Next.js/etc]
   - Build Configuration: [Debug/Release]
   - Signing Requirements: [If applicable]

3. Security Requirements:
   - Secrets needed: [List required secrets]
   - Environment variables: [List required variables]
   - Access controls: [Required permissions]

Please ensure:
1. Proper secret handling
2. Environment configuration
3. Build optimization
4. Error handling
5. Deployment verification
```

### 📁 Required Context Files
```
- Project configuration files (pubspec.yaml, package.json)
- Existing deployment scripts
- Infrastructure configuration
- Environment configuration files
```

### ✅ What AI Will Generate
```
- Complete GitHub Actions workflow file
- Environment configuration
- Secret references
- Build steps
- Deployment steps
- Post-deployment verification
```

## Real Examples

### 1. Mobile Deployment Workflow

```markdown
"Create a GitHub Actions workflow for mobile deployment with:

1. iOS Requirements:
   - TestFlight distribution
   - App Store Connect API
   - Xcode configuration
   - Provisioning profiles

2. Android Requirements:
   - Play Store deployment
   - Keystore signing
   - Bundle creation
   - Internal testing track

3. Security:
   - Code signing secrets
   - API credentials
   - Store credentials

Expected workflow:
1. Build both platforms
2. Sign packages
3. Deploy to stores
4. Notify on completion"
```

Example Response (deploy-mobile.yaml):
```yaml
name: Mobile Deployment
on:
  workflow_dispatch:

jobs:
  ios:
    runs-on: macos-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      # ... (rest of iOS deployment steps)

  android:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      # ... (rest of Android deployment steps)
```

### 2. Web Deployment Workflow

```markdown
"Generate a GitHub Actions workflow for web deployment with:

1. Build Requirements:
   - Framework: Next.js
   - Environment: Development
   - Docker containerization
   - Nginx configuration

2. Cloud Requirements:
   - Azure Container Apps
   - Container Registry
   - Resource Group
   - Networking setup

3. Security:
   - Azure credentials
   - Registry access
   - Environment secrets

Expected workflow:
1. Build Docker image
2. Push to registry
3. Deploy to Azure
4. Verify deployment"
```

Example Response (deploy-web.yaml):
```yaml
name: Web Deployment
on:
  push:
    branches:
      - development

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      # ... (rest of web deployment steps)
```

## Best Practices

1. **Secret Management**
   - Use repository secrets for sensitive data
   - Never expose credentials in workflows
   - Rotate secrets regularly

2. **Environment Configuration**
   - Use environment files
   - Separate configurations per environment
   - Validate environment variables

3. **Build Optimization**
   - Cache dependencies
   - Optimize Docker layers
   - Use build matrices when applicable

4. **Error Handling**
   - Add timeout limits
   - Include retry logic
   - Implement failure notifications

5. **Security**
   - Limit permissions
   - Use OIDC when possible
   - Implement security scanning

## Pro Tips

1. Always specify required secrets in your prompt
2. Include environment-specific requirements
3. Mention any special build configurations
4. Specify required permissions
5. Include post-deployment verification needs 