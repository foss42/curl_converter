import 'dart:io';

import 'package:curl_converter/src/models/curl.dart';
import 'package:test/test.dart';

const defaultTimeout = Timeout(Duration(seconds: 3));
final exampleDotComUri = Uri.parse('https://www.example.com/');

void main() {
  test('parse an easy cURL', () async {
    expect(
      Curl.parse('curl -X GET https://www.example.com/'),
      Curl(
        method: 'GET',
        uri: exampleDotComUri,
      ),
    );
  }, timeout: defaultTimeout);

  test('compose an easy cURL', () async {
    expect(
      Curl.parse('curl -X GET https://www.example.com/'),
      Curl(
        method: 'GET',
        uri: exampleDotComUri,
      ),
    );
  }, timeout: defaultTimeout);

  test('parses two headers', () async {
    expect(
      Curl.parse(
        'curl -X GET https://www.example.com/ -H "${HttpHeaders.contentTypeHeader}: ${ContentType.text}" -H "${HttpHeaders.authorizationHeader}: Bearer %token%"',
      ),
      Curl(
        method: 'GET',
        uri: exampleDotComUri,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.text.toString(),
          HttpHeaders.authorizationHeader: 'Bearer %token%',
        },
      ),
    );
  }, timeout: defaultTimeout);

  test('throw exception when parses wrong input', () async {
    expect(
      () => Curl.parse('1f'),
      throwsException,
    );
  }, timeout: defaultTimeout);
}
