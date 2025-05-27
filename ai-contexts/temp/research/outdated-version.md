---
sidebar_position: 2
title: AI is using outdated version of library.
description: A prompt template to ensure AI provides version-specific information
---

# Version Check Prompt

Use this prompt before requesting code generation to ensure you get the latest version-appropriate code.


### 🤖 The Prompt
```
<Prompt to generated the code> Before generating any code, please:
1. Please using the confirmed <Stack> version that defined in <PackageFile>
2. Generate code based on the confirmed version
3. Include any version-specific features or syntax
```

### 📁 Context files:
```
package files of the project (package.json,pubspec.yaml)
```

## Next.js Example

```markdown
I need a sample component for a dashboard card. Before you generate the code:
1. Please using the confirmed Next.js version that defined in <PackageFile>
2. Generate code based on the confirmed version
3. Include any version-specific features or syntax

Note: If I inform you of a newer version, please adjust the code to use the latest conventions and features.