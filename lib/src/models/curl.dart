import 'package:args/args.dart';
import 'package:curl_converter/utils/string.dart';
import 'package:equatable/equatable.dart';

/// A representation of a cURL command in Dart.
///
/// The Curl class provides methods for parsing a cURL command string
/// and formatting a Curl object back into a cURL command.
class Curl extends Equatable {
  /// Specifies the HTTP request method (e.g., GET, POST, PUT, DELETE).
  final String method;

  /// Specifies the HTTP request URL.
  final Uri uri;

  /// Adds custom HTTP headers to the request.
  final Map<String, String>? headers;

  /// Sends data as the request body (typically used with POST requests).
  final String? data;

  /// Sends cookies with the request.
  final String? cookie;

  /// Specifies the username and password for HTTP basic authentication.
  final String? user;

  /// Sets the Referer header for the request.
  final String? referer;

  /// Sets the User-Agent header for the request.
  final String? userAgent;

  /// Sends data as a multipart/form-data request.
  final bool form;

  /// Form data list.
  /// Currently, it is represented as a list of key-value pairs ([key, value]).
  final List<List<String>>? formData;

  /// Allows insecure SSL connections.
  final bool insecure;

  /// Follows HTTP redirects.
  final bool location;

  /// Constructs a new Curl object with the specified parameters.
  ///
  /// The `uri` parameter is required, while the remaining parameters are optional.
  Curl({
    required this.uri,
    this.method = 'GET',
    this.headers,
    this.data,
    this.cookie,
    this.user,
    this.referer,
    this.userAgent,
    this.formData,
    this.form = false,
    this.insecure = false,
    this.location = false,
  });

  /// Parses [curlString] into a [Curl] class instance.
  ///
  /// Like [parse] except that this function returns `null` where a
  /// similar call to [parse] would throw a throwable.
  ///
  /// Example:
  /// ```dart
  /// print(Curl.tryParse('curl -X GET https://www.example.com/')); // Curl(method: 'GET', url: 'https://www.example.com/')
  /// print(Curl.tryParse('1f')); // null
  /// ```
  static Curl? tryParse(String curlString) {
    try {
      return Curl.parse(curlString);
    } catch (_) {
      return null;
    }
  }

  /// Parse [curlString] as a [Curl] class instance.
  ///
  /// Example:
  /// ```dart
  /// print(Curl.parse('curl -X GET https://www.example.com/')); // Curl(method: 'GET', url: 'https://www.example.com/')
  /// print(Curl.parse('1f')); // [Exception] is thrown
  /// ```
  static Curl parse(String curlString) {
    String? clean(String? url) {
      return url?.replaceAll('"', '').replaceAll("'", '');
    }

    final parser = ArgParser(allowTrailingOptions: true);

    // TODO: Add more options
    // https://gist.github.com/eneko/dc2d8edd9a4b25c5b0725dd123f98b10
    // Define the expected options
    parser.addOption('url');
    parser.addOption('request', abbr: 'X');
    parser.addMultiOption('header', abbr: 'H', splitCommas: false);
    parser.addOption('data', abbr: 'd');
    parser.addOption('cookie', abbr: 'b');
    parser.addOption('user', abbr: 'u');
    parser.addOption('referer', abbr: 'e');
    parser.addOption('user-agent', abbr: 'A');
    parser.addFlag('head', abbr: 'I');
    parser.addMultiOption('form', abbr: 'F');
    parser.addFlag('insecure', abbr: 'k');
    parser.addFlag('location', abbr: 'L');

    if (!curlString.startsWith('curl ')) {
      throw Exception("curlString doesn't start with 'curl '");
    }

    final splittedCurlString = splitAsCommandLineArgs(curlString.replaceFirst('curl ', ''));

    final result = parser.parse(splittedCurlString);

    final method = (result['request'] as String?)?.toUpperCase();

    // Extract the request headers
    Map<String, String>? headers;
    if (result['header'] != null) {
      final List<String> headersList = result['header'];
      if (headersList.isNotEmpty == true) {
        headers = <String, String>{};
        for (var headerString in headersList) {
          final splittedHeaderString = headerString.split(RegExp(r':\s*'));
          if (splittedHeaderString.length != 2) {
            throw Exception('Failed to split the `$headerString` header');
          }
          headers.addAll({splittedHeaderString[0]: splittedHeaderString[1]});
        }
      }
    }

    // Parse form data
    List<List<String>>? formData;
    if (result['form'] is List<String> && (result['form'] as List<String>).isNotEmpty) {
      formData = [];
      for (final formEntry in result['form']) {
        final pairs = formEntry.split('=');
        if (pairs.length != 2) {
          throw Exception('Form data is not in key=value format');
        }

        // File type form data
        if (pairs[1].startsWith('@')) {
          pairs[1] = pairs[1].substring(1);
        }

        formData.add([pairs[0], pairs[1]]);
      }
      headers ??= <String, String>{};
      headers['Content-Type'] = 'multipart/form-data';
    }

    // Handle URL and query parameters
    String? url = clean(result['url']) ?? (result.rest.isNotEmpty ? clean(result.rest.first) : null);
    if (url == null) {
      throw Exception('URL is null');
    }
    final uri = Uri.parse(url);

    return Curl(
      method: result['head'] == true ? "HEAD" : (method ?? 'GET'),
      uri: uri,
      headers: headers,
      data: result['data'],
      cookie: result['cookie'],
      user: result['user'],
      referer: result['referer'],
      userAgent: result['user-agent'],
      form: formData != null && formData.isNotEmpty,
      formData: formData,
      insecure: result['insecure'] ?? false,
      location: result['location'] ?? false,
    );
  }

  /// Converts the Curl object to a formatted cURL command string.
  String toCurlString() {
    var cmd = 'curl ';

    // Add the request method
    if (method != 'GET') {
      cmd += '-X $method ';
    }

    // Add the headers
    headers?.forEach((key, value) {
      cmd += '-H "$key: $value" ';
    });

    // Add the body
    if (data?.isNotEmpty == true) {
      cmd += '-d \'$data\' ';
    }
    // Add the cookie
    if (cookie?.isNotEmpty == true) {
      cmd += '-b \'$cookie\' ';
    }
    // Add the user
    if (user?.isNotEmpty == true) {
      cmd += '-u \'$user\' ';
    }
    // Add the referer
    if (referer?.isNotEmpty == true) {
      cmd += '-e \'$referer\' ';
    }
    // Add the user-agent
    if (userAgent?.isNotEmpty == true) {
      cmd += '-A \'$userAgent\' ';
    }
    // Add the form flag
    if (form) {
      for (final formEntry in formData!) {
        cmd += '-F ';
        cmd += '"${formEntry[0]}=${formEntry[1]}" ';
      }
    }
    // Add the insecure flag
    if (insecure) {
      cmd += '-k ';
    }
    // Add the location flag
    if (location) {
      cmd += '-L ';
    }

    // Add the URL
    cmd += '"${Uri.encodeFull(uri.toString())}"';

    return cmd.trim();
  }

  @override
  List<Object?> get props => [
        method,
        uri,
        headers,
        data,
        cookie,
        user,
        referer,
        userAgent,
        form,
        formData,
        insecure,
        location,
      ];
}
