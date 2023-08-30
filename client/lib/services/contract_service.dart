import 'dart:convert';

import 'package:client/configs/keys.dart';
import 'package:client/services/wallet_service.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ContractService {
  String? _privateKey;

  final Web3Client _web3client = Web3Client(rpcUrl, Client());
  String? _abiCode;
  EthereumAddress? _contractAddress;
  Credentials? _credentials;
  DeployedContract? _deployedContract;

  ContractFunction? registerEvent;
  ContractFunction? getAllEvent;
  ContractFunction? generateCertificate;
  ContractFunction? verifyCertificate;

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
    _privateKey = await WalletService().getPrivateKey();
  }

  Future getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/CreateCertificate.json");

    final jsonAbi = jsonDecode(abiStringFile);

    _abiCode = jsonEncode(jsonAbi['abi']);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['80001']['address']);
  }

  void getCredentials() {
    _credentials = EthPrivateKey.fromHex(_privateKey!);
  }

  void getDeployedContract() {
    _deployedContract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, "CreateCertificate"),
        _contractAddress!);

    registerEvent = _deployedContract!.function("registerEvent");
    getAllEvent = _deployedContract!.function("getAllEvents");
    generateCertificate = _deployedContract!.function("generateCertificate");
    verifyCertificate = _deployedContract!.function("verifyCertificate");
  }

  Future registerEventFunction(String eventName, String eventDate) async {
    await _web3client.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _deployedContract!,
            function: registerEvent!,
            parameters: [eventName, eventDate]),
        chainId: chainId);
  }

  Future generateCertificateFunction(
      String participentName, String certificateId, String priceWonFor) async {
    var certificateGenerated = await _web3client.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _deployedContract!,
            function: generateCertificate!,
            parameters: [participentName, certificateId, priceWonFor]),
        chainId: chainId);

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

    return certificate;
  }

  Future getAllEventsFunction() async {
    var events = await _web3client.call(
      contract: _deployedContract!,
      function: getAllEvent!,
      params: [],
    );

    return events;
  }
}
