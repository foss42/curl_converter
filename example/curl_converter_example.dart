import 'package:curl_converter/curl_converter.dart';

void main() {
  // Parse a cURL command
  final curlString = 'curl -X GET https://www.example.com/';
  final curl = Curl.parse(curlString);

  // Access parsed data
  print(curl.method); // GET
  print(curl.uri); // https://www.example.com/

  // Format Curl object to a cURL command
  final formattedCurlString = curl.toCurlString();
  print(formattedCurlString); // curl "https://www.example.com/""
}
