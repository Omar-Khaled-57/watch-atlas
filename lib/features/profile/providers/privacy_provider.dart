import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySettings {
  final bool publicProfile;
  final bool showActivity;

  const PrivacySettings({this.publicProfile = true, this.showActivity = true});

  PrivacySettings copyWith({bool? publicProfile, bool? showActivity}) {
    return PrivacySettings(
      publicProfile: publicProfile ?? this.publicProfile,
      showActivity: showActivity ?? this.showActivity,
    );
  }
}

class PrivacySettingsNotifier extends Notifier<PrivacySettings> {
  @override
  PrivacySettings build() {
    _load();
    return const PrivacySettings();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = PrivacySettings(
        publicProfile: prefs.getBool('privacy_public_profile') ?? true,
        showActivity: prefs.getBool('privacy_show_activity') ?? true,
      );
    } catch (e) {
      // Keep defaults
    }
  }

  Future<void> setPublicProfile(bool value) async {
    state = state.copyWith(publicProfile: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('privacy_public_profile', value);
  }

  Future<void> setShowActivity(bool value) async {
    state = state.copyWith(showActivity: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('privacy_show_activity', value);
  }
}

final privacySettingsProvider =
    NotifierProvider<PrivacySettingsNotifier, PrivacySettings>(
      PrivacySettingsNotifier.new,
    );
