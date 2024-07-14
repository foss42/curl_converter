import 'package:shlex/shlex.dart' as shlex;

// List<String> splitAsCommandLineArgs(String input) {
//   final splittedCurlCommand = <String>[];
//   var bufferText = '';
//   var insideQuotes = false;
//   String? quotechar;

//   for (var i = 0; i < input.length; ++i) {
//     if (input[i] == ' ' && !insideQuotes) {
//       if (bufferText.trim().isNotEmpty) {
//         splittedCurlCommand.add(bufferText.replaceAll(r'\"', '"').replaceAll(r"\'", "'"));
//       }
//       bufferText = '';
//       continue;
//     }

//     // Do not count the quotes that has the `\` before them
//     if ((input[i] == '"' || input[i] == "'") && (i == 0 || input[i - 1] != r'\')) {
//       var rep = input[i] == '"' ? r'\"' : r"\'";
//       if (quotechar == null || input[i] == quotechar) {
//         insideQuotes = !insideQuotes;
//         quotechar = insideQuotes ? input[i] : null;
//       }
//       if (!insideQuotes) {
//         splittedCurlCommand.add(bufferText); //.replaceAll(rep, input[i]));
//         bufferText = '';
//       }
//       print("rep $rep bufferText $splittedCurlCommand");
//       continue;
//     }

//     bufferText += input[i];
//     // Just add the buffer on last char
//     if (i == input.length - 1) {
//       splittedCurlCommand.add(bufferText.replaceAll(r'\"', '"').replaceAll(r"\'", "'"));
//       bufferText = '';
//       break;
//     }
//   }

//   return splittedCurlCommand;
// }

List<String> splitAsCommandLineArgs(String command) {
  return shlex.split(command);
}
