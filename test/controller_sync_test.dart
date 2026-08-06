import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_autocomplete/ghost_autocomplete.dart';

void main() {
  group('Controller Synchronization Tests', () {
    testWidgets('GhostAutocompleteTextField syncs with external controller', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteTextField(
              controller: controller,
              suggestionProvider: (text) => null,
            ),
          ),
        ),
      );

      // Programmatic update
      controller.text = 'Hello';
      await tester.pump();
      expect(find.text('Hello'), findsOneWidget);

      // User input update
      await tester.enterText(find.byType(TextField), 'World');
      await tester.pump();
      expect(controller.text, 'World');
    });

    testWidgets('GhostAutocompleteTextFormField syncs with external controller', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteTextFormField(
              controller: controller,
              suggestionProvider: (text) => null,
            ),
          ),
        ),
      );

      // Programmatic update
      controller.text = 'FormField';
      await tester.pump();
      expect(find.text('FormField'), findsOneWidget);

      // User input update
      await tester.enterText(find.byType(TextField), 'Changed');
      await tester.pump();
      expect(controller.text, 'Changed');
    });

    testWidgets('GhostSpellCheckTextField syncs with external controller', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostSpellCheckTextField(
              controller: controller,
              suggestionProvider: (text) => null,
            ),
          ),
        ),
      );

      // Programmatic update
      controller.text = 'SpellCheck';
      await tester.pump();
      expect(find.text('SpellCheck'), findsOneWidget);

      // User input update
      await tester.enterText(find.byType(TextField), 'Typed');
      await tester.pump();
      expect(controller.text, 'Typed');
    });

    testWidgets('GhostAutocompleteListTextField syncs with external controller', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteListTextField(
              controller: controller,
              suggestionProvider: (text) => [],
            ),
          ),
        ),
      );

      // Programmatic update
      controller.text = 'ListField';
      await tester.pump();
      expect(find.text('ListField'), findsOneWidget);

      // User input update
      await tester.enterText(find.byType(TextField), 'Selection');
      await tester.pump();
      expect(controller.text, 'Selection');
    });
  });
}
