import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class WalletService extends ChangeNotifier {
  SharedPreferences? prefs;
  Credentials generateRandomAccount() {
    final cred = EthPrivateKey.createRandom(Random.secure());
    final key = bytesToHex(cred.privateKey, padToEvenLength: true);
    setPrivateKey(key);
    notifyListeners();
    return cred;
  }

  Credentials initializeWallet(String key) {
    notifyListeners();
    return EthPrivateKey.fromHex(key);
  }

  Future<Credentials> initializeWalletAgain() async {
    notifyListeners();
    return EthPrivateKey.fromHex(await getPrivateKey());
  }

  Future<String> getPrivateKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    return prefs.getString('user') ?? "";
  }

  Future<bool> removePrivateKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    return prefs.clear();
  }

  setPrivateKey(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    await prefs.setString('user', value);
  }
}
