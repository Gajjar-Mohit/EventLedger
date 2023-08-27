import 'package:flutter/material.dart';

class IssuerHome extends StatefulWidget {
  const IssuerHome({super.key});

  @override
  State<IssuerHome> createState() => _IssuerHomeState();
}

class _IssuerHomeState extends State<IssuerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
              border: Border.all(
            color: Colors.black,
            width: 2
          )),
          child: const Column(
            children: [
              Text("Welcome to", style: TextStyle(fontSize: 40,height: 1),),
              Text("Event Ledger",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 1),
              )
            ],
          ),
        ),
      ),
    );
  }
}
