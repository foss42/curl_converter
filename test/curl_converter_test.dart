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

  test('Check quotes support for URL string', () async {
    expect(
      Curl.parse('curl -X GET "https://www.example.com/"'),
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

  test('parses a lot of headers', () async {
    expect(
      Curl.parse(
        r'curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36" -H "Upgrade-Insecure-Requests: 1" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en,en-GB;q=0.9,en-US;q=0.8,ru;q=0.7" -H "Cache-Control: max-age=0" -H "Dnt: 1" -H "Sec-Ch-Ua: \"Google Chrome\";v=\"117\", \"Not;A=Brand\";v=\"8\", \"Chromium\";v=\"117\"" -H "Sec-Ch-Ua-Mobile: ?0" -H "Sec-Ch-Ua-Platform: \"macOS\"" -H "Sec-Fetch-Dest: document" -H "Sec-Fetch-Mode: navigate" -H "Sec-Fetch-Site: same-origin" -H "Sec-Fetch-User: ?1" https://animego.org/anime/eta-farforovaya-kukla-vlyubilas-1937',
      ),
      Curl(
        method: 'GET',
        uri: Uri.parse('https://animego.org/anime/eta-farforovaya-kukla-vlyubilas-1937'),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36',
          'Upgrade-Insecure-Requests': '1',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
          'Accept-Encoding': 'gzip, deflate, br',
          'Accept-Language': 'en,en-GB;q=0.9,en-US;q=0.8,ru;q=0.7',
          'Cache-Control': 'max-age=0',
          'Dnt': '1',
          'Sec-Ch-Ua': '"Google Chrome";v="117", "Not;A=Brand";v="8", "Chromium";v="117"',
          'Sec-Ch-Ua-Mobile': '?0',
          'Sec-Ch-Ua-Platform': '"macOS"',
          'Sec-Fetch-Dest': 'document',
          'Sec-Fetch-Mode': 'navigate',
          'Sec-Fetch-Site': 'same-origin',
          'Sec-Fetch-User': '?1'
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

  test('tryParse return null when parses wrong input', () async {
    expect(
      Curl.tryParse('1f'),
      null,
    );
  }, timeout: defaultTimeout);

  test('tryParse success', () async {
    expect(
      Curl.tryParse(
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
}
