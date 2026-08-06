# Implementation Plan - Refactor Tabs into Stateful Classes

Refactor the `TabBarView` content in `lib/main.dart` into four separate stateful classes for better modularity and maintainability.

## Proposed Changes

### [New] [Utils Directory](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/example/lib/utils/)

#### [NEW] [suggestions.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/example/lib/utils/suggestions.dart)
- Move the `suggestions` list and `getSuggestion` logic here for reuse across tabs.

#### [NEW] [tab_layout.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/example/lib/utils/tab_layout.dart)
- Move the `_buildTabContent` helper method here as a reusable widget or function.


Create a new directory to house the tab widgets.

#### [NEW] [inline_ghost_tab.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/example/lib/tabs/inline_ghost_tab.dart)
- Define `InlineGhostTab` as a `StatefulWidget`.
- Move the logic and UI for the "Inline Ghost" tab here.

#### [NEW] [custom_spell_tab.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/example/lib/tabs/custom_spell_tab.dart)
- Define `CustomSpellTab` as a `StatefulWidget`.
- Move the logic and UI for the "Custom Spell" tab here.

#### [NEW] [form_field_tab.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/example/lib/tabs/form_field_tab.dart)
- Define `FormFieldTab` as a `StatefulWidget`.
- Move the logic and UI for the "Form Field" tab here.

#### [NEW] [dropdown_list_tab.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/example/lib/tabs/dropdown_list_tab.dart)
- Define `DropdownListTab` as a `StatefulWidget`.
- Move the logic and UI for the "Dropdown List" tab here.

### [Example App]

#### [MODIFY] [main.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/example/lib/main.dart)
- Import the new tab widgets.
- Replace the inline `_buildTabContent` calls in `TabBarView` with the new tab widgets.
- Remove the duplicated logic and `_buildTabContent` method.


## Verification Plan

### Manual Verification
- Run the app and ensure all four tabs work exactly as they did before the refactoring.
- Check that the state is correctly preserved within each tab (if applicable).
