---
sidebar_position: 4
title: Unit Testing Guide
description: How to effectively request unit test generation from AI
---

# Unit Testing Guide

## How to Ask AI for Unit Test Generation

### 🤖 The Prompt
```
Please create unit tests for <YourFile>
```

### 📁 Context files:
```
- The file you want to test
- Dependencies and services used by the file
- pubspec.yaml
- Any mock data or test constants needed
```

### ✅ What AI Will Generate
```
- Test file with proper unit test structure
- Mock classes for dependencies
- Test cases for different scenarios
- Edge case coverage
- Error handling tests
```

### Important: Include Your Dependencies!
Always include files that your target code depends on. This ensures the AI generates tests that properly mock and handle all dependencies.

#### What Happens Without Dependencies
❌ You might face these issues:
- Incomplete mock implementations
- Missing test scenarios
- Compilation errors due to unknown dependencies
- Incorrect assumptions about dependency behavior

#### What Happens With Dependencies
✅ You'll get:
- Properly mocked dependencies
- Comprehensive test coverage
- Tests that match your actual implementation
- Accurate error handling scenarios

### Pro Tips
1. Specify any complex business logic that needs testing
2. Mention if you need specific test coverage metrics
3. Include example inputs and expected outputs
4. Note any async operations that need testing
5. Highlight error conditions to be tested 