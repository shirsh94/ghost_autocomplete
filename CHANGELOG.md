## 1.2.2

* Fixed `TextEditingController` synchronization across all widgets:
    * Programmatic updates to external controllers are now correctly reflected in the UI.
    * Improved controller lifecycle management and support for swapping controllers at runtime.
    * Fixed `GhostAutocompleteTextFormField` to correctly sync with its own `FormField` state when using an external controller.
* Added `test/controller_sync_test.dart` to verify bidirectional synchronization.

## 1.2.1

* Enhanced `GhostSpellCheckTextField` with full styling support for misspelled words:
    * Added `misspelledTextStyle` for custom underlines (wavy, dotted, etc.).
    * Added `misspelledSelectionColor` for selection highlight customization.
    * Added `spellCheckSuggestionsToolbarBuilder` for custom context menus.
* Updated example app to demonstrate custom dotted red underline style.

## 1.2.0

* Added `GhostSpellCheckTextField` for combined inline ghost autocomplete and custom spell check.
* Added `GhostSpellCheckService` to provide custom, asynchronous spell check suggestions from user-defined lists or APIs.
* Added "Custom Spell" demo to the example app.
* Compatible with latest Flutter (3.29.x) spell check APIs.

## 1.1.0

* Added support for asynchronous suggestion providers (`FutureOr<String?>`).
* Implemented built-in race condition protection for async requests.
* Added "Asynchronous API Demo" to the example app.
* Improved documentation for async usage.

## 1.0.0

* Initial Release.
* Added `GhostAutocompleteTextField` for inline "ghost" predictive typing with pixel-perfect alignment.
* Added `GhostAutocompleteTextFormField` for seamless Flutter Form integration (validation, onSaved, etc.).
* Added `GhostAutocompleteListTextField` for dropdown-style multi-option suggestions (Google Maps style).
* Integrated Copilot-style "Tab" badges to quickly accept suggestions via mouse or keyboard.
* Support for 40+ standard `TextField` parameters including `textAlign`, `maxLines`, `obscureText`, and more.
* Support for `spellCheckConfiguration` and `autocorrect`.
* Synchronized scrolling for inline suggestions.
* Broad compatibility: Dart SDK >= 3.0.0 and Flutter >= 3.0.0.
