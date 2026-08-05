# Custom Spell Check and Ghost Autocomplete Implementation

I have implemented the `GhostSpellCheckTextField` widget and the `GhostSpellCheckService` to support inline ghost autocomplete along with custom, asynchronous spell check suggestions.

## Key Changes

### [GhostSpellCheckService](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/lib/src/ghost_spell_check_service.dart)
A custom `SpellCheckService` that:
- Compatible with Flutter 3.29.3 (uses `fetchSpellCheckSuggestions` and `SuggestionSpan`).
- Supports a static list of suggestions.
- Supports an asynchronous `suggestionsProvider` for API-backed suggestions.
- Allows a custom `isMisspelled` validator.

### [GhostSpellCheckTextField](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/lib/src/ghost_spell_check_text_field.dart)
A convenience widget that:
- Combines `GhostAutocompleteTextField` with `GhostSpellCheckService`.
- Exposes parameters for both ghost suggestions and spell check suggestions.
- Allows customizing the misspelled text style.

### [Example App](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/example/lib/main.dart)
Added a new tab "Custom Spell" to the example app demonstrating:
- Local list spell check suggestions.
- Asynchronous API-backed spell check suggestions.

## Verification Results

### Manual Verification
1.  **Ghost Autocomplete**: Still works as expected, providing inline tail suggestions.
2.  **Custom Spell Check**:
    - Words not in the provided list are underlined (wavy red by default).
    - Tapping on a misspelled word shows the custom suggestions provided by the `GhostSpellCheckService`.
    - Asynchronous suggestions are fetched and displayed after the simulated delay.

```dart
// Example Usage
GhostSpellCheckTextField(
  suggestionProvider: (text) => 'ghost suggestion',
  spellCheckSuggestions: const ['how', 'ok', 'what'],
  decoration: const InputDecoration(
    labelText: 'Custom Spell Check',
  ),
)
```
