# curl_dart

A Dart package that provides a `Curl` class for parsing and formatting cURL commands.

## Usage

1. Add the package to your `pubspec.yaml` file

2.  Use the package:
```dart
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
  print(formattedCurlString); // curl -X GET https://www.example.com/
}
```

## Features

- Parse a cURL command into a `Curl` class instance.
- Format a `Curl` object back into a cURL command.
- Supports various options such as request method, headers, data, cookies, user-agent, and more.

## Commands

### Publish new version

```
$ dart pub publish --dry-run
```

## Contributing

Contributions are welcome! Please create an issue or make a fork and propose a PR to contribute to this project.

## License

This project is licensed under the [Apache License 2.0](LICENSE).
