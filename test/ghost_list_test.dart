import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_autocomplete/ghost_autocomplete.dart';

void main() {
  group('GhostAutocompleteListTextField', () {
    testWidgets('shows dropdown when text is entered', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteListTextField(
              suggestionProvider: (text) => ['suggestion 1', 'suggestion 2'],
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'sug');
      await tester.pumpAndSettle();

      expect(find.text('suggestion 1'), findsOneWidget);
      expect(find.text('suggestion 2'), findsOneWidget);
    });

    testWidgets('selects suggestion and updates text field', (tester) async {
      String? selectedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteListTextField(
              suggestionProvider: (text) => ['alright'],
              onSuggestionSelected: (val) => selectedValue = val,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'al');
      await tester.pumpAndSettle();

      // Tap the suggestion in the list
      await tester.tap(find.text('alright').last);
      await tester.pump(); // Update controller
      await tester.pump(); // Remove overlay

      // Verify text field is updated
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'alright');
      expect(selectedValue, 'alright');
      expect(find.byType(ListView), findsNothing);
    });
  });
}
