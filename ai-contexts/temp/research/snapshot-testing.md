---
sidebar_position: 3
title: Snapshot Testing Guide
description: How to effectively request snapshot (golden) test generation from AI
---

# Snapshot Testing Guide

## How to Ask AI for Snapshot Test Generation

### 🤖 The Prompt
```
Please create snapshot testing (golden testing) for <YourComponentFolder>
```

### 📁 Context files:
```
- The component folder you want to test
- pubspec.yaml
- Any theme or styling files used by the component
```

### ✅ What AI Will Generate
```
- Test folder with proper golden test structure
- Golden test files for different device sizes
- Helper functions for snapshot comparison
- Documentation for updating golden files
```

### Important: Include Your Theme Files!
Always include your theme configuration when asking for snapshot test generation. This ensures the AI generates tests that accurately capture your component's styled appearance.

#### What Happens Without Theme Files
❌ You might face these issues:
- Inconsistent styling in snapshots
- False positives in visual regression tests
- Missing style-specific test cases
- Default Flutter styling instead of your custom theme

#### What Happens With Theme Files
✅ You'll get:
- Accurate visual regression tests
- Proper styling in snapshots
- Tests that catch style-related regressions
- Golden files that match your app's look and feel

### Pro Tips
1. Specify device sizes you want to test
2. Mention if you need dark/light theme variations
3. Include any custom fonts or assets used
4. Consider platform-specific variations (iOS/Android) 