# Flutter Build Guide (Corrected)

Use this file after requirements and design are stable.

## Bootstrap

- Normalize the product slug.
- Default output path to `/Users/app/<product-slug>` when the requested path is invalid.
- Create the project for iOS and Android only.
- Keep package name, bundle ID placeholders, and app title aligned with the new product.

## Architecture Selection

Choose one mainstream architecture that fits the real scope.

- `MVVM + Provider`
  - Use for small CRUD-style apps with limited branching.
- `Riverpod + Repository`
  - Use when dependency boundaries and testability matter more.
- `BLoC/Cubit + Repository`
  - Use for heavier flows or more explicit event/state separation.

Document the chosen architecture in the implementation summary.

## Implementation Rules

- Decouple UI, state, and persistence.
- Prefer feature-first grouping when it helps readability.
- Avoid fake shipped seed data unless the user asks for it.
- Support first-run empty states cleanly.
- Ensure prominent dashboard and collection surfaces navigate somewhere meaningful.
- Add a Settings reference cluster by default:
  - `Privacy Policy`
  - `Terms of Use`
  - `Support`
- If the user provides a support email, render it inside the in-app Support page and reuse it in generated support/privacy copy where appropriate.

## Local Storage Selection

Pick the lightest storage that still matches the app size and data model.

- `shared_preferences`
  - Acceptable for small local-only apps with lightweight structured data, simple JSON persistence, and limited reporting complexity.
  - Not ideal once the app grows into heavier querying, migration, or larger datasets.
- `Hive` or `Isar`
  - Prefer for lightweight structured local entities and fast offline CRUD when the product is expected to expand.
- `SQLite` or `drift`
  - Use when relations, filtering, or reporting logic become significantly more complex.

Explain the storage choice in the implementation summary.

## Sensitive Domains

If the app touches finance, health, legal, or similar areas:

- Avoid diagnosis or authoritative professional recommendations.
- Present user-entered records and summaries clearly.
- Add official sources in a discoverable place when relevant.
- Cite those sources in `requirements.md`.

## Differentiation

- Build from the new requirements, not by mirroring the source app screen-for-screen.
- Change naming, copy, interaction details, and visual system where appropriate.
- Only vary architecture or foldering when it still makes engineering sense.
