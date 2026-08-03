import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ghost_autocomplete_controller.dart';

/// A callback that provides a suggestion based on the current text.
/// Supports both synchronous (String?) and asynchronous (Future<String?>) results.
typedef GhostSuggestionProvider = FutureOr<String?> Function(String text);

/// A TextField that displays a "ghost" suggestion tail based on the user's input.
class GhostAutocompleteTextField extends StatefulWidget {
  const GhostAutocompleteTextField({
    super.key,
    this.controller,
    required this.suggestionProvider,
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
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
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
    this.spellCheckConfiguration,
  });

  final TextEditingController? controller;
  final GhostSuggestionProvider suggestionProvider;
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
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final dynamic selectionHeightStyle;
  final dynamic selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final dynamic dragStartBehavior;
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
  final SpellCheckConfiguration? spellCheckConfiguration;

  @override
  State<GhostAutocompleteTextField> createState() => _GhostAutocompleteTextFieldState();
}

class _GhostAutocompleteTextFieldState extends State<GhostAutocompleteTextField> {
  GhostAutocompleteController? _internalController;
  late final FocusNode _focusNode;
  bool _hasFocus = false;
  int _lastRequestId = 0;

  GhostAutocompleteController get _effectiveController {
    if (widget.controller is GhostAutocompleteController) {
      return widget.controller as GhostAutocompleteController;
    }
    return _internalController!;
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller is! GhostAutocompleteController) {
      _internalController = GhostAutocompleteController(text: widget.controller?.text);
    }
    _focusNode = widget.focusNode ?? FocusNode();
    _effectiveController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
    _hasFocus = _focusNode.hasFocus;
    
    _updateControllerProps();
  }

  @override
  void didUpdateWidget(GhostAutocompleteTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      if (widget.controller is GhostAutocompleteController) {
        _internalController?.dispose();
        _internalController = null;
      } else if (_internalController == null) {
        _internalController = GhostAutocompleteController(text: widget.controller?.text);
      }
      _effectiveController.addListener(_onTextChanged);
    }
    _updateControllerProps();
  }

  void _updateControllerProps() {
    _effectiveController.suggestionStyle = widget.suggestionStyle;
    _effectiveController.showTabBadge = widget.showTabBadge && _hasFocus;
    _effectiveController.tabBadge = widget.tabBadge;
    _effectiveController.onTabBadgePressed = _acceptSuggestion;
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onTextChanged);
    _internalController?.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChanged);
    }
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
      _updateControllerProps();
    });
  }

  Future<void> _onTextChanged() async {
    final text = _effectiveController.text;
    final requestId = ++_lastRequestId;

    final dynamic result = widget.suggestionProvider(text);
    final String? suggestion;

    if (result is Future<String?>) {
      suggestion = await result;
    } else {
      suggestion = result as String?;
    }

    // Prevent race conditions: only update if this was the latest request
    if (requestId != _lastRequestId || !mounted) return;

    if (suggestion != null &&
        suggestion.toLowerCase().startsWith(text.toLowerCase()) &&
        text.isNotEmpty &&
        suggestion.length > text.length) {
      _effectiveController.suggestion = suggestion.substring(text.length);
    } else {
      _effectiveController.suggestion = '';
    }
  }

  void _acceptSuggestion() {
    final suggestion = _effectiveController.suggestion;
    if (suggestion.isNotEmpty) {
      final fullText = _effectiveController.text + suggestion;
      _effectiveController.value = _effectiveController.value.copyWith(
        text: fullText,
        selection: TextSelection.collapsed(offset: fullText.length),
      );
      _effectiveController.suggestion = '';
      widget.onSuggestionAccepted?.call(fullText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.tab ||
              event.logicalKey == LogicalKeyboardKey.arrowRight) {
            if (_effectiveController.suggestion.isNotEmpty &&
                _effectiveController.selection.extentOffset == _effectiveController.text.length) {
              _acceptSuggestion();
              return KeyEventResult.handled;
            }
          }
        }
        return KeyEventResult.ignored;
      },
      child: TextField(
        controller: _effectiveController,
        focusNode: _focusNode,
        scrollController: widget.scrollController,
        style: widget.style,
        strutStyle: widget.strutStyle,
        decoration: widget.decoration,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        textDirection: widget.textDirection,
        readOnly: widget.readOnly,
        showCursor: widget.showCursor,
        autofocus: widget.autofocus,
        obscuringCharacter: widget.obscuringCharacter,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        enableSuggestions: widget.enableSuggestions,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        maxLength: widget.maxLength,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        keyboardAppearance: widget.keyboardAppearance,
        scrollPadding: widget.scrollPadding,
        dragStartBehavior: widget.dragStartBehavior,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        onTap: widget.onTap,
        mouseCursor: widget.mouseCursor,
        buildCounter: widget.buildCounter,
        scrollPhysics: widget.scrollPhysics,
        autofillHints: widget.autofillHints,
        restorationId: widget.restorationId,
        spellCheckConfiguration: widget.spellCheckConfiguration,
      ),
    );
  }
}

