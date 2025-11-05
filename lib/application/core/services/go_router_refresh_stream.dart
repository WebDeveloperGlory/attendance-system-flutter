import 'dart:async';
import 'package:flutter/foundation.dart';

/// Helper class to refresh GoRouter when a stream emits
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (event) {
        print('🔔 Auth state changed: ${event.runtimeType}');
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}