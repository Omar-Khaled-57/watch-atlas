import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Monitors network connectivity and broadcasts online/offline state changes.
///
/// Wraps [connectivity_plus] and exposes a [Stream<bool>] that emits `true`
/// when the device comes online and `false` when it goes offline. Use
/// [isOnline] for synchronous checks and [onConnectivityChanged] for stream
/// listeners.
///
/// Call [init] once at app startup; call [dispose] on shutdown.
///
/// Use [instance] for quick access; inject a configured instance for tests.
class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService();

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get onConnectivityChanged => _controller.stream;
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  void init() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online != _isOnline) {
        _isOnline = online;
        _controller.add(online);
      }
    });
  }

  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = results.any((r) => r != ConnectivityResult.none);
    return _isOnline;
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
