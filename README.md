# Ghost Autocomplete

A comprehensive Flutter package providing modern "ghost" (predictive inline) autocomplete and dropdown-style suggestion widgets. Designed to mirror the professional experience of IDEs like VS Code and high-end search bars.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


## Screenshots
| ![Screenshot 1](https://raw.githubusercontent.com/shirsh94/ghost_autocomplete/main/demo/Screenshot_first.jpg?raw=true) | ![Screenshot 2](https://raw.githubusercontent.com/shirsh94/ghost_autocomplete/main/demo/Screenshot_second.jpg?raw=true) | ![Screenshot 3](https://raw.githubusercontent.com/shirsh94/ghost_autocomplete/main/demo/Screenshot_third.jpg?raw=true) |
|----------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|

## 🚀 Features

- **Inline Ghosting**: Displays a greyed-out suggestion tail directly within the text engine for pixel-perfect alignment.
- **Controller-Based Architecture**: Uses a custom `GhostAutocompleteController` to ensure the suggestion text inherits the exact baseline, metrics, and scrolling behavior of your input.
- **Form Integration**: Includes a `TextFormField` variant for easy validation and form handling.
- **Dropdown Lists**: A specialized widget for multi-option searches (like location or user selection) using a floating `Overlay`.
- **Interactive Badges**: Optional "Tab" badges (Copilot-style) that users can click or press Tab to accept.
- **Full TextField Parity**: Supports over 40+ standard `TextField` parameters, including `textAlign`, `maxLines`, `obscureText`, `inputFormatters`, and more.
- **Modern System Features**: Integrated support for `spellCheckConfiguration` and `autocorrect`.
- **Synchronized Scrolling**: Suggestion text moves perfectly with the cursor as the field scrolls.
- **Native Feature Support**: Full support for `spellCheckConfiguration`, `autocorrect`, `inputFormatters`, and more.

---

## 📦 Installation

Add `ghost_autocomplete` to your `pubspec.yaml`:

```yaml
dependencies:
  ghost_autocomplete: ^1.0.0
```

---

## 🛠 Widgets & Usage

### 1. GhostAutocompleteTextField
Perfect for predictive typing where you want to show a single "tail" completion as the user types.

```dart
GhostAutocompleteTextField(
  suggestionProvider: (text) {
    if (text.toLowerCase() == 'alri') return 'alright';
    return null;
  },
  onSuggestionAccepted: (value) => print('Accepted: $value'),
  decoration: InputDecoration(
    hintText: 'Type "alri"...',
    border: OutlineInputBorder(),
  ),
)
```

### 2. GhostAutocompleteTextFormField
A true `FormField` implementation. Seamlessly integrates with Flutter's `Form` widget, supporting validation and state management.

```dart
GhostAutocompleteTextFormField(
  suggestionProvider: (text) => mySuggestions.firstWhere((s) => s.startsWith(text)),
  validator: (val) => val!.isEmpty ? 'Required field' : null,
  onSaved: (val) => _userData = val,
  decoration: InputDecoration(
    labelText: 'Enter Username',
    prefixIcon: Icon(Icons.person),
  ),
)
```

### 3. GhostAutocompleteListTextField
Ideal for search bars where multiple matches should be shown in a scrollable floating menu.

```dart
GhostAutocompleteListTextField(
  suggestionProvider: (text) async {
    // Supports async API calls
    return await fetchMatchesFromServer(text);
  },
  onSuggestionSelected: (val) => print('Selected: $val'),
  decoration: InputDecoration(
    labelText: 'Search Places',
    prefixIcon: Icon(Icons.map),
  ),
)
```

---

## 🔍 Native Feature Support

This package is built to be a drop-in replacement for standard Flutter text widgets. It supports all the native features you expect:

- **`spellCheckConfiguration`**: Native red underlines and suggestions for typos.
- **`autocorrect`**: System-level text correction.
- **`inputFormatters`**: Enforce numeric-only, custom regex, or length constraints.
- **`maxLines` & `minLines`**: Support for both single-line and multiline ghosting.
- **`textAlign`**: Works perfectly with Start, Center, or End alignment.

```dart
GhostAutocompleteTextField(
  suggestionProvider: _myProvider,
  autocorrect: true,
  spellCheckConfiguration: const SpellCheckConfiguration(),
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
)
```

---

## ⌨️ Shortcuts & Interaction

| Interaction | Action | Requirement |
| :--- | :--- | :--- |
| **Tab Key** | Accepts the inline suggestion | Cursor must be at the end of text |
| **Right Arrow** | Accepts the inline suggestion | Cursor must be at the end of text |
| **Mouse Click** | Click the blue "Tab" badge | Inline suggestion must be visible |
| **List Tap** | Selects item from dropdown | Dropdown list must be visible |

---

## 🎨 Customization

### Suggestion Styling
You can independently style the "ghost" text to match your theme.

```dart
GhostAutocompleteTextField(
  style: TextStyle(color: Colors.black, fontSize: 18),
  suggestionStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
  showTabBadge: true,
  tabBadge: Container(
    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    color: Colors.blue,
    child: Text('TAB', style: TextStyle(color: Colors.white, fontSize: 8)),
  ),
)
```

### Architectural Highlights: Pixel-Perfect Alignment
Unlike other packages that use a separate `Stack` layer which often drifts by 1-2 pixels, `ghost_autocomplete` builds the suggestion directly into the `TextSpan` of the `TextField`. This ensures that even with custom `strutStyle`, `textAlign: TextAlign.center`, or complex multi-line configurations, the suggestion is **guaranteed** to be perfectly aligned with the baseline.

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
