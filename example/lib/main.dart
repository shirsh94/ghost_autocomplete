import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghost Autocomplete Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ghost Autocomplete'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Inline Ghost', icon: Icon(Icons.text_fields)),
              Tab(text: 'Custom Spell', icon: Icon(Icons.spellcheck)),
              Tab(text: 'Form Field', icon: Icon(Icons.assignment)),
              Tab(text: 'Dropdown List', icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            InlineGhostTab(),
            CustomSpellTab(),
            FormFieldTab(),
            DropdownListTab(),
          ],
        ),
      ),
    );
  }
}

class TabLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const TabLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const Divider(height: 48),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSpellTab extends StatefulWidget {
  const CustomSpellTab({super.key});

  @override
  State<CustomSpellTab> createState() => _CustomSpellTabState();
}

class _CustomSpellTabState extends State<CustomSpellTab> {
  @override
  Widget build(BuildContext context) {
    return TabLayout(
      title: 'Custom Spell Check',
      subtitle: 'Suggestions from your own list or API.',
      child: Column(
        children: [
          const Text('Local List Suggestion', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GhostSpellCheckTextField(
            suggestionProvider: getSuggestion,
            spellCheckSuggestions: const ['how', 'ok', 'what', 'why', 'flutter', 'ghost'],
            misspelledTextStyle: const TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.red,
              decorationStyle: TextDecorationStyle.dotted,
              decorationThickness: 3,
            ),
            decoration: const InputDecoration(
              labelText: 'Custom Styled Spell Check',
              hintText: 'Type "hw" (dotted red underline)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Asynchronous API Spell Check', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GhostSpellCheckTextField(
            suggestionProvider: getSuggestion,
            spellCheckSuggestionsProvider: (word) async {
              // Simulate API call
              await Future.delayed(const Duration(milliseconds: 800));
              if (word.toLowerCase() == 'api') {
                return ['Application', 'Programming', 'Interface'];
              }
              return ['suggestion1', 'suggestion2'];
            },
            decoration: const InputDecoration(
              labelText: 'API Spell Check',
              hintText: 'Type "api" and tap it',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.api),
            ),
          ),
        ],
      ),
    );
  }
}

class DropdownListTab extends StatefulWidget {
  const DropdownListTab({super.key});

  @override
  State<DropdownListTab> createState() => _DropdownListTabState();
}

class _DropdownListTabState extends State<DropdownListTab> {
  @override
  Widget build(BuildContext context) {
    return TabLayout(
      title: 'Dropdown Selection',
      subtitle: 'Multiple choices like Google Maps search.',
      child: Column(
        children: [
          GhostAutocompleteListTextField(
            suggestionProvider: (text) {
              return suggestions
                  .where((s) => s.toLowerCase().contains(text.toLowerCase()))
                  .toList();
            },
            decoration: const InputDecoration(
              labelText: 'Search Places',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onSuggestionSelected: (val) {
              debugPrint('Selected: $val');
            },
          ),
          const SizedBox(height: 32),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'This widget shows a scrollable list of all matching suggestions using an Overlay.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Asynchronous API Demo', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GhostAutocompleteTextField(
            suggestionProvider: (text) async {
              if (text.isEmpty) return null;
              // Simulate network delay
              await Future.delayed(const Duration(milliseconds: 500));
              // Find match
              return getSuggestion(text);
            },
            decoration: const InputDecoration(
              labelText: 'API-backed Input',
              hintText: 'Simulates 500ms delay...',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.cloud_queue),
            ),
          ),
        ],
      ),
    );
  }
}


class FormFieldTab extends StatefulWidget {
  const FormFieldTab({super.key});

  @override
  State<FormFieldTab> createState() => _FormFieldTabState();
}

class _FormFieldTabState extends State<FormFieldTab> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return TabLayout(
      title: 'Text Form Field',
      subtitle: 'Validation and Form integration.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GhostAutocompleteTextFormField(
              suggestionProvider: getSuggestion,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form Validated!')),
                    );
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Validate and Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class InlineGhostTab extends StatefulWidget {
  const InlineGhostTab({super.key});

  @override
  State<InlineGhostTab> createState() => _InlineGhostTabState();
}

class _InlineGhostTabState extends State<InlineGhostTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateText() {
    _controller.text = "Hello Flutter";
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabLayout(
      title: 'Inline Ghost Text',
      subtitle: 'Predictive typing like GitHub Copilot.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GhostAutocompleteTextField(
            controller: _controller,
            suggestionProvider: getSuggestion,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              labelText: 'Standard Input',
              hintText: 'Try typing "hello"...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _updateText,
            child: const Text('Update Text'),
          ),
        ],
      ),
    );
  }
}


final List<String> suggestions = [
  'hello world!',
  'flutter is incredible',
  'ghost text autocomplete is here',
  'type something and see',
  'alright then, let\'s go!',
  'yeah alright',
  'support@example.com',
  'admin@domain.com',
  'google maps integration',
  'location search',
  'awesome flutter packages',
  'building beautiful uis',
  'dart programming language',
  'mobile app development',
  'web development with flutter',
  'desktop apps are easy',
  'machine learning on edge',
  'firebase cloud storage',
  'state management solutions',
  'widget testing fundamentals',
  'reactive programming style',
  'user experience design',
];

String? getSuggestion(String text) {
  if (text.isEmpty) return null;
  try {
    return suggestions.firstWhere(
          (s) => s.toLowerCase().startsWith(text.toLowerCase()) &&
          s.toLowerCase() != text.toLowerCase(),
    );
  } catch (_) {
    return null;
  }
}
