# [Implementation Plan] Improve Example UI with Tabs and Light Theme

Reorganize the example application into a tabbed interface for better usability and switch from a dark theme to a standard light theme.

## Proposed Changes

### Example Application

#### [MODIFY] [main.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/example/lib/main.dart)
- **Theme Update**: Change `ThemeData` to use `Brightness.light` and set a consistent color scheme.
- **Scaffold Update**: Remove hardcoded background colors and use standard Material colors.
- **Tab Controller**: Wrap the main screen in a `DefaultTabController`.
- **Navigation**:
    - Add a `TabBar` to the `AppBar` bottom with three tabs: "Inline", "Form", and "List".
    - Replace the `SingleChildScrollView` body with a `TabBarView`.
- **Content Organization**:
    - **Tab 1 (Inline)**: Show standard `GhostAutocompleteTextField` with its "Copilot" styling and advanced parameters.
    - **Tab 2 (Form)**: Show `GhostAutocompleteTextFormField` within a `Form` with validation logic.
    - **Tab 3 (List)**: Show `GhostAutocompleteListTextField` for dropdown-style suggestions.

## Verification Plan

### Manual Verification
- Run the example app on Web/macOS.
- Switch between tabs to ensure all widgets render and function correctly.
- Verify that the light theme looks clean and professional.
- Confirm that suggestions still work in all three modes.
