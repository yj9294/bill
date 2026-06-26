import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'rewarded_record_policy.dart';

enum RewardedAdLoadStatus { loaded, disabled, noNetwork, failed }

class RewardedAdLoadOutcome {
  const RewardedAdLoadOutcome._(this.status, [this.ad]);

  const RewardedAdLoadOutcome.loaded(RewardedAd ad)
    : this._(RewardedAdLoadStatus.loaded, ad);

  const RewardedAdLoadOutcome.disabled()
    : this._(RewardedAdLoadStatus.disabled);

  const RewardedAdLoadOutcome.noNetwork()
    : this._(RewardedAdLoadStatus.noNetwork);

  const RewardedAdLoadOutcome.failed() : this._(RewardedAdLoadStatus.failed);

  final RewardedAdLoadStatus status;
  final RewardedAd? ad;
}

class RewardedRecordAdGate {
  RewardedRecordAdGate({
    Connectivity? connectivity,
    RewardedRecordPolicy? policy,
  }) : _connectivity = connectivity ?? Connectivity(),
       _policy = policy ?? RewardedRecordPolicy();

  static const _androidRewardedTestId =
      'ca-app-pub-3940256099942544/5224354917';
  static const _iosRewardedTestId = 'ca-app-pub-3940256099942544/1712485313';

  final Connectivity _connectivity;
  final RewardedRecordPolicy _policy;

  Future<InitializationStatus>? _initializationFuture;

  bool get shouldShowAdBeforeNextRecord {
    return _rewardedAdUnitId != null && _policy.shouldShowAdBeforeNextRecord;
  }

  Future<void> initialize() {
    return _initializationFuture ??= _initializeInternal();
  }

  Future<RewardedAdLoadOutcome> loadRewardedAdForRecord() async {
    final rewardedAdUnitId = _rewardedAdUnitId;
    if (rewardedAdUnitId == null) {
      return const RewardedAdLoadOutcome.disabled();
    }

    await initialize();

    final connectivityResults = await _connectivity.checkConnectivity();
    if (connectivityResults.isEmpty ||
        connectivityResults.every(
          (result) => result == ConnectivityResult.none,
        )) {
      return const RewardedAdLoadOutcome.noNetwork();
    }

    final completer = Completer<RewardedAdLoadOutcome>();
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) =>
            completer.complete(RewardedAdLoadOutcome.loaded(ad)),
        onAdFailedToLoad: (_) {
          if (!completer.isCompleted) {
            completer.complete(const RewardedAdLoadOutcome.failed());
          }
        },
      ),
    );
    return completer.future;
  }

  Future<bool> showRewardedAd(RewardedAd ad) async {
    final completer = Completer<bool>();
    var rewardEarned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdDismissedFullScreenContent: (rewardedAd) {
        rewardedAd.dispose();
        if (!completer.isCompleted) {
          completer.complete(rewardEarned);
        }
      },
      onAdFailedToShowFullScreenContent: (rewardedAd, _) {
        rewardedAd.dispose();
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
    );

    await ad.setImmersiveMode(true);
    await ad.show(
      onUserEarnedReward: (earnedAd, reward) {
        debugPrint(
          'Reward earned from $earnedAd: ${reward.amount} ${reward.type}',
        );
        rewardEarned = true;
      },
    );
    return completer.future;
  }

  void markRecordSavedWithoutAd() {
    _policy.markRecordSavedWithoutAd();
  }

  void markRecordSavedAfterReward() {
    _policy.markRecordSavedAfterReward();
  }

  Future<InitializationStatus> _initializeInternal() async {
    await _connectivity.checkConnectivity();
    return MobileAds.instance.initialize();
  }

  String? get _rewardedAdUnitId {
    if (!kDebugMode) {
      return null;
    }

    if (Platform.isAndroid) {
      return _androidRewardedTestId;
    }
    if (Platform.isIOS) {
      return _iosRewardedTestId;
    }
    return null;
  }
}
