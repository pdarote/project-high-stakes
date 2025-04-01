# Flutter

Flutter Coding Standard

## 1. Project Structure

1. **Single Source of Truth**

   - All source code resides in the `/lib` folder to maintain a clear organization and provide full context for developers and AI assistants.

2. **Folder Layout**

   - **Common Components**: Shared or reusable UI components go to `/lib/common/components`.
   - **Pages/Screens**: Each page or screen lives in its own folder within `/lib/screen/<page_name>`.
   - **Theme**: Theme configurations and extensions in `/lib/theme/`.
   - **Optional Layers**: If necessary, create additional folders like `/lib/models`, `/lib/services`, `/lib/utils` for data classes, service logic, and utility functions.

3. **Example Layout**
   ```
   digital_name_card/
   └─ lib/
      ├─ common/
      │   └─ components/
      ├─ screens/
      │   ├─ home/
      │   │   ├─ home_screen.dart
      │   │   └─ home_controller.dart
      │   └─ settings/
      │       ├─ settings_screen.dart
      │       └─ settings_controller.dart
      ├─ theme/
      │   ├─ app_theme.dart
      │   ├─ app_colors.dart
      │   └─ extensions/
      ├─ models/
      ├─ services/
      ├─ utils/
      └─ main.dart
   ```

## 2. Naming Conventions

1. **Files and Folders**

   - Use **snake_case** for all files and folders (e.g., `home_screen.dart`, `user_model.dart`, `page_controller.dart`).

2. **Classes and Widgets**

   - Use **PascalCase** for class names (e.g., `HomeScreen`, `UserModel`).
   - A file named `home_screen.dart` should contain a class called `HomeScreen` for consistency.

3. **Methods and Variables**

   - Use **camelCase** for method names, variables, and function parameters (e.g., `fetchUserData()`, `userName`).

4. **Constants**
   - Use ALL_UPPERCASE with underscores for constants (e.g., `MAX_LOGIN_ATTEMPTS`).
   - Keep global constants in a dedicated file or group logically within specific classes.

## 3. Coding Style

1. **Line Length & Formatting**

   - Prefer an 80- or 100-character line width (team preference).
   - Use the Dart formatter (`dart format`) or your IDE's auto-formatting tool for consistent code style.

