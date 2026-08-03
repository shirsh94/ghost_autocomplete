import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_autocomplete/ghost_autocomplete.dart';

void main() {
  group('GhostAutocompleteTextFormField', () {
    testWidgets('works within a Form and validates', (tester) async {
      final formKey = GlobalKey<FormState>();
      String? savedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: GhostAutocompleteTextFormField(
                suggestionProvider: (text) => 'suggestion',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => savedValue = value,
              ),
            ),
          ),
        ),
      );

      // Validate empty field
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Required'), findsOneWidget);

      // Enter text and validate
      await tester.enterText(find.byType(TextField), 'hello');
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Required'), findsNothing);

      // Save form
      formKey.currentState!.save();
      expect(savedValue, 'hello');
    });

    testWidgets('initialValue works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GhostAutocompleteTextFormField(
              suggestionProvider: (text) => null,
              initialValue: 'Initial',
            ),
          ),
        ),
      );

      expect(find.text('Initial'), findsOneWidget);
    });
  });
}
