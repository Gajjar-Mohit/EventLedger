import 'dart:async';

import 'package:client/pages/issuer/onboarding.dart';
import 'package:client/providers/wallet_provider.dart';
import 'package:client/services/contract_service.dart';
import 'package:client/services/ipfs_service.dart';
import 'package:client/services/wallet_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:web3dart/web3dart.dart';

class IssuerHome extends StatefulWidget {
  const IssuerHome({super.key});

  @override
  State<IssuerHome> createState() => _IssuerHomeState();
}

class _IssuerHomeState extends State<IssuerHome> {
  WalletService walletService = WalletService();
  void logout() {
    walletService.removePrivateKey().then((value) => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Onboarding())));
    // ContractService contactService =
    //     Provider.of<ContractService>(context, listen: false);
    // WalletProvider wallet = Provider.of<WalletProvider>(context, listen: false);
    // wallet.getBalance();
    // print(wallet.accountBalance);
    // contactService
    //     .registerEventFunction(
    //         "Spoural 2023",
    //         "21/JAN/2023",
    //         EthereumAddress.fromHex(
    //             '0x1cf847fefd7858e8e4d226f234dfd4fcdeb98c3d'))
    //     .then((value) {
    //   print("Registered");
    // });
  }

  String name = "Enter the name";
  String prize = "Enter the prize ";
  final TextEditingController _nameFieldContoller = TextEditingController();
  final TextEditingController _prizeFieldContoller = TextEditingController();
  enterNameDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter the name'),
            content: TextField(
              onChanged: (value) {},
              onSubmitted: (value) {
                print(value);
                setState(() {
                  name = value;
                  Navigator.pop(context);
                });
              },
              controller: _nameFieldContoller,
              decoration: const InputDecoration(hintText: "David Bombal"),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    name = _nameFieldContoller.text;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  enterPrizeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter the prize'),
            content: TextField(
              onChanged: (value) {},
              onSubmitted: (value) {
                print(value);
                setState(() {
                  prize = "$value ";
                });
                Navigator.pop(context);
              },
              controller: _prizeFieldContoller,
              decoration: const InputDecoration(hintText: "Attending"),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    prize = "${_prizeFieldContoller.text} ";
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  IpfsService ipfsService = IpfsService();
  void captureCertificatePNG() {
    ContractService contactService =
        Provider.of<ContractService>(context, listen: false);
    screenshotController.capture().then((image) {
      ipfsService.uploadImageWeb(image!).then((cid) {
        contactService.generateCertificateFunction(cid).then((value) {
          Fluttertoast.showToast(msg: "Certificate Uploaded");
        });
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    getEventDetails();
    super.initState();
  }

  String eventName = "", eventDate = "";
  void getEventDetails() async {
    ContractService contactService =
        Provider.of<ContractService>(context, listen: false);

    await walletService.getPrivateKey().then((privateKey) {
      Future.delayed(const Duration(milliseconds: 500), () {
        contactService
            .getEventFunction(EthPrivateKey.fromHex(privateKey).address)
            .then((event) {
          print(event);
          setState(() {
            eventName = event[0];
            eventDate = event[1];
          });
        });
      });
    });
  }

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "b",
            onPressed: captureCertificatePNG,
            label: const Text("Upload"),
            icon: const Icon(Icons.upload_file),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            heroTag: "a",
            onPressed: logout,
            label: const Text("Logout"),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
            width: 1920,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: const Color.fromARGB(255, 231, 234, 239)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Certificate",
                      style: TextStyle(
                          fontSize: 90, height: 1, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "of Appreciation",
                      style: TextStyle(
                          fontSize: 50, height: 1, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "This certificate is awareded to",
                      style: TextStyle(
                          fontSize: 20, height: 1, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        enterNameDialog(context);
                      },
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  'In recognition of their dedication and contribution to the event, we hereby present this certificate as a token of appreciation on ',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  enterPrizeDialog(context);
                                },
                              text: prize,
                              style: const TextStyle(
                                color: Color(0xFF4B39EF),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(
                              text: 'in ',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: "$eventName ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'held on $eventDate.',
                              style: const TextStyle(),
                            ),
                          ],
                          style: const TextStyle(
                            color: Color(0xFF57636C),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Certificate is Verified by"),
                            Text(
                              "EventLedger",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/verified.png',
                          height: 100,
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  width: 40,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: const DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage("assets/image.jpeg"))),
                )
              ],
            )),
      ),
    );
  }
}
