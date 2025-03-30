import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

const String lowercaseLetters = "abcdefghijklmnopqrstuvwxyz";
const String uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
const String numbers = "0123456789";
const String specialCharacters = "!@#\$%^&*()-_=+<>?";

void main() {
  runApp(const PasswordGeneratorApp());
}

class PasswordGeneratorApp extends StatelessWidget {
  const PasswordGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Generator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
      ),
      home: const PasswordGeneratorScreen(),
    );
  }
}

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  double _passwordLength = 12;
  String _generatedPassword = "Your password will appear here";
  bool _includeUppercase = true;
  bool _includeNumbers = true;
  bool _includeSpecial = true;
  bool _includeLowercase = true;

  void _generatePassword() {
    String charSet = '';
    if (_includeLowercase) charSet += lowercaseLetters;
    if (_includeUppercase) charSet += uppercaseLetters;
    if (_includeNumbers) charSet += numbers;
    if (_includeSpecial) charSet += specialCharacters;

    if (charSet.isEmpty) {
      setState(() {
        _generatedPassword = "Select at least one character type.";
      });
      return;
    }

    Random random = Random();
    String password = List.generate(_passwordLength.toInt(), (index) => charSet[random.nextInt(charSet.length)]).join();

    setState(() {
      _generatedPassword = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Password Display Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[800],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurpleAccent),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _generatedPassword,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generatedPassword));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password copied!"))
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _generatePassword,
                child: const Text("Generate Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text("Password Length:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            Slider(
              value: _passwordLength,
              min: 8,
              max: 64,
              divisions: 56,
              label: _passwordLength.round().toString(),
              activeColor: Colors.deepPurpleAccent,
              inactiveColor: Colors.grey,
              onChanged: (double value) {
                setState(() {
                  _passwordLength = value;
                });
              },
            ),
            
            _buildCheckbox("Include Lowercase Letters", _includeLowercase, (value) {
              setState(() {
                _includeLowercase = value;
              });
            }),
            _buildCheckbox("Include Uppercase Letters", _includeUppercase, (value) {
              setState(() {
                _includeUppercase = value;
              });
            }),
            _buildCheckbox("Include Numeric Characters", _includeNumbers, (value) {
              setState(() {
                _includeNumbers = value;
              });
            }),
            _buildCheckbox("Include Special Characters", _includeSpecial, (value) {
              setState(() {
                _includeSpecial = value;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
      value: value,
      activeColor: Colors.deepPurpleAccent,
      onChanged: (bool val) => onChanged(val),
    );
  }
}
