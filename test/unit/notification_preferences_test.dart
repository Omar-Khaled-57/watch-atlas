import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/features/notifications/providers/notification_preferences_provider.dart';

void main() {
  group('NotificationPreferences', () {
    test('fromJson creates model with all fields', () {
      final json = {
        'new_followers': false,
        'activity_updates': true,
        'recommendations': false,
        'list_updates': true,
        'weekly_digest': false,
        'marketing_emails': true,
      };

      final prefs = NotificationPreferences.fromJson(json);

      expect(prefs.newFollowers, false);
      expect(prefs.activityUpdates, true);
      expect(prefs.recommendations, false);
      expect(prefs.listUpdates, true);
      expect(prefs.weeklyDigest, false);
      expect(prefs.marketingEmails, true);
    });

    test('fromJson uses defaults for missing fields', () {
      final prefs = NotificationPreferences.fromJson({});

      expect(prefs.newFollowers, true);
      expect(prefs.activityUpdates, true);
      expect(prefs.recommendations, true);
      expect(prefs.listUpdates, true);
      expect(prefs.weeklyDigest, true);
      expect(prefs.marketingEmails, false);
    });

    test('constructor defaults', () {
      final prefs = NotificationPreferences();

      expect(prefs.newFollowers, true);
      expect(prefs.activityUpdates, true);
      expect(prefs.recommendations, true);
      expect(prefs.listUpdates, true);
      expect(prefs.weeklyDigest, true);
      expect(prefs.marketingEmails, false);
    });

    test('toJson produces correct map', () {
      final prefs = NotificationPreferences(
        newFollowers: false,
        activityUpdates: false,
        recommendations: false,
        listUpdates: false,
        weeklyDigest: false,
        marketingEmails: true,
      );

      final json = prefs.toJson();

      expect(json['new_followers'], false);
      expect(json['activity_updates'], false);
      expect(json['recommendations'], false);
      expect(json['list_updates'], false);
      expect(json['weekly_digest'], false);
      expect(json['marketing_emails'], true);
    });

    test('serialization roundtrip', () {
      final original = NotificationPreferences(
        newFollowers: false,
        activityUpdates: true,
        recommendations: false,
        listUpdates: true,
        weeklyDigest: false,
        marketingEmails: true,
      );

      final json = original.toJson();
      final decoded = NotificationPreferences.fromJson(json);

      expect(decoded.newFollowers, original.newFollowers);
      expect(decoded.activityUpdates, original.activityUpdates);
      expect(decoded.recommendations, original.recommendations);
      expect(decoded.listUpdates, original.listUpdates);
      expect(decoded.weeklyDigest, original.weeklyDigest);
      expect(decoded.marketingEmails, original.marketingEmails);
    });

    test('fromJson ignores extra keys', () {
      final json = {
        'new_followers': true,
        'extra_key': 'should be ignored',
        'another_extra': 42,
      };

      final prefs = NotificationPreferences.fromJson(json);

      expect(prefs.newFollowers, true);
    });

    test('fromJson handles null values in map as defaults', () {
      final json = {
        'new_followers': null,
        'activity_updates': null,
        'marketing_emails': null,
      };

      final prefs = NotificationPreferences.fromJson(json);

      expect(prefs.newFollowers, true);
      expect(prefs.activityUpdates, true);
      expect(prefs.marketingEmails, false);
    });
  });
}
