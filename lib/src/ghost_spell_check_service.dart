import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A callback that provides spell check suggestions for a given word.
typedef SpellCheckSuggestionsProvider = FutureOr<List<String>?> Function(String word);

/// A custom [SpellCheckService] that uses a user-defined list or callback
/// to provide suggestions.
class GhostSpellCheckService extends SpellCheckService {
  GhostSpellCheckService({
    this.suggestions,
    this.suggestionsProvider,
    this.isMisspelled,
  });

  /// A static list of valid words.
  final List<String>? suggestions;

  /// An asynchronous callback to fetch suggestions for a specific word.
  final SpellCheckSuggestionsProvider? suggestionsProvider;

  /// A custom validator to determine if a word is misspelled.
  /// If null, a word is considered misspelled if it's not in the [suggestions] list.
  final bool Function(String word)? isMisspelled;

  @override
  Future<List<SuggestionSpan>?> fetchSpellCheckSuggestions(
    Locale locale,
    String text,
  ) async {
    final List<SuggestionSpan> suggestionSpans = [];
    final List<String> words = text.split(RegExp(r'\s+'));
    int startIndex = 0;

    for (String word in words) {
      if (word.isEmpty) continue;

      // Find the actual start index of the word in the text (to handle multiple spaces)
      final actualStart = text.indexOf(word, startIndex);
      if (actualStart == -1) continue;
      
      final bool misspelled = _checkIsMisspelled(word);

      if (misspelled) {
        final List<String>? customSuggestions = await _getSuggestions(word);

        if (customSuggestions != null && customSuggestions.isNotEmpty) {
          suggestionSpans.add(
            SuggestionSpan(
              TextRange(start: actualStart, end: actualStart + word.length),
              customSuggestions,
            ),
          );
        }
      }
      startIndex = actualStart + word.length;
    }

    return suggestionSpans;
  }

  bool _checkIsMisspelled(String word) {
    if (word.isEmpty) return false;
    
    if (isMisspelled != null) {
      return isMisspelled!(word);
    }

    if (suggestions != null) {
      return !suggestions!.contains(word.toLowerCase());
    }

    // If only provider is given and no validator, we assume everything might need check.
    return true; 
  }

  Future<List<String>?> _getSuggestions(String word) async {
    if (suggestionsProvider != null) {
      return await suggestionsProvider!(word);
    }

    if (suggestions != null) {
      // Simple fuzzy match or startsWith for demo/default purposes
      return suggestions!
          .where((s) => s.toLowerCase().startsWith(word.toLowerCase().substring(0, 1)))
          .take(5)
          .toList();
    }

    return null;
  }
}
