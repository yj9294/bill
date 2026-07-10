import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_ids.dart';
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

  static const _rewardedAdLoadTimeout = Duration(seconds: 8);

  final Connectivity _connectivity;
  final RewardedRecordPolicy _policy;

  Future<void>? _initializationFuture;
  RewardedAd? _cachedRewardedAd;
  Future<RewardedAdLoadOutcome>? _preloadFuture;

  bool get adsEnabled => _rewardedAdUnitId != null;

  bool get shouldShowAdBeforeNextRecord {
    return adsEnabled && _policy.shouldShowAdBeforeNextRecord;
  }

  Future<void> initialize() {
    if (!adsEnabled) {
      return Future.value();
    }
    final existingInitialization = _initializationFuture;
    if (existingInitialization != null) {
      return existingInitialization;
    }

    _initializationFuture = _initializeInternal().then<void>((_) {
      unawaited(preloadRewardedAd());
    });
    return _initializationFuture!;
  }

  Future<RewardedAdLoadOutcome> loadRewardedAdForRecord() async {
    final rewardedAdUnitId = _rewardedAdUnitId;
    if (rewardedAdUnitId == null) {
      return const RewardedAdLoadOutcome.disabled();
    }

    await initialize();
    final cachedRewardedAd = _cachedRewardedAd;
    if (cachedRewardedAd != null) {
      _cachedRewardedAd = null;
      return RewardedAdLoadOutcome.loaded(cachedRewardedAd);
    }

    final preloadingRewardedAd = _preloadFuture;
    if (preloadingRewardedAd != null) {
      final preloadedOutcome = await preloadingRewardedAd;
      final preloadedAd = _cachedRewardedAd;
      if (preloadedOutcome.status == RewardedAdLoadStatus.loaded &&
          preloadedAd != null) {
        _cachedRewardedAd = null;
        return RewardedAdLoadOutcome.loaded(preloadedAd);
      }
    }

    final connectivityResults = await _connectivity.checkConnectivity();
    if (connectivityResults.isEmpty ||
        connectivityResults.every(
          (result) => result == ConnectivityResult.none,
        )) {
      return const RewardedAdLoadOutcome.noNetwork();
    }

    return _startRewardedAdLoad(rewardedAdUnitId);
  }

  Future<bool> showRewardedAd(RewardedAd ad) async {
    final completer = Completer<bool>();
    var rewardEarned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdDismissedFullScreenContent: (rewardedAd) {
        rewardedAd.dispose();
        unawaited(preloadRewardedAd());
        if (!completer.isCompleted) {
          completer.complete(rewardEarned);
        }
      },
      onAdFailedToShowFullScreenContent: (rewardedAd, _) {
        rewardedAd.dispose();
        unawaited(preloadRewardedAd());
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

  Future<RewardedAdLoadOutcome> preloadRewardedAd() async {
    final rewardedAdUnitId = _rewardedAdUnitId;
    if (rewardedAdUnitId == null || _cachedRewardedAd != null) {
      return const RewardedAdLoadOutcome.disabled();
    }
    return _preloadFuture ??= _preloadRewardedAdInternal(rewardedAdUnitId);
  }

  Future<RewardedAdLoadOutcome> _preloadRewardedAdInternal(
    String rewardedAdUnitId,
  ) async {
    try {
      final outcome = await _startRewardedAdLoad(rewardedAdUnitId);
      if (outcome.status == RewardedAdLoadStatus.loaded) {
        _cachedRewardedAd = outcome.ad;
      }
      return outcome;
    } finally {
      _preloadFuture = null;
    }
  }

  Future<RewardedAdLoadOutcome> _startRewardedAdLoad(
    String rewardedAdUnitId,
  ) async {
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
    return completer.future.timeout(
      _rewardedAdLoadTimeout,
      onTimeout: () => const RewardedAdLoadOutcome.failed(),
    );
  }

  String? get _rewardedAdUnitId {
    return AdMobIds.currentRewardedAdUnitId;
  }
}