2. **Braces & Spacing**

   - Opening braces `{` typically follow the statement on the same line (following Dart's default convention).
   - Use single spaces around operators and after commas (e.g., `myList.map((item) => ...)`).

3. **Documentation Comments**

   - Use Dart's triple-slash (`///`) style for public APIs, classes, and methods.
   - Provide concise descriptions that outline purpose, parameters, and return values.

4. **Null Safety**
   - Embrace Dart's null-safe features—avoid using `dynamic` where possible.
   - Use `late` or the `!` operator sparingly and only when certain a value can never be null.

## 4. Widgets & Layout

1. **Stateless vs. Stateful**

   - Default to `StatelessWidget` whenever possible for performance and simplicity.
   - Use `StatefulWidget` if local state is needed.

2. **Widget Build Method**

   - Keep `build` methods short and readable by splitting large UI sections into smaller widgets or helper methods.
   - Minimize deeply nested widget trees by extracting sub-widgets.

3. **Responsive Design**

   - Use `LayoutBuilder`, `MediaQuery`, or other tools to build adaptive UIs.
   - Employ `Expanded`, `Flexible`, and related widgets to handle various screen sizes gracefully.

4. **Theming & Styling**
   - Use shared design tokens from `/design-tokens` directory as single source of truth
   - Implement theme using the following structure:
     ```
     /lib/theme/
     ├─ app_theme.dart      # Main theme configuration
     ├─ app_colors.dart     # Color definitions from design tokens
     └─ extensions/         # Custom theme extensions
     ```
   - Access theme using `Theme.of(context)` or theme extensions
   - Never use hardcoded colors - always reference theme colors
   - Example usage:
     ```dart
     Theme.of(context).extension<AppColors>()!.primary.main
     ```
   - Support both light and dark themes using design token values
   - Implement proper theme switching mechanism if required

## Responsive Design

All UI elements should scale based on the device screen width:

- Screen width ≤ 320px: Scale all UI sizes by 0.8 (20% smaller)
- Screen width 321-427px: Use default sizes (scale 1.0)
- Screen width ≥ 428px: Scale all UI sizes by 1.2 (20% larger)

Example using UIScaling utility:

```dart
// In utils/ui_scaling.dart
class UIScaling {
  static double getMultiplier(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 320) return 0.8;  // Small screens
    if (width >= 428) return 1.2;  // Large screens
    return 1.0;  // Medium screens
  }
}

// Usage in widgets
final multiplier = UIScaling.getMultiplier(context);
final fontSize = 16.0 * multiplier;
final padding = EdgeInsets.all(8.0 * multiplier);
```

This ensures consistent appearance across different device sizes while maintaining usability.

---

## 5. State Management

1. **Preferred Approach**

   - Use a team-approved pattern or package (e.g., Provider, Bloc, Riverpod, MobX) to ensure consistent state management.
   - Keep business logic separate from UI components whenever possible.

2. **Best Practices**
   - Store logic in dedicated classes (e.g., `ChangeNotifier`, `Bloc`, `StateNotifier`).
   - Name these classes based on their purpose (e.g., `AuthBloc`, `UserProvider`) and keep them well-organized.

---

## 6. Testing Practices

1. **Test File Structure**

   - Place tests in the `/test` directory, mirroring the lib directory structure
   - Use `_test.dart` suffix for unit/widget tests
   - Use `_golden_test.dart` suffix for golden tests

   ```
   digital_name_card/
   └─ flutter/
      ├─ lib/
      │  └─ common/
      │      └─ components/
      │          └─ custom_button.dart
      └─ test/
          └─ common/
              └─ components/
                  ├─ custom_button_test.dart
                  └─ custom_button_golden_test.dart
   ```

2. **Component Testing Requirements**
   Every new component must include:

   - Unit/Widget tests
   - Golden tests
   - Minimum test coverage requirement: 80%

3. **Unit/Widget Testing**

   ```dart
   void main() {
     testWidgets('CustomButton - renders correctly', (tester) async {
       await tester.pumpWidget(
         MaterialApp(
           home: CustomButton(
             onPressed: () {},
             label: 'Click me',
           ),
         ),
       );

       expect(find.text('Click me'), findsOneWidget);
       expect(find.byType(CustomButton), findsOneWidget);
     });

     testWidgets('CustomButton - handles tap', (tester) async {
       bool wasPressed = false;
       await tester.pumpWidget(
         MaterialApp(
           home: CustomButton(
             onPressed: () => wasPressed = true,
             label: 'Click me',
           ),
         ),
       );

       await tester.tap(find.byType(CustomButton));
       await tester.pump();
       expect(wasPressed, true);
     });
   }
   ```

4. **Golden Testing**

   ```dart
   void main() {
     group('CustomButton Golden Tests', () {
       testGoldens('renders correctly - light theme', (tester) async {
         await tester.pumpWidgetBuilder(
           CustomButton(
             onPressed: () {},
             label: 'Click me',
           ),
           wrapper: materialAppWrapper(
             theme: lightTheme,
             platform: TargetPlatform.iOS,
           ),
         );

         await screenMatchesGolden(tester, 'custom_button_light');
       });

       testGoldens('renders correctly - dark theme', (tester) async {
         await tester.pumpWidgetBuilder(
           CustomButton(
             onPressed: () {},
             label: 'Click me',
           ),
           wrapper: materialAppWrapper(
             theme: darkTheme,
             platform: TargetPlatform.iOS,
           ),
         );

         await screenMatchesGolden(tester, 'custom_button_dark');
       });
     });
   }
   ```

5. **Test Commands**

   ```bash
   # Run all tests
   flutter test

   # Run tests with coverage
   flutter test --coverage

   # Update golden files
   flutter test --update-goldens

   # Run specific test file
   flutter test test/path/to/test_file.dart
   ```

6. **Testing Best Practices**

   - Test component behavior, not implementation details
   - Test edge cases and error states
   - Create reusable test utilities and fixtures
   - Use semantic finders (byType, byKey) over text-based finders when possible
   - Test accessibility when applicable
   - Mock external dependencies and services

   ```dart
   // test/fixtures/user_fixture.dart
   final mockUser = User(
     id: '1',
     name: 'John Doe',
     email: 'john@example.com',
   );

   // test/widgets/user_profile_test.dart
   testWidgets('UserProfile displays user info', (tester) async {
     await tester.pumpWidget(
       MaterialApp(
         home: UserProfile(user: mockUser),
       ),
     );
     expect(find.text(mockUser.name), findsOneWidget);
   });
   ```

## 7. Theme Context

- Use shared design tokens from `/design-tokens` directory as single source of truth
- Implement theme using the following structure:

- Use `/flutter/lib/theme` structure for theme-related files.
- Implement theme using the following structure:
  ```
  /lib/theme/
  ├─ app_theme.dart      # Main theme configuration
  ├─ app_colors.dart     # Color definitions from design tokens
  └─ extensions/         # Custom theme extensions
  ```
- Access theme using `Theme.of(context)` or theme extensions.
- Never use hardcoded colors - always reference theme colors.
- Example usage:
  ```dart
  Theme.of(context).extension<AppColors>()!.primary.main
  ```
- Support both light and dark themes using design token values.
- Implement a proper theme switching mechanism if required.
- Example theme configuration:

  ```dart
  import 'package:flutter/material.dart';

  class AppColors extends ThemeExtension<AppColors> {
    final Color primary;
    final Color secondary;
    final Color background;
    final Color text;

    AppColors({
      required this.primary,
      required this.secondary,
      required this.background,
      required this.text,
    });

    @override
    AppColors copyWith({
      Color? primary,
      Color? secondary,
      Color? background,
      Color? text,
    }) {
      return AppColors(
        primary: primary ?? this.primary,
        secondary: secondary ?? this.secondary,
        background: background ?? this.background,
        text: text ?? this.text,
      );
    }

    @override
    AppColors lerp(ThemeExtension<AppColors>? other, double t) {
      if (other is! AppColors) return this;
      return AppColors(
        primary: Color.lerp(primary, other.primary, t)!,
        secondary: Color.lerp(secondary, other.secondary, t)!,
        background: Color.lerp(background, other.background, t)!,
        text: Color.lerp(text, other.text, t)!,
      );
    }
  }

  final lightTheme = ThemeData(
    extensions: <ThemeExtension<AppColors>>[
      AppColors(
        primary: Color(0xFF6200EE),
        secondary: Color(0xFF03DAC6),
        background: Color(0xFFFFFFFF),
        text: Color(0xFF000000),
      ),
    ],
  );

  final darkTheme = ThemeData(
    extensions: <ThemeExtension<AppColors>>[
      AppColors(
        primary: Color(0xFFBB86FC),
        secondary: Color(0xFF03DAC6),
        background: Color(0xFF121212),
        text: Color(0xFFFFFFFF),
      ),
    ],
  );
  ```

- Wrap application with `ThemeProvider`.
- Implement theme switching functionality using context.

  ```dart
  import 'package:flutter/material.dart';

  class ThemeProvider extends ChangeNotifier {
    ThemeData _themeData;

    ThemeProvider(this._themeData);

    getTheme() => _themeData;

    setTheme(ThemeData themeData) {
      _themeData = themeData;
      notifyListeners();
    }
  }

  void main() {
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(lightTheme),
        child: MyApp(),
      ),
    );
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.getTheme(),
            home: HomeScreen(),
          );
        },
      );
    }
  }
  ```
