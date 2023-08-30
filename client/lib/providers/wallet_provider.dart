import 'package:client/configs/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'package:web3dart/web3dart.dart';

import '../services/wallet_service.dart';

enum WalletState { empty, loading, loaded, success, error, logout }

class WalletProvider {
  final WalletService _walletService = WalletService();
  final Web3Client _web3client = Web3Client(rpcUrl, Client());
  // GasPriceService? _gasPriceService;
  // ContractService? _contractService;

  WalletState state = WalletState.empty;
  String errMessage = "";
  double accountBalance = 0.0;
  Credentials? _credentials;
  EthereumAddress? ethereumAddress;
  EtherAmount? etherAmount;
  // GasInfo? gasInfo;
  Transaction? transactionInfo;
  double totalAmount = 0;
  String lastTxHash = "";
  double maticPrice = 0;
  Function? onNetworkConfirmationRun;
  Future getBalance() async {
    etherAmount = await _web3client
        .getBalance(EthereumAddress.fromHex(ethereumAddress!.hex));
    accountBalance =
        etherAmount!.getInWei / BigInt.parse("1000000000000000000");
    
    return accountBalance;
  }

  initializeWallet() async {
    _credentials = await _walletService.initializeWalletAgain();
    ethereumAddress = _credentials!.address;
    getBalance();
  }

  initializeFromKey(String privateKey) {
    try {
      _credentials = _walletService.initializeWallet(privateKey);
      ethereumAddress = _credentials!.address;
      _walletService.setPrivateKey(privateKey);
      getBalance();

      return true;
    } on FormatException catch (e) {
      debugPrint('Error: ${e.message}');
    } catch (e) {
      debugPrint('Error: $e');
    }

    return false;
  }

  void createWallet() {
    _credentials = _walletService.generateRandomAccount();
    ethereumAddress = _credentials!.address;
    getBalance();
  }
}
