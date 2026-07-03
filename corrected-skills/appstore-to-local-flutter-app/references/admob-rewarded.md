# AdMob Rewarded Ad Guide (Corrected)

Use this file when wiring the single rewarded ad placement.

## Required Behavior

- Keep exactly one rewarded ad placement in the app.
- Tie the trigger to the primary record/save action or the nearest equivalent monetizable checkpoint.
- On each cold-start session, show the rewarded ad on the first eligible trigger after the ad is loaded.
- After the first show, present again every third eligible trigger.
- If the ad is not ready in time, fails to load, times out, or the device is offline:
- If the ad is not ready in time, fails to load, or times out:
  - dismiss any loading UI
  - continue the core action
  - prepare the next eligible opportunity
- If the device is offline:
  - dismiss any loading UI
  - show a clear user-facing toast, alert, or prompt telling the user to enable network access
  - then continue the product's chosen fallback path

## Integration Shape

- Isolate ad loading, show rules, counters, and debug/release IDs in a dedicated ad service.
- Keep feature screens unaware of SDK details beyond a small interface.
- Reset session-scoped counters on cold start only.
- Avoid making feature screens `await` a loading dialog in a way that blocks the ad request itself.

## Debug and Release IDs

- Use Google sample App IDs and rewarded ad unit IDs in debug builds only.
- Keep release App IDs and unit IDs injectable through configuration.
- If release IDs are unavailable, disable ads cleanly in release builds.
- Do not ship Google test App IDs or test rewarded unit IDs in production configuration.

Current official sample values at the time this skill was authored:

- Android sample App ID: `ca-app-pub-3940256099942544~3347511713`
- iOS sample App ID: `ca-app-pub-3940256099942544~1458002511`
- Android rewarded sample ad unit: `ca-app-pub-3940256099942544/5224354917`
- iOS rewarded sample ad unit: `ca-app-pub-3940256099942544/1712485313`

Official references:

- Flutter quick start: `https://developers.google.com/admob/flutter/quick-start`
- Flutter test ads: `https://developers.google.com/admob/flutter/test-ads`
- Flutter rewarded ads: `https://developers.google.com/admob/flutter/rewarded`

## UX Notes

- Show the ad at a natural checkpoint, not during text entry.
- Avoid overly aggressive repeat ads.
- Keep dismissal, failure, timeout, and reward callbacks from breaking the core save flow.
- Treat offline as a first-class UX state rather than a generic failure case.
- Dispose ad objects cleanly.
- Do not block app launch or first paint on Mobile Ads initialization.
