---
sidebar_position: 4
title: Cross-Framework Theme Generation
description: Guide for prompting AI to generate consistent themes across Flutter and Next.js
---

# Theme Generation Guide

This document outlines how to prompt AI to generate consistent theme implementations across different frameworks using Figma design tokens.

## Understanding Design Tokens

Our design tokens are exported from Figma and stored in `/design-tokens/`:

```
design-tokens/
├─ 01 Foundation.Mode 1.tokens.json    # Base colors and styles
├─ text.styles.tokens.json             # Typography definitions
├─ effect.styles.tokens.json           # Shadows and effects
└─ 99 - Spacing & Corner.Mode 1.tokens.json  # Spacing and radius
```

## Theme Structure Prompt

```markdown
"Create a theme system using our Figma design tokens that:

1. Uses design tokens from /design-tokens/ as single source of truth:
   - Colors from 01 Foundation.Mode 1.tokens.json
   - Typography from text.styles.tokens.json
   - Effects from effect.styles.tokens.json
   - Spacing from 99 - Spacing & Corner.Mode 1.tokens.json

2. Implements framework-specific configurations:
   - Flutter: /lib/theme/
   - Next.js: /theme/

3. Maintains token structure:
   Colors example:
   ```json
   {
     "color": {
       "accents": {
         "interstellar-blue": {
           "500": { "$value": "#2a426e" }
         }
       }
     }
   }
   ```

   Typography example:
   ```json
   {
     "Heading": {
       "H1_SemiBold_36": {
         "$value": {
           "fontFamily": "Poppins",
           "fontSize": "36px",
           "fontWeight": 600,
           "lineHeight": "140%"
         }
       }
     }
   }
   ```"
```

## Framework-Specific Prompts

### 1. Flutter Theme Prompt

```markdown
"Generate Flutter theme configuration using our design tokens:

1. Parse and use tokens from:
   - Foundation tokens for colors
   - Text styles for typography
   - Effect styles for shadows
   - Spacing tokens for layout

2. Create theme files:
   /lib/theme/
   ├─ app_theme.dart        # Main configuration using tokens
   ├─ app_colors.dart       # Color definitions from Foundation tokens
   ├─ app_typography.dart   # Typography from text.styles tokens
   └─ extensions/           # Theme extensions

3. Implementation requirements:
   - Map Figma color tokens to Flutter Colors
   - Convert typography tokens to TextStyles
   - Create extension methods for easy access
   - Support light/dark themes from tokens"
```

### 2. Next.js Theme Prompt

```markdown
"Generate Next.js theme configuration using our design tokens:

1. Parse and use tokens from:
   - Foundation tokens for colors
   - Text styles for typography
   - Effect styles for shadows
   - Spacing tokens for layout

2. Create theme files:
   /theme/
   ├─ theme.ts          # Main theme using tokens
   ├─ colors.ts         # Colors from Foundation tokens
   ├─ typography.ts     # Typography from text.styles
   └─ components/       # Component-specific themes

3. Implementation requirements:
   - Convert Figma tokens to TypeScript types
   - Create styled-components theme
   - Implement CSS variables for tokens
   - Support light/dark themes from tokens"
```

## Implementation Examples

### 1. Flutter Theme Implementation

```markdown
"Generate Flutter theme using our Figma tokens:

```dart
// Example color extension using Foundation tokens
class AppColors extends ThemeExtension<AppColors> {
  final Color interstellarBlue500;  // From accents.interstellar-blue.500
  final Color amber400;             // From accents.amber.400

  // Map typography from text.styles.tokens.json
  static TextStyle get h1SemiBold => const TextStyle(
    fontFamily: 'Poppins',
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
}
```"
```

### 2. Next.js Theme Implementation

```markdown
"Generate Next.js theme using our Figma tokens:

```typescript
// Theme interface based on design tokens
interface AppTheme {
  colors: {
    interstellarBlue: {
      500: string;  // From accents.interstellar-blue.500
    };
    amber: {
      400: string;  // From accents.amber.400
    };
  };
  typography: {
    h1: {
      semiBold: TextStyle;  // From Heading.H1_SemiBold_36
    };
  };
}
```"
```

## Best Practices for Token Integration

1. **Token Parsing**
   - Create utilities to parse Figma token format
   - Maintain token hierarchy and structure
   - Handle unit conversions (px to rem/dp)

2. **Framework Adaptation**
   - Convert tokens to framework-specific formats
   - Maintain token naming consistency
   - Create type-safe interfaces

3. **Theme Generation**
   - Automate token to theme conversion
   - Generate constants and types
   - Maintain token updates

## Sample Complete Prompt

```markdown
"Create a complete theme system using our Figma design tokens:

1. Token Integration:
   - Parse all token files from /design-tokens/
   - Maintain token hierarchy
   - Handle all token types (colors, typography, effects)

2. Flutter Implementation:
   - Convert tokens to Dart/Flutter format
   - Create ThemeExtension classes
   - Generate theme provider

3. Next.js Implementation:
   - Convert tokens to TypeScript/CSS
   - Create styled-components theme
   - Generate theme context

4. Requirements:
   - Maintain token naming and structure
   - Create type-safe implementations
   - Support token updates
   - Include usage documentation

Follow the structure from flutter.md and nextjs.md guidelines."
``` 