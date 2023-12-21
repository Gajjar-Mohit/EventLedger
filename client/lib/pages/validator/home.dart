import 'package:flutter/material.dart';

class ValidatorHome extends StatefulWidget {
  const ValidatorHome({Key? key}) : super(key: key);

  @override
  State<ValidatorHome> createState() => _ValidatorHomeState();
}

class _ValidatorHomeState extends State<ValidatorHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Verify your certificate", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Paste your private key/link here',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'This is a sample text widget',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
