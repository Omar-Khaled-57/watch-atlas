import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/models/recommendation_models.dart';

void main() {
  group('RecCategory', () {
    test('fromDb resolves known db values', () {
      expect(RecCategory.fromDb('because_you_saved'), RecCategory.becauseYouSaved);
      expect(RecCategory.fromDb('trending_near_you'), RecCategory.trendingNearYou);
      expect(RecCategory.fromDb('hidden_gems'), RecCategory.hiddenGems);
      expect(RecCategory.fromDb('upcoming_releases'), RecCategory.upcomingReleases);
    });

    test('dbValue and displayName are correct', () {
      expect(RecCategory.becauseYouSaved.dbValue, 'because_you_saved');
      expect(RecCategory.becauseYouSaved.displayName, 'Because You Saved...');
      expect(RecCategory.topRated.dbValue, 'top_rated');
      expect(RecCategory.topRated.displayName, 'Top Rated');
    });

    test('all 16 categories have unique dbValues', () {
      final values = RecCategory.values.map((c) => c.dbValue).toSet();
      expect(values.length, 16);
    });

    test('fromDb throws on unknown value', () {
      expect(() => RecCategory.fromDb('nonexistent'), throwsA(isA<StateError>()));
    });
  });

  group('EventType', () {
    test('recommendationFeedback is in the enum', () {
      expect(EventType.recommendationFeedback, isNotNull);
      expect(EventType.values, contains(EventType.recommendationFeedback));
    });

    test('all expected event types exist', () {
      expect(EventType.values.length, 19);
      expect(EventType.values, contains(EventType.mediaView));
      expect(EventType.values, contains(EventType.mediaSave));
      expect(EventType.values, contains(EventType.rating));
      expect(EventType.values, contains(EventType.recommendationClick));
      expect(EventType.values, contains(EventType.recommendationDismiss));
      expect(EventType.values, contains(EventType.recommendationFeedback));
    });
  });

  group('ScoredMedia', () {
    test('fromJson creates model correctly', () {
      final json = {
        'media_id': 42,
        'score': 8.5,
        'reason': 'Popular trending',
        'reason_type': 'collaborative',
        'category': 'trending_near_you',
        'is_dismissed': false,
      };

      final model = ScoredMedia.fromJson(json);

      expect(model.mediaId, 42);
      expect(model.score, 8.5);
      expect(model.reason, 'Popular trending');
      expect(model.reasonType, 'collaborative');
      expect(model.category, RecCategory.trendingNearYou);
      expect(model.isDismissed, false);
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'media_id': 1,
        'score': 5.0,
        'category': 'top_rated',
      };

      final model = ScoredMedia.fromJson(json);

      expect(model.reason, isNull);
      expect(model.reasonType, isNull);
      expect(model.isDismissed, false);
    });

    test('toJson produces correct map', () {
      const model = ScoredMedia(
        mediaId: 10,
        score: 7.5,
        reason: 'Because you enjoy Action',
        reasonType: 'content',
        category: RecCategory.becauseYouLikeGenre,
        isDismissed: true,
      );

      final json = model.toJson();

      expect(json['media_id'], 10);
      expect(json['score'], 7.5);
      expect(json['reason'], 'Because you enjoy Action');
      expect(json['reason_type'], 'content');
      expect(json['category'], 'because_you_like_genre');
      expect(json['is_dismissed'], true);
    });

    test('serialization roundtrip', () {
      const original = ScoredMedia(
        mediaId: 99,
        score: 9.1,
        reason: 'Similar to your favorites',
        reasonType: 'content',
        category: RecCategory.similarToFavorites,
        isDismissed: false,
      );

      final json = original.toJson();
      final decoded = ScoredMedia.fromJson(json);

      expect(decoded.mediaId, original.mediaId);
      expect(decoded.score, original.score);
      expect(decoded.reason, original.reason);
      expect(decoded.reasonType, original.reasonType);
      expect(decoded.category, original.category);
      expect(decoded.isDismissed, original.isDismissed);
    });

    test('constructor defaults', () {
      const model = ScoredMedia(mediaId: 1, score: 0.0, category: RecCategory.hiddenGems);

      expect(model.reason, isNull);
      expect(model.reasonType, isNull);
      expect(model.isDismissed, false);
    });
  });

  group('BehaviorEvent', () {
    test('toJson produces correct map with all fields', () {
      final event = BehaviorEvent(
        id: 'evt_1',
        userId: 'user_1',
        eventType: EventType.recommendationFeedback,
        mediaId: 42,
        metadata: {'is_positive': true, 'category': 'top_rated'},
        device: 'windows',
        platform: 'desktop',
        sessionId: 'sess_123',
        createdAt: DateTime(2026, 7, 13, 12, 0, 0),
      );

      final json = event.toJson();

      expect(json['id'], 'evt_1');
      expect(json['user_id'], 'user_1');
      expect(json['event_type'], 'recommendationFeedback');
      expect(json['media_id'], 42);
      expect(json['metadata'], {'is_positive': true, 'category': 'top_rated'});
      expect(json['device'], 'windows');
      expect(json['platform'], 'desktop');
      expect(json['session_id'], 'sess_123');
      expect(json['created_at'], '2026-07-13T12:00:00.000');
    });

    test('toJson omits null optional fields', () {
      const event = BehaviorEvent(
        userId: 'user_2',
        eventType: EventType.mediaView,
      );

      final json = event.toJson();

      expect(json.containsKey('id'), false);
      expect(json.containsKey('media_id'), false);
      expect(json.containsKey('device'), false);
      expect(json.containsKey('platform'), false);
      expect(json.containsKey('session_id'), false);
      expect(json.containsKey('created_at'), false);
      expect(json['user_id'], 'user_2');
      expect(json['event_type'], 'mediaView');
      expect(json['metadata'], {});
    });

    test('metadata defaults to empty map', () {
      const event = BehaviorEvent(
        userId: 'u',
        eventType: EventType.search,
      );

      expect(event.metadata, {});
    });
  });

  group('UserRecProfile', () {
    test('fromJson creates model correctly', () {
      final json = {
        'user_id': 'user_1',
        'genre_weights': {'Action': 0.8, 'Drama': 0.5},
        'actor_weights': {'Actor A': 0.9},
        'director_weights': {'Director B': 0.7},
        'keyword_weights': {'thriller': 0.6},
        'preferred_languages': ['en', 'ar'],
        'preferred_countries': ['US', 'JP'],
        'avg_session_duration': 120.5,
        'preferred_runtime': 'medium',
        'top_genres': ['Action', 'Drama'],
        'top_actors': ['Actor A'],
        'top_directors': ['Director B'],
        'diversity_seen_count': 15,
        'last_computed_at': '2026-07-13T10:00:00.000',
      };

      final profile = UserRecProfile.fromJson(json);

      expect(profile.userId, 'user_1');
      expect(profile.genreWeights, {'Action': 0.8, 'Drama': 0.5});
      expect(profile.actorWeights, {'Actor A': 0.9});
      expect(profile.directorWeights, {'Director B': 0.7});
      expect(profile.keywordWeights, {'thriller': 0.6});
      expect(profile.preferredLanguages, ['en', 'ar']);
      expect(profile.preferredCountries, ['US', 'JP']);
      expect(profile.avgSessionDuration, 120.5);
      expect(profile.preferredRuntime, 'medium');
      expect(profile.topGenres, ['Action', 'Drama']);
      expect(profile.topActors, ['Actor A']);
      expect(profile.topDirectors, ['Director B']);
      expect(profile.diversitySeenCount, 15);
      expect(profile.lastComputedAt, DateTime(2026, 7, 13, 10, 0, 0));
    });

    test('fromJson handles null/missing fields with defaults', () {
      final json = {
        'user_id': 'user_2',
      };

      final profile = UserRecProfile.fromJson(json);

      expect(profile.userId, 'user_2');
      expect(profile.genreWeights, {});
      expect(profile.actorWeights, {});
      expect(profile.directorWeights, {});
      expect(profile.keywordWeights, {});
      expect(profile.preferredLanguages, []);
      expect(profile.preferredCountries, []);
      expect(profile.avgSessionDuration, 0);
      expect(profile.preferredRuntime, 'any');
      expect(profile.topGenres, []);
      expect(profile.topActors, []);
      expect(profile.topDirectors, []);
      expect(profile.diversitySeenCount, 0);
      expect(profile.lastComputedAt, isNull);
    });

    test('constructor defaults', () {
      const profile = UserRecProfile(userId: 'u1');

      expect(profile.userId, 'u1');
      expect(profile.genreWeights, {});
      expect(profile.preferredRuntime, 'any');
      expect(profile.diversitySeenCount, 0);
    });
  });
}
