# Custom Spell Check and Ghost Autocomplete Widget

Implement a new widget that combines the existing inline "ghost" autocomplete with a custom spell check service that provides suggestions from a user-defined list or API.

## User Review Required

> [!IMPORTANT]
> The custom spell check service will be responsible for identifying "misspelled" words. By default, it will consider any word not present in the provided suggestion list as potentially misspelled if it's "close enough" or based on a custom validator.

## Proposed Changes

### [Component Name]

#### [NEW] [ghost_spell_check_service.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/lib/src/ghost_spell_check_service.dart)
- Implement `GhostSpellCheckService` extending `SpellCheckService`.
- Add support for async suggestion fetching.
- Add logic to identify misspelled words and map them to custom suggestions.

#### [NEW] [ghost_spell_check_text_field.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/lib/src/ghost_spell_check_text_field.dart)
- Create `GhostSpellCheckTextField` which simplifies the integration of both ghost suggestions and custom spell check.
- It will wrap `GhostAutocompleteTextField`.

#### [MODIFY] [ghost_autocomplete.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/lib/ghost_autocomplete.dart)
- Export the new service and widget.

## Verification Plan

### Automated Tests
- Unit test for `GhostSpellCheckService` to ensure it correctly identifies misspellings and returns expected suggestions from a mock list/API.
- Widget test for `GhostSpellCheckTextField` to ensure it renders both features.

### Manual Verification
- Create an example in the `example/` directory demonstrating the custom list and async API call for spell check.
