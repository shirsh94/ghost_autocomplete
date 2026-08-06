import 'dart:async';
import 'package:flutter/material.dart';

/// A callback that provides a list of suggestions based on the current text.
typedef GhostListSuggestionProvider = FutureOr<List<String>> Function(String text);

/// A widget that shows a dropdown list of suggestions as the user types.
class GhostAutocompleteListTextField extends StatefulWidget {
  const GhostAutocompleteListTextField({
    super.key,
    this.controller,
    required this.suggestionProvider,
    this.onSuggestionSelected,
    this.decoration = const InputDecoration(),
    this.style,
    this.dropdownDecoration,
    this.maxDropdownHeight = 200,
    this.itemBuilder,
    this.focusNode,
    this.autocorrect = true,
    this.spellCheckConfiguration,
  });

  /// The controller for the text field.
  final TextEditingController? controller;

  /// Logic to provide the list of suggestions.
  final GhostListSuggestionProvider suggestionProvider;

  /// Called when a suggestion is selected from the list.
  final ValueChanged<String>? onSuggestionSelected;

  /// The decoration to show around the text field.
  final InputDecoration decoration;

  /// Style for the text field.
  final TextStyle? style;

  /// Decoration for the dropdown container.
  final BoxDecoration? dropdownDecoration;

  /// Maximum height for the dropdown list.
  final double maxDropdownHeight;

  /// Custom builder for dropdown items.
  final Widget Function(BuildContext context, String suggestion)? itemBuilder;

  /// The focus node for the text field.
  final FocusNode? focusNode;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Configuration for spell check.
  final SpellCheckConfiguration? spellCheckConfiguration;

  @override
  State<GhostAutocompleteListTextField> createState() => _GhostAutocompleteListTextFieldState();
}

class _GhostAutocompleteListTextFieldState extends State<GhostAutocompleteListTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  bool _isDropdownOpen = false;
  bool _ignoreNextChange = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(GhostAutocompleteListTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onTextChanged);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChanged);
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _hideDropdown();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChanged);
    }
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _onTextChanged();
    } else {
      _hideDropdown();
    }
  }

  Future<void> _onTextChanged() async {
    if (_ignoreNextChange) {
      _ignoreNextChange = false;
      return;
    }

    final text = _controller.text;
    if (text.isEmpty) {
      setState(() {
        _suggestions = [];
        _hideDropdown();
      });
      return;
    }

    final suggestions = await widget.suggestionProvider(text);
    if (mounted) {
      setState(() {
        _suggestions = suggestions;
        if (_suggestions.isNotEmpty && _focusNode.hasFocus) {
          _showDropdown();
        } else {
          _hideDropdown();
        }
      });
    }
  }

  void _showDropdown() {
    if (_isDropdownOpen) {
      _overlayEntry?.markNeedsBuild();
      return;
    }

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _layerLink.leaderSize?.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, _layerLink.leaderSize?.height ?? 0),
          child: Material(
            elevation: 4,
            child: Container(
              constraints: BoxConstraints(maxHeight: widget.maxDropdownHeight),
              decoration: widget.dropdownDecoration ??
                  BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return InkWell(
                    onTap: () => _selectSuggestion(suggestion),
                    child: widget.itemBuilder != null
                        ? widget.itemBuilder!(context, suggestion)
                        : ListTile(
                            title: Text(suggestion),
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
    _isDropdownOpen = true;
  }

  void _hideDropdown() {
    if (_isDropdownOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isDropdownOpen = false;
    }
  }

  void _selectSuggestion(String suggestion) {
    _ignoreNextChange = true;
    _controller.text = suggestion;
    _controller.selection = TextSelection.collapsed(offset: suggestion.length);
    _hideDropdown();
    _focusNode.unfocus();
    widget.onSuggestionSelected?.call(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: widget.decoration,
        style: widget.style,
        autocorrect: widget.autocorrect,
        spellCheckConfiguration: widget.spellCheckConfiguration,
      ),
    );
  }
}
