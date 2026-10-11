# Parent app (version 2) — setup

The parent app is an iPhone app that edits the watch's settings. It lives in
`ParentApp/`, with code shared with the watch in `Shared/`. Everything syncs
over the family's iCloud — no server, no monthly fee.

## What works now

- Edit chores, activities, schedule, rewards, prayer method, and games.
- **Games controls:** a master on/off switch, per-game toggles, and locked
  windows (school hours, bedtime) with a day picker.
- **His week:** reads Idrees's progress once the watch starts sending it.

## Add the iPhone target in Xcode

1. In your project, **File → New → Target → App** (iOS). Name it
   `ParentApp`, SwiftUI interface.
2. **Remove** the template's `ContentView.swift` and `ParentAppApp.swift`,
   then drag in everything from `ParentApp/`.
3. Drag the `Shared/` folder in too. For **every file in `Shared/`**, open the
   File Inspector and tick **both** targets under *Target Membership*
   (the watch app and ParentApp). These files are the common settings model.
4. Select the project → **Signing & Capabilities** for *both* targets →
   **+ Capability → iCloud** → turn on **Key-value storage**. Use the **same
   iCloud container** for both so they share data.

## Watch ↔ parent wiring (done)

The watch now reads its settings live from the shared store instead of
hard-coded values, and reports progress back:

- `FamilyConfig` (watch) is a thin bridge over `LiveSettings.shared`, which
  reads the same `familySettings` iCloud key the parent app writes. Change a
  setting on the phone and the watch reflects it. Property names are
  unchanged, so the rest of the watch code was untouched.
- `KidStore` writes today's totals (prayers, chores, points) into the
  `kidProgress` iCloud key via `KidProgressWriter` after every change; the
  parent app's "His week" reads them.
- Faith features on the watch follow the per-family `faithFeaturesOn` setting.

**Still to verify in Xcode** (needs a Mac + ideally the watch): build both
targets, confirm `Shared/` files are in both, turn on the iCloud key-value
capability with one shared container, and watch a change on the phone appear
on the watch. The logic is in place; it just hasn't been compiled or run on a
device from here.