class GhostAutocompleteTextFormField extends FormField<String> {
  GhostAutocompleteTextFormField({
    super.key,
    this.controller,
    required GhostSuggestionProvider suggestionProvider,
    ValueChanged<String>? onSuggestionAccepted,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    TextStyle? suggestionStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    bool? showCursor,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    String? restorationId,
    bool showTabBadge = true,
    Widget? tabBadge,
    ScrollController? scrollController,
    SpellCheckConfiguration? spellCheckConfiguration,
    super.onSaved,
    super.validator,
  }) : assert(initialValue == null || controller == null),
       super(
        initialValue: controller != null ? controller.text : (initialValue ?? ''),
        enabled: enabled ?? decoration.enabled,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
        restorationId: restorationId,
        builder: (FormFieldState<String> field) {
          final _GhostAutocompleteTextFormFieldState state = field as _GhostAutocompleteTextFormFieldState;
          
          void onChangedHandler(String value) {
            field.didChange(value);
            if (onChanged != null) {
              onChanged(value);
            }
          }

          return GhostAutocompleteTextField(
            controller: state._effectiveController,
            suggestionProvider: suggestionProvider,
            onSuggestionAccepted: (val) {
              field.didChange(val);
              onSuggestionAccepted?.call(val);
            },
            focusNode: focusNode,
            decoration: decoration.copyWith(errorText: field.errorText),
            keyboardType: keyboardType,
            textInputAction: textInputAction ?? TextInputAction.done,
            style: style,
            suggestionStyle: suggestionStyle,
            textDirection: textDirection,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            textCapitalization: textCapitalization,
            autofocus: autofocus,
            readOnly: readOnly,
            showCursor: showCursor,
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
            onChanged: onChangedHandler,
            onTap: onTap,
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
            buildCounter: buildCounter,
            scrollPhysics: scrollPhysics,
            autofillHints: autofillHints,
            showTabBadge: showTabBadge,
            tabBadge: tabBadge,
            scrollController: scrollController,
            spellCheckConfiguration: spellCheckConfiguration,
          );
        },
      );

  final TextEditingController? controller;

  @override
  FormFieldState<String> createState() => _GhostAutocompleteTextFormFieldState();
}

class _GhostAutocompleteTextFormFieldState extends FormFieldState<String> {
  GhostAutocompleteController? _controller;

  GhostAutocompleteController get _effectiveController => (widget.controller as GhostAutocompleteController?) ?? _controller!;

  @override
  GhostAutocompleteTextFormField get widget => super.widget as GhostAutocompleteTextFormField;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = GhostAutocompleteController(text: widget.initialValue);
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(GhostAutocompleteTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller = GhostAutocompleteController(text: oldWidget.controller!.text);
      } else if (oldWidget.controller == null && widget.controller != null) {
        _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
    }
  }

  @override
  void reset() {
    _effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}
