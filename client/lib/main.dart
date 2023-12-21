import 'package:client/pages/issuer/home.dart';
import 'package:client/pages/issuer/onboarding.dart';
import 'package:client/pages/validator/home.dart';
import 'package:client/providers/wallet_provider.dart';
import 'package:client/services/contract_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'services/wallet_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  bool isLoggedIn = false;
  void checkLogin() {
    WalletService().getPrivateKey().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WalletService>(create: (_) => WalletService()),
        ChangeNotifierProvider<WalletProvider>(create: (_) => WalletProvider()),
        ChangeNotifierProvider<ContractService>(
            create: (_) => ContractService()),
      ],
      child: MaterialApp(
          title: 'Event Ledger',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: isLoggedIn ? const IssuerHome() : const Onboarding()),
    );
  }
}

class Validator extends StatelessWidget {
  const Validator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Ledger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ValidatorHome(),);
  }
}
