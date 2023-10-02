import 'dart:convert';

import 'package:client/configs/keys.dart';
import 'package:client/services/wallet_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ContractService extends ChangeNotifier {
  String? _privateKey;

  final Web3Client _web3client = Web3Client(rpcUrl, Client());
  WalletService walletService = WalletService();
  String? _abiCode;
  EthereumAddress? _contractAddress;
  Credentials? _credentials;
  DeployedContract? _deployedContract;

  ContractFunction? registerEvent;
  ContractFunction? getAllEvent;
  ContractFunction? generateCertificate;
  ContractFunction? verifyCertificate;
  ContractFunction? getEvent;

  ContractService() {
    setup();
  }
  Future setup() async {
    await getData();
    await getAbi();
    getCredentials();
    getDeployedContract();
  }

  Future getData() async {
    _privateKey = await walletService.getPrivateKey();
    print("------------------");
    print(_privateKey);
    notifyListeners();
  }

  Future getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/CreateCertificate.json");

    final jsonAbi = jsonDecode(abiStringFile);

    _abiCode = jsonEncode(jsonAbi['abi']);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['80001']['address']);
    print("Got the abi");
    notifyListeners();
  }

  void getCredentials() {
    print(_privateKey);
    print("-----------------------------------");
    _credentials = EthPrivateKey.fromHex(_privateKey!);
    print(_credentials!.address.toString());
    print("got the creds");
    notifyListeners();
  }

  void getDeployedContract() {
    _deployedContract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, "CreateCertificate"),
        _contractAddress!);

    registerEvent = _deployedContract!.function("registerEvent");
    getAllEvent = _deployedContract!.function("getAllEvents");
    generateCertificate = _deployedContract!.function("generateCertificate");
    verifyCertificate = _deployedContract!.function("verifyCertificate");
    getEvent = _deployedContract!.function("getEvent");

    print("Got the contract");
    notifyListeners();
  }

  Future registerEventFunction(
      String eventName, String eventDate, EthereumAddress add) async {
    print("Inside event generation function");
    await _web3client.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _deployedContract!,
            function: registerEvent!,
            parameters: [eventName, eventDate, add]),
        chainId: chainId);

    print("Event generated");
    notifyListeners();
  }

  Future generateCertificateFunction(String certificateId) async {
    var certificateGenerated = await _web3client.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _deployedContract!,
            function: generateCertificate!,
            parameters: [
              certificateId,
            ]),
        chainId: chainId);
    notifyListeners();
    return certificateGenerated;
  }

  Future verifyCertificateFunction(
      EthereumAddress eventAddress, String certificateId) async {
    var certificate = await _web3client.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _deployedContract!,
            function: verifyCertificate!,
            parameters: [eventAddress, certificateId]),
        chainId: chainId);
    notifyListeners();
    return certificate;
  }

  Future getEventFunction(EthereumAddress ethereumAddress) async {
    var event = await _web3client.call(
      contract: _deployedContract!,
      function: getEvent!,
      params: [ethereumAddress],
    );
    notifyListeners();
    return event;
  }

  Future getAllEventsFunction() async {
    var events = await _web3client.call(
      contract: _deployedContract!,
      function: getAllEvent!,
      params: [],
    );
    notifyListeners();
    return events;
  }
}
