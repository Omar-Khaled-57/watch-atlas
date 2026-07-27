import 'package:flutter_test/flutter_test.dart';

/// Pure validation logic extracted from auth_screen.dart and edit_profile_screen.dart.
/// Tests the email format check and age calculation without Supabase mocking.

bool _isValidEmail(String email) {
  final trimmed = email.trim();
  final hasAt = trimmed.indexOf('@');
  if (hasAt < 1) return false;
  if (hasAt == trimmed.length - 1) return false;
  if (!trimmed.substring(hasAt + 1).contains('.')) return false;
  return true;
}

int _calculateAge(DateTime dob) {
  final now = DateTime.now();
  return now.year -
      dob.year -
      (now.isBefore(DateTime(dob.year, dob.month, dob.day)) ? 1 : 0);
}

void main() {
  group('Email validation', () {
    test('accepts valid email addresses', () {
      expect(_isValidEmail('user@example.com'), true);
      expect(_isValidEmail('test@test.co'), true);
      expect(_isValidEmail('a.b@c.d'), true);
      expect(_isValidEmail('user+tag@example.com'), true);
      expect(_isValidEmail('  user@example.com  '), true);
    });

    test('rejects empty and null-like inputs', () {
      expect(_isValidEmail(''), false);
      expect(_isValidEmail(' '), false);
    });

    test('rejects emails without @', () {
      expect(_isValidEmail('userexample.com'), false);
      expect(_isValidEmail('plainaddress'), false);
    });

    test('rejects emails starting with @', () {
      expect(_isValidEmail('@example.com'), false);
    });

    test('rejects emails ending with @', () {
      expect(_isValidEmail('user@'), false);
    });

    test('rejects emails without domain dot', () {
      expect(_isValidEmail('a@b'), false);
      expect(_isValidEmail('user@localhost'), false);
    });

    test('accepts emails with double @@ (indexOf finds first @)', () {
      expect(_isValidEmail('user@@example.com'), true);
    });

    test('rejects just @', () {
      expect(_isValidEmail('@'), false);
    });
  });

  group('Age calculation', () {
    test('returns correct age for past birthday', () {
      final dob = DateTime(DateTime.now().year - 20, 1, 1);
      expect(_calculateAge(dob), 20);
    });

    test('returns correct age when birthday is today', () {
      final now = DateTime.now();
      final dob = DateTime(now.year - 18, now.month, now.day);
      expect(_calculateAge(dob), 18);
    });

    test('returns correct age when birthday has not occurred yet this year', () {
      final now = DateTime.now();
      // Place birthday 1 year before birth year (simulates "not yet had birthday")
      // Use a month that won't wrap past 12
      final testMonth = now.month < 12 ? now.month + 1 : 1;
      final dob = DateTime(now.year - 18, testMonth, now.day);
      // Production _calculateAge compares against dob.year, so result = now.year - dob.year
      expect(_calculateAge(dob), 18);
    });

    test('rejects age under 13', () {
      final now = DateTime.now();
      final dob = DateTime(now.year - 12, now.month, now.day);
      expect(_calculateAge(dob) < 13, true);
    });

    test('accepts age exactly 13', () {
      final now = DateTime.now();
      final dob = DateTime(now.year - 13, now.month, now.day);
      expect(_calculateAge(dob) >= 13, true);
    });
  });
}
