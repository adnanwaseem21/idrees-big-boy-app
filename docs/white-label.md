# White-labeling this app

The app is built to be rebranded for any family or resold under a new name
without touching feature code. Everything brand-specific lives in one file:
`Shared/Brand.swift`.

## Rebrand in four steps

1. **Edit `Shared/Brand.swift`:**
   - `appName` / `shortName` — the product name shown in the app.
   - `greeting` — the watch's welcome line (e.g. "Hi", "Salaam").
   - `defaultChildName` — starting name (the parent can change it in-app).
   - `accentRGB` — the brand color used across both apps.
   - `islamicFeatures` — `true` keeps prayer times, Qibla, duas, adhan and the
     prayer streak. Set `false` for a secular build and those features hide
     themselves everywhere (watch menu, home card, and the parent app's Faith
     settings), leaving chores, schedule, calling, voice notes, rewards and
     games.

2. **Swap the app icon.** Replace the image in
   `NoorWatch/Assets.xcassets/AppIcon`. The `iw-logo.svg` at the repo root is
   the source for the current icon if you want to edit it.

3. **Set the Display Name** for each target in Xcode → target → General →
   Display Name.

4. **Rename the bundle identifiers** (e.g. `com.yourcompany.appname`) per
   target in Signing & Capabilities, and use your own iCloud container.

## What is NOT hard-coded

- The child's name, parents, phone numbers, quick messages, chores, schedule,
  rewards, prayer method, points and games are all **data**, edited in the
  parent app and synced over iCloud — not baked into the code.
- Colors and names come from `Brand`.
- Faith features are gated by one flag.

## Per-customer settings vs. brand

- **`Brand`** = the product identity (name, color, which feature set). One per
  white-label build.
- **`FamilySettings`** = one family's choices (child, contacts, chores…),
  edited live in the parent app.

So one white-label build serves many families, each configuring their own
settings on their own phone.
