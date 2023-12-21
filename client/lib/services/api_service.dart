import 'dart:convert';
import 'package:client/configs/keys.dart';
import 'package:http/http.dart' as http;

class ApiService {
  void sendEmail(String email, String link, String name) async {
    final headers = {'Content-Type': 'application/json'};

    final data = {
      'service_id': emailJSServiceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'to_name': name,
        'to_email': email,
        'message': link,
      },
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrlEmailJs),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Email sent successfully');
      } else {
        print('Failed to send email. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}
