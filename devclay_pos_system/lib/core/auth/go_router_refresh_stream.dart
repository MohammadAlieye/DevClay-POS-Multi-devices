import 'dart:async';

import 'package:flutter/foundation.dart';

/// Notifies [GoRouter] when any of [streams] or [listenables] changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(
    Iterable<Stream<dynamic>> streams, {
    Iterable<Listenable> listenables = const [],
  }) {
    notifyListeners();
    for (final stream in streams) {
      // Bloc.stream is already broadcast — do not wrap with asBroadcastStream().
      _subscriptions.add(stream.listen((_) => notifyListeners()));
    }
    for (final listenable in listenables) {
      listenable.addListener(notifyListeners);
      _listenables.add(listenable);
    }
  }

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final List<Listenable> _listenables = [];

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      unawaited(sub.cancel());
    }
    for (final listenable in _listenables) {
      listenable.removeListener(notifyListeners);
    }
    super.dispose();
  }
}
