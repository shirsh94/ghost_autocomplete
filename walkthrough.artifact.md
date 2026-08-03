# Asynchronous Suggestion Support Added

I've updated the `ghost_autocomplete` package to support asynchronous suggestion providers. This allows the widgets to fetch inline suggestions from APIs or databases while maintaining a smooth user experience.

## Key Enhancements

### 1. Async-Ready Suggestion Provider
The `GhostSuggestionProvider` typedef now supports `FutureOr<String?>`. This means you can return a simple `String?` synchronously or a `Future<String?>` asynchronously.

### 2. Built-in Race Condition Protection
Implemented a request tracking system within `GhostAutocompleteTextField`. If a user types quickly and multiple API requests are triggered:
- Only the result from the **latest** request will be applied.
- Results from older, pending requests are automatically discarded when they complete.
- This ensures the "ghost" text always matches what the user is currently typing.

### 3. Asynchronous Example
Added an **"Asynchronous API Demo"** to the example app (Inline Ghost tab). It simulates a network request with a 500ms delay, demonstrating how the widget handles async data loading.

## Verification

### Automated Tests
Added [test/ghost_async_test.dart](file:///Users/shirsh.shukla/Documents/work/other/own/library/ghost_autocomplete/test/ghost_async_test.dart) which verifies:
- Suggestions are correctly displayed after an async delay.
- Outdated async responses are ignored (Race condition test).

### Manual Verification
- Tested the async demo in the example app.
- Confirmed that typing rapidly doesn't cause "flickering" or incorrect completions from previous keystrokes.

> [!TIP]
> Use `Future.delayed` or your actual API client in the `suggestionProvider` to see this in action. The widget handles the `await` and `setState` for you.
