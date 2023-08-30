import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class WalletService {
  SharedPreferences? prefs;
  Credentials generateRandomAccount() {
    final cred = EthPrivateKey.createRandom(Random.secure());
    final key = bytesToHex(cred.privateKey, padToEvenLength: true);
    setPrivateKey(key);
    return cred;
  }

  Credentials initializeWallet(String key) {
    return EthPrivateKey.fromHex(key);
  }

  Future<Credentials> initializeWalletAgain() async {
    return EthPrivateKey.fromHex(await getPrivateKey());
  }

  Future<String> getPrivateKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user') ?? "";
  }

  Future<bool> removePrivateKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  setPrivateKey(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', value);
  }
}
