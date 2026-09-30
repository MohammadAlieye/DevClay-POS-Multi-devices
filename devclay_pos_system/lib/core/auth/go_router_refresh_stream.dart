import 'dart:async';

import 'package:flutter/foundation.dart';

/// Notifies [GoRouter] when any of [streams] emits.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Iterable<Stream<dynamic>> streams) {
    notifyListeners();
    for (final stream in streams) {
      // Bloc.stream is already broadcast — do not wrap with asBroadcastStream().
      _subscriptions.add(stream.listen((_) => notifyListeners()));
    }
  }

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      unawaited(sub.cancel());
    }
    super.dispose();
  }
}
