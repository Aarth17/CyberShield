import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  Future<String> getPublicIP() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.ipify.org?format=json'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
        return data['ip'] as String? ?? 'Unavailable';
      }
      return 'Unavailable';
    } catch (_) {
      return 'Unavailable';
    }
  }

  Future<List<Map<String, String>>> getSecurityNews() async {
    return const [
      {
        'title': 'Enable Two-Factor Authentication',
        'description':
        'Add an extra layer of security to your accounts by enabling 2FA wherever possible.',
      },
      {
        'title': 'Use Strong Unique Passwords',
        'description':
        'Create complex passwords with 12+ characters, mixing letters, numbers, and symbols.',
      },
      {
        'title': 'Keep Software Updated',
        'description':
        'Regular updates patch security vulnerabilities and protect against threats.',
      },
      {
        'title': 'Beware of Phishing Attempts',
        'description':
        'Verify sender addresses and avoid clicking suspicious links in emails.',
      },
      {
        'title': 'Secure Your Network',
        'description':
        'Use WPA3 encryption on your WiFi and avoid public networks for sensitive tasks.',
      },
    ];
  }
}
