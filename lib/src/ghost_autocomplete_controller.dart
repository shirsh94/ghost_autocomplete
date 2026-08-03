import 'package:flutter/material.dart';

class GhostAutocompleteController extends TextEditingController {
  GhostAutocompleteController({super.text});

  String _suggestion = '';
  String get suggestion => _suggestion;
  set suggestion(String value) {
    if (_suggestion != value) {
      _suggestion = value;
      notifyListeners();
    }
  }

  TextStyle? suggestionStyle;
  bool showTabBadge = false;
  Widget? tabBadge;
  VoidCallback? onTabBadgePressed;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<InlineSpan> children = [];
    
    // Add real text
    children.add(super.buildTextSpan(
      context: context,
      style: style,
      withComposing: withComposing,
    ));

    // Add ghost suggestion
    if (_suggestion.isNotEmpty) {
      children.add(TextSpan(
        text: _suggestion,
        style: suggestionStyle ?? style?.copyWith(color: style.color?.withOpacity(0.3) ?? Colors.grey.withOpacity(0.3)),
      ));

      if (showTabBadge) {
        children.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: onTabBadgePressed,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: tabBadge ??
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Tab',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            ),
          ),
        ));
      }
    }

    return TextSpan(style: style, children: children);
  }
}
