import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'sign_in_with_apple/sign_in_with_apple.dart';
import 'supabase_service.dart';
import '../../models/user_model.dart';

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  User? get currentUser => SupabaseService.instance.client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  String get userId => currentUser?.id ?? '';

  Stream<AuthState> get authStateChanges =>
      SupabaseService.instance.client.auth.onAuthStateChange;

  Future<void> signUp(String email, String password) async {
    await SupabaseService.instance.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signIn(String email, String password) async {
    await SupabaseService.instance.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      await SupabaseService.instance.auth.signInWithOAuth(OAuthProvider.google);
    } else {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      await SupabaseService.instance.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );
    }
  }

  Future<void> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    await SupabaseService.instance.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: credential.identityToken!,
    );
  }

  Future<void> signOut() async {
    await SupabaseService.instance.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await SupabaseService.instance.auth.resetPasswordForEmail(email);
  }

  Future<UserModel?> getProfile() async {
    final response = await SupabaseService.instance.profiles
        .select()
        .eq('id', userId)
        .single();
    return UserModel.fromJson(response);
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    await SupabaseService.instance.profiles
        .update(updates)
        .eq('id', userId);
  }

  Future<void> deleteAccount() async {
    await SupabaseService.instance.auth.admin.deleteUser(userId);
  }
}
