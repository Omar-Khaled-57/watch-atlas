import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import '../../models/user_model.dart';

/// Manages user authentication via Supabase Auth.
///
/// Supports Google OAuth, email/password sign-in, and guest (anonymous) mode.
/// Handles OAuth redirect via a local HTTP server on desktop platforms.
///
/// Exposes [currentUser], [userId], and [isAuthenticated] for quick checks.
/// Call [init] once at app startup to restore the previous session.
///
/// Use [instance] for quick access; inject a configured instance for tests.
class AuthService {
  static final AuthService instance = AuthService();

  AuthService({SupabaseService? supabase})
    : _supabase = supabase ?? SupabaseService.instance;

  final SupabaseService _supabase;

  static const _googleAccountsKey = 'google_accounts';

  Future<List<String>> getSavedGoogleAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_googleAccountsKey) ?? [];
  }

  Future<void> _saveGoogleAccount(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = prefs.getStringList(_googleAccountsKey) ?? [];
    final updated = [email, ...accounts.where((a) => a != email)];
    await prefs.setStringList(_googleAccountsKey, updated.take(5).toList());
  }

  User? get currentUser {
    try {
      return _supabase.client.auth.currentUser;
    } catch (e) {
      debugPrint('AuthService.currentUser: $e');
      return null;
    }
  }

  bool get isAuthenticated => currentUser != null;
  String get userId => currentUser?.id ?? '';

  Stream<AuthState> get authStateChanges {
    try {
      return _supabase.client.auth.onAuthStateChange;
    } catch (e) {
      debugPrint('AuthService.authStateChanges: $e');
      return const Stream.empty();
    }
  }

  Future<void> signUp(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    if (response.session == null) {
      throw Exception('accountCreated');
    }
    // If a session was returned, the user is auto-confirmed. Wait briefly for
    // the auth state to propagate.
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle({String? loginHint}) async {
    if (kIsWeb) {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        queryParams: {
          if (loginHint != null) 'login_hint': loginHint,
          'prompt': 'select_account',
        },
      );
      return;
    }
    await _signInWithOAuthDesktop(OAuthProvider.google, loginHint: loginHint);
  }

  Future<void> signInWithApple() async {
    if (kIsWeb) {
      await _supabase.auth.signInWithOAuth(OAuthProvider.apple);
      return;
    }
    await _signInWithOAuthDesktop(OAuthProvider.apple);
  }

  Future<void> _signInWithOAuthDesktop(
    OAuthProvider provider, {
    String? loginHint,
  }) async {
    // Bind to both IPv4 (127.0.0.1) and IPv6 (::1) since Windows can resolve
    // 'localhost' to either one. Use port 0 so the OS assigns an available port,
    // avoiding conflicts if a previous OAuth session didn't close cleanly.
    final servers = <HttpServer>[];
    for (final addr in [
      InternetAddress.loopbackIPv4,
      InternetAddress.loopbackIPv6,
    ]) {
      try {
        servers.add(await HttpServer.bind(addr, 0));
      } on SocketException {
        // address family not available on this system
      }
    }
    if (servers.isEmpty) {
      debugPrint('[OAuth] Failed to bind to any address');
      return;
    }
    // All servers bind to the same random port; use the first one.
    final port = servers.first.port;
    debugPrint(
      '[OAuth] Server listening on port $port (${servers.length} address(es))',
    );

    try {
      await _supabase.auth.signInWithOAuth(
        provider,
        redirectTo: 'http://localhost:$port',
        queryParams: {
          if (loginHint != null) 'login_hint': loginHint,
          'prompt': 'select_account',
        },
      );
      debugPrint('[OAuth] Browser opened, waiting for redirect...');

      // Race all servers for the first incoming request
      final completer = Completer<HttpRequest>();
      final subs = <StreamSubscription<HttpRequest>>[];
      for (final s in servers) {
        subs.add(
          s.listen(
            (req) {
              debugPrint('[OAuth] Received request: ${req.uri}');
              if (!completer.isCompleted) completer.complete(req);
            },
            onError: (e) {
              debugPrint('[OAuth] Server error: $e');
            },
          ),
        );
      }

      final request = await completer.future
          .timeout(const Duration(minutes: 5))
          .whenComplete(() {
            for (final sub in subs) {
              sub.cancel();
            }
          });

      debugPrint('[OAuth] URI query params: ${request.uri.queryParameters}');

      if (request.uri.queryParameters.containsKey('code')) {
        try {
          await _supabase.auth.getSessionFromUrl(request.uri);
          debugPrint('[OAuth] Session exchange succeeded');
          final user = currentUser;
          if (user?.email != null) {
            await _saveGoogleAccount(user!.email!);
          }
        } catch (e) {
          debugPrint('[OAuth] Session exchange failed: $e');
        }
      } else {
        debugPrint('[OAuth] No code parameter in redirect URI');
      }

      request.response.statusCode = 200;
      request.response.headers.contentType = ContentType.html;
      request.response.write('''
<html>
<head><title>Signed In</title></head>
<body style="display:flex;align-items:center;justify-content:center;height:100vh;margin:0;font-family:-apple-system,BlinkMacSystemFont,sans-serif;background:#121212;color:#e0e0e0">
  <div style="text-align:center;padding:40px;background:#1e1e1e;border-radius:12px;box-shadow:0 4px 24px rgba(0,0,0,0.4)">
    <div style="font-size:48px;margin-bottom:12px">✓</div>
    <h2 style="color:#4CAF50;margin:0 0 8px">Signed in successfully</h2>
    <p style="color:#999;margin:0">Return to the app.</p>
    <script>
      setTimeout(function() {
        window.open('','_self')?.close() || window.close();
      }, 800);
    </script>
  </div>
</body>
</html>''');
      await request.response.close();
      debugPrint('[OAuth] Response sent, server closing');
    } catch (e) {
      debugPrint('[OAuth] Error: $e');
    } finally {
      for (final s in servers) {
        await s.close();
      }
      debugPrint('[OAuth] Server closed');
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_googleAccountsKey);
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<UserModel?> getProfile() async {
    final uid = userId;
    if (uid.isEmpty) return null;
    try {
      final response = await _supabase.profiles.select().eq('id', uid).single();
      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('getProfile: initial fetch failed for $uid: $e');
      if (currentUser == null) return null;
      try {
        await _supabase.profiles.upsert({
          'id': uid,
          'email': currentUser!.email ?? '',
          'username': currentUser!.email?.split('@').first ?? 'user_$uid',
        });
        final retry = await _supabase.profiles.select().eq('id', uid).single();
        return UserModel.fromJson(retry);
      } catch (e2) {
        debugPrint('getProfile: fallback upsert+retry failed: $e2');
        return null;
      }
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final user = currentUser;
    final uid = userId;
    await _supabase.profiles.upsert({
      'id': uid,
      'email': user?.email ?? '',
      'username': user?.email?.split('@').first ?? 'user_$uid',
      ...updates,
    });
  }

  Map<String, dynamic>? getOAuthMetadata() {
    final user = currentUser;
    if (user == null || user.userMetadata == null) return null;
    return Map<String, dynamic>.from(user.userMetadata!);
  }

  Future<void> importOAuthProfile() async {
    final metadata = getOAuthMetadata();
    if (metadata == null) return;
    final updates = <String, dynamic>{};
    final avatarUrl =
        metadata['avatar_url'] as String? ?? metadata['picture'] as String?;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    final name =
        metadata['full_name'] as String? ?? metadata['name'] as String?;
    if (name != null && name.isNotEmpty) updates['display_name'] = name;
    final provider = metadata['provider'] as String?;
    if (provider == 'google') {
      final picture = metadata['picture'] as String?;
      if (picture != null) updates['avatar_url'] = picture;
    }
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      await updateProfile(updates);
    }
  }

  Future<void> assignDefaultAvatar() async {
    final uid = userId;
    if (uid.isEmpty) return;
    final index = DateTime.now().microsecondsSinceEpoch % 6 + 1;
    final path = index == 6
        ? 'assets/images/pfp/6.jpg'
        : 'assets/images/pfp/$index.jfif';
    await updateProfile({
      'default_avatar': path,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteAccount() async {
    try {
      await _supabase.client.rpc('delete_my_account');
    } catch (e) {
      debugPrint('AuthService: deleteAccount failed: $e');
      rethrow;
    }
  }
}
