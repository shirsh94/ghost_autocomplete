import 'package:flutter/material.dart';
import 'package:ghost_autocomplete/ghost_autocomplete.dart';

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
  final _formKey = GlobalKey<FormState>();
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

  String? _getSuggestion(String text) {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ghost Autocomplete'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Inline Ghost', icon: Icon(Icons.text_fields)),
              Tab(text: 'Form Field', icon: Icon(Icons.assignment)),
              Tab(text: 'Dropdown List', icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Inline Ghost
            _buildTabContent(
              title: 'Inline Ghost Text',
              subtitle: 'Predictive typing like GitHub Copilot.',
              child: Column(
                children: [
                  GhostAutocompleteTextField(
                    suggestionProvider: _getSuggestion,
                    style: const TextStyle(fontSize: 18),

                    decoration: const InputDecoration(
                      labelText: 'Standard Input',
                      hintText: 'Try typing "hello"...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text('Native Features Demo', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GhostAutocompleteTextField(
                    suggestionProvider: (text) => text.isNotEmpty ? 'Correction enabled' : null,
                    autocorrect: true,
                    spellCheckConfiguration: const SpellCheckConfiguration(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type with typos to see spell check',
                      helperText: 'Native spell check + Ghost text enabled',
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
                      try {
                        return suggestions.firstWhere(
                          (s) => s.toLowerCase().startsWith(text.toLowerCase()) &&
                              s.toLowerCase() != text.toLowerCase(),
                        );
                      } catch (_) {
                        return null;
                      }
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
            ),

            // Tab 2: Form Field
            _buildTabContent(
              title: 'Text Form Field',
              subtitle: 'Validation and Form integration.',
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GhostAutocompleteTextFormField(
                      suggestionProvider: _getSuggestion,
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
            ),

            // Tab 3: Dropdown List
            _buildTabContent(
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
                      try {
                        return suggestions.firstWhere(
                          (s) => s.toLowerCase().startsWith(text.toLowerCase()) &&
                              s.toLowerCase() != text.toLowerCase(),
                        );
                      } catch (_) {
                        return null;
                      }
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent({required String title, required String subtitle, required Widget child}) {
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
