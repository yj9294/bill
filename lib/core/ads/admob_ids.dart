import 'dart:io';

abstract final class AdMobIds {
  static const appId = 'ca-app-pub-5623454490626452~1662501803';
  static const rewardedAdUnitId = 'ca-app-pub-5623454490626452/7457332503';

  static String? get currentRewardedAdUnitId {
    if (Platform.isAndroid || Platform.isIOS) {
      return rewardedAdUnitId;
    }
    return null;
  }
}
