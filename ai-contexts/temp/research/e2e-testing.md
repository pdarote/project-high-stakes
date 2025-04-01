---
sidebar_position: 2
title: E2E Testing Guide
description: How to effectively request E2E test generation from AI
---

# E2E Testing Guide

## How to Ask AI for E2E Test Generation

### 🤖 The Prompt
```
Please creating E2E tests using Gherkin syntax.
```

### 📁 Context files:
```
A screen folder and pubspec.yaml file
```

### ✅ What AI Will Generate
```
- Test and test_driver folders with proper structure
- Feature files with correct Gherkin syntax
- Common step definitions for reusable E2E actions
```

### Important: Include Your pubspec.yaml!
Always include your `pubspec.yaml` when asking for E2E test generation. This ensures the AI generates tests that work with your project's specific setup.

#### What Happens Without pubspec.yaml
❌ You might face these issues:
- Outdated package versions in generated code
- Version conflicts with existing dependencies
- Time wasted fixing compatibility problems

#### What Happens With pubspec.yaml
✅ You'll get:
- Code that matches your project's dependencies
- Compatible package versions
- Tests that work right away with your setup