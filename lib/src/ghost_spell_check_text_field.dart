import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'ghost_autocomplete_widget.dart';
import 'ghost_spell_check_service.dart';

/// A widget that combines inline ghost autocomplete with a custom spell check service.
class GhostSpellCheckTextField extends StatelessWidget {
  const GhostSpellCheckTextField({
    super.key,
    this.controller,
    required this.suggestionProvider,
    this.spellCheckSuggestions,
    this.spellCheckSuggestionsProvider,
    this.isMisspelled,
    this.onSuggestionAccepted,
    this.style,
    this.suggestionStyle,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.onTap,
    this.mouseCursor,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.restorationId,
    this.focusNode,
    this.showTabBadge = true,
    this.tabBadge,
    this.scrollController,
    this.strutStyle,
    this.misspelledTextStyle,
  });

  /// Controller for the text field.
  final TextEditingController? controller;

  /// Provider for inline ghost suggestions.
  final GhostSuggestionProvider suggestionProvider;

  /// A static list of words for custom spell check suggestions.
  final List<String>? spellCheckSuggestions;

  /// An asynchronous provider for custom spell check suggestions.
  final SpellCheckSuggestionsProvider? spellCheckSuggestionsProvider;

  /// A custom validator to determine if a word is misspelled.
  final bool Function(String word)? isMisspelled;

  /// Callback when a ghost suggestion is accepted.
  final ValueChanged<String>? onSuggestionAccepted;

  final TextStyle? style;
  final TextStyle? suggestionStyle;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final VoidCallback? onTap;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final FocusNode? focusNode;
  final bool showTabBadge;
  final Widget? tabBadge;
  final ScrollController? scrollController;
  final StrutStyle? strutStyle;

  /// The style to use for misspelled words.
  final TextStyle? misspelledTextStyle;

  @override
  Widget build(BuildContext context) {
    return GhostAutocompleteTextField(
      controller: controller,
      suggestionProvider: suggestionProvider,
      onSuggestionAccepted: onSuggestionAccepted,
      style: style,
      suggestionStyle: suggestionStyle,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      readOnly: readOnly,
      showCursor: showCursor,
      autofocus: autofocus,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      onTap: onTap,
      mouseCursor: mouseCursor,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      restorationId: restorationId,
      focusNode: focusNode,
      showTabBadge: showTabBadge,
      tabBadge: tabBadge,
      scrollController: scrollController,
      strutStyle: strutStyle,
      spellCheckConfiguration: SpellCheckConfiguration(
        spellCheckService: GhostSpellCheckService(
          suggestions: spellCheckSuggestions,
          suggestionsProvider: spellCheckSuggestionsProvider,
          isMisspelled: isMisspelled,
        ),
        misspelledTextStyle: misspelledTextStyle ??
            const TextStyle(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.wavy,
              decorationColor: Colors.red,
            ),
      ),
    );
  }
}
