import 'package:bill/core/ads/rewarded_record_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('requires rewarded ad on first, fourth, and seventh record saves', () {
    final policy = RewardedRecordPolicy();

    expect(policy.shouldShowAdBeforeNextRecord, isTrue);

    policy.markRecordSavedAfterReward();
    expect(policy.shouldShowAdBeforeNextRecord, isFalse);

    policy.markRecordSavedWithoutAd();
    expect(policy.shouldShowAdBeforeNextRecord, isFalse);

    policy.markRecordSavedWithoutAd();
    expect(policy.shouldShowAdBeforeNextRecord, isFalse);

    policy.markRecordSavedWithoutAd();
    expect(policy.shouldShowAdBeforeNextRecord, isTrue);

    policy.markRecordSavedAfterReward();
    expect(policy.shouldShowAdBeforeNextRecord, isFalse);
  });

  test('keeps requiring the first rewarded ad until one is completed', () {
    final policy = RewardedRecordPolicy();

    expect(policy.shouldShowAdBeforeNextRecord, isTrue);

    policy.markRecordSavedWithoutAd();
    expect(policy.shouldShowAdBeforeNextRecord, isTrue);

    policy.markRecordSavedWithoutAd();
    expect(policy.shouldShowAdBeforeNextRecord, isTrue);

    policy.markRecordSavedAfterReward();
    expect(policy.shouldShowAdBeforeNextRecord, isFalse);
  });

  test(
    'keeps retrying after the third post-reward save until an ad is shown',
    () {
      final policy = RewardedRecordPolicy()..markRecordSavedAfterReward();

      policy.markRecordSavedWithoutAd();
      policy.markRecordSavedWithoutAd();
      policy.markRecordSavedWithoutAd();
      expect(policy.shouldShowAdBeforeNextRecord, isTrue);

      policy.markRecordSavedWithoutAd();
      expect(policy.shouldShowAdBeforeNextRecord, isTrue);
    },
  );
}
