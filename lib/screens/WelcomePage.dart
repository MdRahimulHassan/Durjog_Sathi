import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'SignupPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _language = 'en'; // 'en' or 'bn'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.center,
                image: AssetImage("assets/images/WelcomeScreenBg.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Language toggle
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _language = 'en';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _language == 'en' ? Colors.green.shade200 : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'English',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _language == 'en' ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _language = 'bn';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _language == 'bn' ? Colors.green.shade200 : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'বাংলা',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _language == 'bn' ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _language == 'en' ? "WELCOME TO" : "স্বাগতম",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  _language == 'en' ? "Durjog Bondhu" : "দুর্যোগ বন্ধু",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  ),
                  child: Text(_language == 'en' ? "LOGIN" : "লগইন"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  ),
                  child: Text(_language == 'en' ? "SIGNUP" : "সাইন আপ"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
