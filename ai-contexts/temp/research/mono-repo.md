---
sidebar_position: 3
title: Working with AI in Mono-repo
description: Guide for effective AI interaction in a multi-framework mono-repo
---

## Creating .cursorrule File

Here's how to prompt AI to create a `.cursorrule,copilot-instruction` file for your mono-repo:

### Sample Prompt Template

```markdown
"I need to set up AI rules for a mono-repo project with these requirements:

1. Project Structure:
   - Framework 1: [specify directory and file types]
   - Framework 2: [specify directory and file types]

2. Guidelines Location:
   - Framework 1 guidelines: [path to guidelines]
   - Framework 2 guidelines: [path to guidelines]

3. File Organization:
   - Framework 1 components go to: [path]
   - Framework 2 components go to: [path]

Please create a .cursorrule file that:
1. Detects frameworks based on file extensions and directories
2. Applies appropriate guidelines
3. Ensures correct file placement
4. Maintains project structure"
```

### Real Example Prompt

```markdown
"Create a .cursorrule file for a mono-repo with:

1. Three frameworks:
   - Flutter (*.dart files in /flutter)
   - Next.js (*.tsx files in /nextjs)
   - Go (*.go files in /go)

2. Guidelines in ai-contexts/guidelines/:
   - flutter.md for Flutter
   - nextjs.md for Next.js
   - go.md for Go

3. Directory rules:
   - Flutter components: flutter/lib/common/components/
   - Next.js components: nextjs/app/components/
   - Go services: go/internal/services/

The AI should:
1. Auto-detect framework context
2. Follow framework-specific guidelines
3. Place files in correct directories
4. Maintain project structure
5. Ensure best practices per framework"
```

### Expected AI Response

The AI should generate a `.cursorrule` file like:

```yaml
version: 1
rules:
  - name: "Professional Full-Stack Development"
    description: "Guidelines for Flutter, Next.js, and Go development"
    files:
      - "**/*.{dart,tsx,go}"
      - "pubspec.yaml"
      - "package.json"
      - "go.mod"
    prompt: |
      You are a professional full-stack developer specializing in:
      - Flutter/Dart development
      - React/Next.js development
      - Go development
      
      Project Guidelines:
      1. Framework-Specific Guidelines:
         - Flutter: Follow ai-contexts/guidelines/flutter.md
         - Next.js: Follow ai-contexts/guidelines/nextjs.md
         - Go: Follow ai-contexts/guidelines/go.md

      2. File Structure:
         - Flutter files → flutter/ directory
         - Next.js files → nextjs/ directory
         - Go files → go/ directory

      3. Best Practices:
         - Write maintainable, testable code
         - Provide proper documentation
         - Follow framework-specific patterns
         - Ensure type safety
         - Use appropriate testing frameworks
```

### Key Components to Specify

1. **Framework Information**
   - Names and technologies
   - File extensions
   - Directory locations

2. **Guidelines**
   - Location of guideline files
   - Framework-specific rules
   - Best practices

3. **Directory Structure**
   - Component locations
   - File organization
   - Project layout

4. **Behavior Rules**
   - Auto-detection logic
   - File placement rules
   - Cross-framework interaction 