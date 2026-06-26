class RewardedRecordPolicy {
  bool _hasShownRewardedAdThisSession = false;
  int _recordsSinceLastRewardedAd = 0;

  bool get shouldShowAdBeforeNextRecord {
    if (!_hasShownRewardedAdThisSession) {
      return true;
    }
    return _recordsSinceLastRewardedAd >= 3;
  }

  void markRecordSavedWithoutAd() {
    _recordsSinceLastRewardedAd += 1;
  }

  void markRecordSavedAfterReward() {
    _hasShownRewardedAdThisSession = true;
    _recordsSinceLastRewardedAd = 0;
  }
}
