import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/models/media_enums.dart';
import 'package:watch_atlas/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson creates model correctly', () {
      final json = {
        'id': 'user_1',
        'email': 'test@example.com',
        'username': 'testuser',
        'displayName': 'Test User',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'bio': 'A test user',
        'role': 'user',
        'isVerified': true,
        'followersCount': 10,
        'followingCount': 5,
        'listsCount': 3,
        'reviewsCount': 2,
      };

      final model = UserModel.fromJson(json);

      expect(model.id, 'user_1');
      expect(model.email, 'test@example.com');
      expect(model.username, 'testuser');
      expect(model.displayName, 'Test User');
      expect(model.role, UserRole.user);
      expect(model.isVerified, true);
      expect(model.followersCount, 10);
    });

    test('default role is user', () {
      final json = {
        'id': 'user_2',
        'email': 'test2@example.com',
        'username': 'user2',
      };

      final model = UserModel.fromJson(json);

      expect(model.role, UserRole.user);
      expect(model.isVerified, false);
      expect(model.followersCount, 0);
    });

    test('toJson produces correct map', () {
      final model = UserModel(
        id: 'u1',
        email: 'a@b.com',
        username: 'user',
      );

      final json = model.toJson();

      expect(json['id'], 'u1');
      expect(json['email'], 'a@b.com');
      expect(json['username'], 'user');
    });

    test('serialization roundtrip', () {
      final original = UserModel(
        id: 'u42',
        email: 'test@test.com',
        username: 'testuser42',
        displayName: 'Test User 42',
        bio: 'Hello world',
        role: UserRole.moderator,
        isVerified: true,
        followersCount: 100,
        followingCount: 50,
      );

      final json = original.toJson();
      final decoded = UserModel.fromJson(json);

      expect(decoded.id, original.id);
      expect(decoded.email, original.email);
      expect(decoded.username, original.username);
      expect(decoded.displayName, original.displayName);
      expect(decoded.role, UserRole.moderator);
      expect(decoded.isVerified, true);
    });
  });
}
