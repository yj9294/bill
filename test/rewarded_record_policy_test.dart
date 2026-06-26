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
}
