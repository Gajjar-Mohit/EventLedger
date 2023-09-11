// ignore: avoid_web_libraries_in_flutter, library_prefixes
import 'dart:html' as webFile;

import 'package:client/pages/issuer/home.dart';
import 'package:client/providers/wallet_provider.dart';
import 'package:client/services/contract_service.dart';
import 'package:client/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/wallet_service.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  WalletProvider walletProvider = WalletProvider();
  ContractService contractService = ContractService();
  void createWallet() async {
    walletProvider.createWallet();

    await walletProvider.getBalance().then((value) {
      setState(() {
        walletCard = true;
        balance = value.toString();
        etherAddress = walletProvider.ethereumAddress.toString();
      });
    });
    WalletService().getPrivateKey().then((value1) {
      if (value1.isNotEmpty) {
        if (kIsWeb) {
          var blob = webFile.Blob([value1], 'text/plain', 'native');

          webFile.AnchorElement(
            href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
          )
            ..setAttribute("download", "privatekey.txt")
            ..click();
          Fluttertoast.showToast(msg: "Private key has been downloaded.");
        }
      }
    });
  }

  void checkBalance() async {
    await walletProvider.getBalance().then((value) {
      setState(() {
        balance = value.toString();
      });
    });
  }

  Uri url = Uri.parse("https://faucet.polygon.technology/");
  Future<void> _launchUrl() async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void generateEvent() {
    print("Generate Event Function");
    if (balance != "0") {
      ContractService()
          .registerEventFunction(nameController.text, dateController.text)
          .then((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const IssuerHome()));
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please get some test Matic before proceeding");
    }
  }

  void checkValidation() {
    if (walletProvider.initializeFromKey(privateKeyController.text)) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const IssuerHome()));
      });
    } else {
      Fluttertoast.showToast(msg: "Invalid key or no account found");
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController privateKeyController = TextEditingController();
  bool registateState = true;
  bool walletCard = false;
  String balance = "", etherAddress = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 8,
              child: Container(
                width: 100,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                alignment: const AlignmentDirectional(0, -1),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                        alignment: const AlignmentDirectional(-1, 0),
                        child: const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
                          child: Text(
                            'Event Ledger',
                            style: TextStyle(
                              color: Color(0xFF101213),
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              32, 32, 32, 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              walletCard
                                  ? WalletCard(
                                      getMaticTap: _launchUrl,
                                      balance: balance,
                                      confirmTap: generateEvent,
                                      checkBalanceTap: checkBalance,
                                      etherAdd: etherAddress,
                                    )
                                  : registateState
                                      ? CreateEvent(
                                          submit: () {
                                            if (nameController
                                                    .text.isNotEmpty &&
                                                dateController
                                                    .text.isNotEmpty) {
                                              createWallet();
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please enter details before proceeding.");
                                            }
                                          },
                                          dateController: dateController,
                                          nameController: nameController,
                                          getAccessTap: () {
                                            setState(() {
                                              registateState = !registateState;
                                            });
                                          },
                                        )
                                      : AccessEvent(
                                          submit: checkValidation,
                                          privateKeyController:
                                              privateKeyController,
                                          createAccountTap: () {
                                            setState(() {
                                              registateState = !registateState;
                                            });
                                          },
                                        ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Container(
                  width: 100,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3540&q=80',
                      ),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
