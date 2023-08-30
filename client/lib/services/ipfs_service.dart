import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../configs/keys.dart';
class IpfsService extends ChangeNotifier {
  Future<String> uploadImage(String imgPath) async {
    try {
      final bytes = File(imgPath).readAsBytesSync();

      final response = await http.post(
        Uri.parse('https://api.nft.storage/upload'),
        headers: {
          'Authorization': 'Bearer $ipfsApiKey',
          'content-type': 'image/*'
        },
        body: bytes,
      );

      final data = jsonDecode(response.body);

      final cid = data['value']['cid'];

      if (kDebugMode) {
        print('CID OF IMAGE -> $cid');
        getImage(cid);
      }
      if (kDebugMode) {
        print('CID: $cid');
      }
      notifyListeners();
      return cid;
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        print('Error at IPFS Service - uploadImage: $e');
      }
      rethrow;
    }
  }

  Future<http.Response> getImage(String cid) async {
    try {
      final response = await http.get(Uri.parse(ipfsURL + cid));
      if (kDebugMode) {
        print("........................................");
      }
      notifyListeners();
      return response;
    } catch (e) {
      debugPrint('Error at IPFS Service - getImage: $e');

      rethrow;
    }
  }

  Future<String> uploadImageWeb(Uint8List bytes) async {
    try {
      // final bytes = File(imgPath).readAsBytesSync();

      final response = await http.post(
        Uri.parse('https://api.nft.storage/upload'),
        headers: {
          'Authorization': 'Bearer $ipfsApiKey',
          'content-type': 'image/*'
        },
        body: bytes,
      );

      final data = jsonDecode(response.body);

      final cid = data['value']['cid'];

      if (kDebugMode) {
        print('CID OF IMAGE -> $cid');
        getImage(cid);
      }
      if (kDebugMode) {
        print('CID: $cid');
      }
      return cid;
    } catch (e) {
      if (kDebugMode) {
        print('Error at IPFS Service - uploadImage: $e');
      }
      rethrow;
    }
  }
}
