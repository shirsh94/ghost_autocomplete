import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_autocomplete/ghost_autocomplete.dart';

void main() {
  group('GhostAutocompleteTextField', () {
    testWidgets('shows ghost text and Tab badge when suggestion is available', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteTextField(
              suggestionProvider: (text) => text == 'alri' ? 'alright' : null,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'alri');
      await tester.pump();

      // Verify suggestion is in the controller
      final textField = tester.widget<TextField>(find.byType(TextField));
      final controller = textField.controller as GhostAutocompleteController;
      expect(controller.suggestion, 'ght');
      
      // Check for Tab badge
      expect(find.text('Tab'), findsOneWidget);
    });

    testWidgets('accepts suggestion on Tab key', (tester) async {
      String? acceptedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteTextField(
              suggestionProvider: (text) => text == 'alri' ? 'alright' : null,
              onSuggestionAccepted: (val) => acceptedValue = val,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'alri');
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'alright');
      expect(acceptedValue, 'alright');
    });

    testWidgets('accepts suggestion on Tab badge click', (tester) async {
      String? acceptedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteTextField(
              suggestionProvider: (text) => text == 'alri' ? 'alright' : null,
              onSuggestionAccepted: (val) => acceptedValue = val,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'alri');
      await tester.pump();

      // Click the "Tab" badge
      await tester.tap(find.text('Tab'));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'alright');
      expect(acceptedValue, 'alright');
    });
  });
}
