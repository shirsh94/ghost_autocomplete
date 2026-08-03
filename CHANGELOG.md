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
