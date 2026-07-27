import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/config/recommendation_config.dart';

void main() {
  group('RecommendationConfig weights', () {
    test('hybrid weights sum to 1.0', () {
      final sum =
          RecommendationConfig.behaviorWeight +
          RecommendationConfig.contentWeight +
          RecommendationConfig.collaborativeWeight +
          RecommendationConfig.demographicWeight;
      expect(sum, closeTo(1.0, 0.001));
    });

    test('content sub-weights sum to 1.0', () {
      final sum =
          RecommendationConfig.contentGenreWeight +
          RecommendationConfig.contentRatingWeight;
      expect(sum, closeTo(1.0, 0.001));
    });

    test('tier ratios sum to 1.0', () {
      final sum =
          RecommendationConfig.topTierRatio +
          RecommendationConfig.midTierRatio +
          RecommendationConfig.lowTierRatio;
      expect(sum, closeTo(1.0, 0.001));
    });

    test('behavior weight is highest', () {
      expect(
        RecommendationConfig.behaviorWeight,
        greaterThan(RecommendationConfig.contentWeight),
      );
      expect(
        RecommendationConfig.behaviorWeight,
        greaterThan(RecommendationConfig.collaborativeWeight),
      );
      expect(
        RecommendationConfig.behaviorWeight,
        greaterThan(RecommendationConfig.demographicWeight),
      );
    });
  });

  group('RecommendationConfig limits', () {
    test('maxItemsPerCategory is positive', () {
      expect(RecommendationConfig.maxItemsPerCategory, greaterThan(0));
    });

    test('dbFetchLimit >= maxItemsPerCategory', () {
      expect(
        RecommendationConfig.dbFetchLimit,
        greaterThanOrEqualTo(RecommendationConfig.maxItemsPerCategory),
      );
    });

    test('cacheTtlHours is reasonable', () {
      expect(RecommendationConfig.cacheTtlHours, greaterThanOrEqualTo(1));
      expect(RecommendationConfig.cacheTtlHours, lessThanOrEqualTo(168));
    });

    test('freshnessDecayDays is positive', () {
      expect(RecommendationConfig.freshnessDecayDays, greaterThan(0));
    });

    test('diversityTarget is between 0 and 1', () {
      expect(RecommendationConfig.diversityTarget, greaterThanOrEqualTo(0));
      expect(RecommendationConfig.diversityTarget, lessThanOrEqualTo(1));
    });

    test('maxPerFranchise is at least 1', () {
      expect(RecommendationConfig.maxPerFranchise, greaterThanOrEqualTo(1));
    });

    test('topRatedMinVoteAverage is between 0 and 10', () {
      expect(
        RecommendationConfig.topRatedMinVoteAverage,
        greaterThanOrEqualTo(0),
      );
      expect(
        RecommendationConfig.topRatedMinVoteAverage,
        lessThanOrEqualTo(10),
      );
    });
  });
}
