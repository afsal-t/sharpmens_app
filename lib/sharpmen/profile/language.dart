import 'package:flutter/material.dart';


class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({Key? key, required void Function(String languageCode) onLanguageChanged}) : super(key: key);

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  // Define the list of supported languages
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'ml', 'name': 'മലയാളം'}, // Malayalam
    // Add more languages here if needed
  ];

  String _selectedLanguage = 'en'; // Default language

  // Change language based on the selection
  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
    // You need to implement changing the language in the app here
    // This would typically involve using the locale system or a state management solution
    print('Selected language: $languageCode');
    // You would typically update the app's locale here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your preferred language:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // List of languages for selection
            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_languages[index]['name']!),
                    onTap: () {
                      _changeLanguage(_languages[index]['code']!);
                    },
                    trailing: _languages[index]['code'] == _selectedLanguage
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}