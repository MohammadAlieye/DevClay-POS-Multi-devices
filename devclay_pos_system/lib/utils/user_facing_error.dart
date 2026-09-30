/// Converts technical Dart exception text into a message suitable for the UI.
String userFacingError(Object error) {
  var message = error.toString().trim();
  const prefixes = <String>[
    'Invalid argument(s):',
    'Bad state:',
    'ArgumentError:',
    'StateError:',
    'Exception:',
  ];
  for (final prefix in prefixes) {
    if (message.startsWith(prefix)) {
      message = message.substring(prefix.length).trim();
      break;
    }
  }
  return message.isEmpty ? 'Something went wrong. Please try again.' : message;
}
