import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> makePayment() async {
  final client = http.Client();

  // Step 1: Make a GET request to get the CSRF token.
  final getResponse = await client.get(
    Uri.parse('http://127.0.0.1:8000/apai/get_csrf_token/'), 
  );

  // Extract the CSRF token from cookies.
  final cookies = getResponse.headers['set-cookie'];
  final csrfToken = RegExp(r'csrftoken=([^;]+)').firstMatch(cookies!)?.group(1);

  if (csrfToken == null) {
    print('Failed to retrieve CSRF token.');
    return;
  }

  // Step 2: Make a POST request with the CSRF token.
  final postResponse = await client.post(
    Uri.parse('http://127.0.0.1:8000/payment/process/'), // Replace with your actual URL.
    headers: {
      'Content-Type': 'application/json',
      'X-CSRFToken': csrfToken, // Include the CSRF token in the headers.
      'Cookie': cookies, // Include the session cookie to maintain the session.
    },
    body: jsonEncode({
      'total_amount': 100.0, // Example data
    }),
  );

  if (postResponse.statusCode == 200) {
    print('Payment processed successfully.');
  } else {
    print('Failed to process payment: ${postResponse.statusCode}');
  }
}
