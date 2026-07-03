---
name: appstore-to-local-flutter-app-corrected
description: "Analyze an App Store product page and turn it into a small local-only Flutter mobile app workflow: product teardown, requirements, 4-5 high-fidelity iPhone screens, a 1024x1024 app icon, a Flutter iOS+Android project with real local persistence, compliant in-app static pages, App Store metadata guidance, and an optional single AdMob rewarded ad flow."
---

# Appstore To Local Flutter App (Corrected)

## Overview

Use this skill to move from an App Store listing to practical deliverables for a small, differentiated, local-first mobile app:

1. A requirements document for a genuinely differentiated app with 4-5 screens.
2. A high-fidelity design board with 4-5 iPhone screens and a 1024x1024 app icon.
3. A Flutter project for iOS and Android with real local persistence.
4. Optional App Store support assets such as Privacy Policy, Terms of Use, Support copy, and metadata guidance.

Keep the app small, offline-first, useful, and review-safe. Prefer product closure and honest positioning over surface similarity to the source app.

## Guardrails

- Do not promise App Store review approval.
- Do not help the user evade review, mislead reviewers, or mass-produce near-identical apps.
- Do not clone the source app literally. Extract patterns, then build a smaller and distinct product.
- Keep claims aligned with the actual implementation.
- Use only assets and fonts with appropriate licenses.
- If the app touches finance, health, legal, or other sensitive areas, keep copy cautious and avoid professional claims.
- For metadata and support pages, follow current Apple requirements and keep URLs/contact details consistent with the actual app.

## Workflow

### 1. Analyze the source app

- Open the App Store URL in the browser or web tool.
- Collect only build-relevant inputs: category, target user, core loop, monetization clues, screenshot patterns, review complaints, and obvious gaps.
- Reduce the source app into a simpler local-only product with a clear offline data model and 4-5 screens.
- Write the requirements doc using [references/requirements-template.md](references/requirements-template.md).
- Save the doc under `work/appstore-to-local-flutter-app/<product-slug>/requirements.md` unless the user requests another path.
- Include a compliance/help cluster in Settings by default:
  - `Privacy Policy`
  - `Terms of Use`
  - `Support`
- Treat those as in-app static document pages unless the user explicitly wants external links only.

### 2. Produce the design

- If the user provides a Figma file or node, work there. Otherwise ask only if needed.
- Create one horizontal presentation frame containing:
  - 4-5 iPhone screens
  - 1 app icon composition sized for 1024x1024 export
- Use English UI copy unless the user requests another language.
- Keep the visual language polished, iOS-like, and distinct from the source app.
- Include the Settings screen when practical, with visible entry points for:
  - `Privacy Policy`
  - `Terms of Use`
  - `Support`
- For the icon:
  - Use a fully opaque background.
  - Keep the exported art square-cornered on the canvas.
  - Avoid transparency in the final PNG.
- Follow [references/figma-delivery.md](references/figma-delivery.md).

### 3. Build the Flutter project

- Normalize the output path. If the requested path is invalid, default to `/Users/app/<product-slug>`.
- Create the app for `ios,android` only.
- Choose a fitting architecture from [references/flutter-build.md](references/flutter-build.md).
- Decouple UI, state, and persistence.
- Use real local persistence and proper first-run empty states.
- Complete the main loop with meaningful create/read flows and the smallest sensible update/delete flows for the chosen product scope.
- Make major cards, summaries, and collections navigate somewhere real.
- Include an in-app Settings area with:
  - `Privacy Policy`
  - `Terms of Use`
  - `Support`
- If the user provides a support email or support URL, render it directly in the in-app Support page and reuse it in generated policy copy.
- If the user needs website-ready policy pages, generate standalone HTML pages that match the in-app copy when practical.

### 4. Handle App Store metadata

- When the user asks for ASO or App Store copy, keep all metadata aligned with current Apple field limits and actual product behavior.
- Keep the copy honest and feature-accurate.
- Prefer short, clear, non-spammy naming and keyword choices.
- If the app includes Privacy Policy and Support pages, provide matching web-page copy and suggested URLs when useful.

### 5. Add AdMob rewarded ads only when requested

- Add exactly one rewarded ad placement if ads are in scope.
- Use Google test App IDs and rewarded unit IDs only in debug builds.
- Keep release IDs configurable and injectable later.
- If release IDs are missing, disable ads cleanly in release builds.
- Default trigger behavior:
  - On a cold-start session, show the rewarded ad on the first eligible primary save/record action after the ad is loaded.
  - After that, show it again every third eligible trigger.
- If loading fails, times out, or the device is offline, dismiss any loading UI and continue the core user flow without blocking data entry.
- Treat offline separately from generic ad load failure:
  - dismiss any loading UI
  - show a user-facing prompt or toast telling the user to enable network access
  - then continue or gracefully degrade according to the product decision
- Do not block app launch or first paint on ad initialization.
- Keep ad orchestration separate from feature logic.
- Follow [references/admob-rewarded.md](references/admob-rewarded.md).

## Deliverables

Produce these outputs unless the user narrows the scope:

- `requirements.md`
- Figma screens and app icon
- Flutter source project
- A short implementation summary noting:
  - chosen architecture
  - local storage mechanism
  - ad behavior, if any
  - support/contact setup
  - any official source links added for sensitive content

## References

- Requirements template: [references/requirements-template.md](references/requirements-template.md)
- Figma checklist: [references/figma-delivery.md](references/figma-delivery.md)
- Flutter implementation guide: [references/flutter-build.md](references/flutter-build.md)
- Rewarded ad guide: [references/admob-rewarded.md](references/admob-rewarded.md)
