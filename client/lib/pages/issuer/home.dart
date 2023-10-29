import 'dart:async';
import 'package:client/pages/issuer/onboarding.dart';
import 'package:client/services/contract_service.dart';
import 'package:client/services/ipfs_service.dart';
import 'package:client/services/wallet_service.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/src/painting/box_border.dart' as Border;

class IssuerHome extends StatefulWidget {
  const IssuerHome({super.key});

  @override
  State<IssuerHome> createState() => _IssuerHomeState();
}

class _IssuerHomeState extends State<IssuerHome> {
  WalletService walletService = WalletService();
  bool isLoading = false;
  void logout() {
    walletService.removePrivateKey().then((value) => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Onboarding())));
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
    if (_nameFieldContoller.text.isNotEmpty && _prizeFieldContoller.text.isNotEmpty) {
      screenshotController.capture().then((image) {
        ipfsService.uploadImageWeb(image!).then((cid) {
          contactService.generateCertificateFunction(cid).then((value) {
            String link = "";
            setState(() {
              isLoading = false;
              link = "https://ipfs.io/ipfs/$cid";
            });
            writeData(name, prize, link);
            Fluttertoast.showToast(msg: "Certificate Uploaded");
            prize = "Enter the prize ";
            name = "Enter the name";
            _prizeFieldContoller.clear();
            _nameFieldContoller.clear();
          });
        });
      }).catchError((onError) {
        print(onError);
      });
    } else {
      Fluttertoast.showToast(msg: "Please enter the name and prize");
    }
  }

  @override
  void initState() {
    getEventDetails();
    super.initState();
  }

  var excel = Excel.createExcel();
  FilePickerResult? pickedFile;
  void downloadExcel() async {
    excel.save();
  }

  void writeData(String name, String prize, String link) async {
    setState(() {
      Sheet sheetObject = excel[excel.sheets.keys.first];
      sheetObject.appendRow([name, prize, link]);
      for (var table in excel.tables.keys) {
        print(table); //sheet Name
        print(excel.tables[table]!.maxColumns);
        print(excel.tables[table]!.maxRows);
        for (var row in excel.tables[table]!.rows) {
          print('$row');
        }
      }
    });
  }

  bool changeTheme = false;

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
  Widget theme2() {
    return Screenshot(
      controller: screenshotController,
      child: Container(
          width: MediaQuery.of(context).size.width,
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  Widget theme1() {
    return Screenshot(
        controller: screenshotController,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.Border.all(
              color: Colors.blueAccent,
              width: 6,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.Border.all(
                color: Colors.redAccent,
                width: 6,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                    height: 150, child: Image.asset('assets/charusatlogo.png')),
                const SizedBox(
                  height: 100,
                ),
                Center(
                  child: Text(
                    "CERTIFICATE",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300]),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Text(
                    "This Certificate is Awarded to",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text:
                              'In recognition of their dedication and contribution to the event, we hereby present this certificate as a token of appreciation on ',
                          style: TextStyle(fontSize: 30),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              enterPrizeDialog(context);
                            },
                          text: prize,
                          style: const TextStyle(
                            color: Color(0xFF4B39EF),
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: 'in ',
                          style: TextStyle(fontSize: 30),
                        ),
                        TextSpan(
                          text: "$eventName ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'held on $eventDate.',
                          style: const TextStyle(fontSize: 30),
                        ),
                      ],
                      style: const TextStyle(
                        color: Color(0xFF57636C),
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
          ),
        ));
  }

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
            heroTag: "c",
            onPressed: downloadExcel,
            label: const Text("Download Excel file"),
            icon: const Icon(Icons.file_download_outlined),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            heroTag: "d",
            onPressed: () {
              setState(() {
                changeTheme = !changeTheme;
              });
            },
            label: const Text("Change Template"),
            icon: const Icon(Icons.change_circle_outlined),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : changeTheme
              ? theme1()
              : theme2(),
    );
  }
}
