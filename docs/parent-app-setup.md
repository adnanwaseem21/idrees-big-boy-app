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

## Wire the watch to use it (the remaining step)

Right now the watch reads its settings from `FamilyConfig.swift` (hard-coded).
To make the parent app actually drive the watch, the watch needs to read
`FamilySettings` from the shared `SettingsStore` instead, and write Idrees's
daily totals into `KidProgress`. Planned changes on the watch side:

- Replace reads of `FamilyConfig.tasks/schedule/rewards/...` with
  `settingsStore.settings.*`.
- After each prayer/chore is ticked, write a `DaySummary` for today into the
  `kidProgress` iCloud key (mirroring what `KidStore` already tracks locally).

Until that wiring is done, the parent app runs and saves settings on its own,
and the watch keeps using `FamilyConfig`. Both build and run in the
simulators today; the wiring is the next watch-side task once the watch
arrives and we can test end to end.
