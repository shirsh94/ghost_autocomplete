import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_autocomplete/ghost_autocomplete.dart';

void main() {
  group('GhostAutocompleteTextField Async', () {
    testWidgets('shows ghost text from async provider after delay', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteTextField(
              suggestionProvider: (text) async {
                await Future.delayed(const Duration(milliseconds: 100));
                return text == 'alri' ? 'alright' : null;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'alri');
      
      // Advance 100ms
      await tester.pump(const Duration(milliseconds: 100));
      // One more pump to let the Future resolve and setState trigger
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      final controller = textField.controller as GhostAutocompleteController;
      expect(controller.suggestion, 'ght');

      // Clear any pending timers
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('ignores old async requests (race condition prevention)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteTextField(
              suggestionProvider: (text) async {
                if (text == 'a') {
                  await Future.delayed(const Duration(milliseconds: 200));
                  return 'apple';
                } else if (text == 'al') {
                  await Future.delayed(const Duration(milliseconds: 50));
                  return 'alright';
                }
                return null;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      
      // Type 'a'
      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump(); // Start first request (200ms)

      // Type 'l'
      await tester.enterText(find.byType(TextField), 'al');
      await tester.pump(); // Start second request (50ms)

      // Wait 100ms. Second request ('al', 50ms) finishes.
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      final controller = textField.controller as GhostAutocompleteController;
      expect(controller.suggestion, 'right');

      // Wait 200ms. First request ('a', 200ms) would have finished, but should be ignored.
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump();
      
      expect(controller.suggestion, 'right');

      // Clear any pending timers to avoid test failure
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
