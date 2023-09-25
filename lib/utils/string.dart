List<String> splitAsCommandLineArgs(String input) {
  final splittedCurlCommand = <String>[];
  var bufferText = '';
  var insideQuotes = false;

  for (var i = 0; i < input.length; ++i) {
    if (input[i] == ' ' && !insideQuotes) {
      splittedCurlCommand.add(bufferText.replaceAll(r'\"', '"'));
      bufferText = '';
      continue;
    }

    // Do not count the quotes that has the `\` before them
    if (input[i] == '"' && (i == 0 || input[i - 1] != r'\')) {
      insideQuotes = !insideQuotes;
      continue;
    }

    bufferText += input[i];
    // Just add the buffer on last char
    if (i == input.length - 1) {
      splittedCurlCommand.add(bufferText.replaceAll(r'\"', '"'));
      break;
    }
  }

  return splittedCurlCommand;
}
