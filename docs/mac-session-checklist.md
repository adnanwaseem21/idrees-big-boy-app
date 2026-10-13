# Mac session — get it on the watch (and submitted)

Everything below runs on your Mac. Target: app on Idrees's watch via
TestFlight (no Apple review needed), and submitted for App Store review in
parallel. Budget ~1 hour.

## Prereqs (have these open)
- GitHub Desktop (pull the latest first)
- Xcode installed, signed in with your Apple ID (Xcode → Settings → Accounts)
- Your Apple Developer membership active
- Homebrew (for one command): https://brew.sh

## 1. Generate the project
```
brew install xcodegen          # once
cd ~/Documents/GitHub/idrees-big-boy-app   # wherever GitHub Desktop cloned it
xcodegen generate
open IdreesBigBoyApp.xcodeproj
```

## 2. Signing (both targets)
- Select the project → each target → Signing & Capabilities.
- Pick your **Team**. Let Xcode manage signing.
- Confirm the **iCloud → Key-Value storage** capability is on for both (the
  entitlements files already request it; just make sure the capability shows).

## 3. Build & run
- Pick an iPhone simulator → Run the parent app. Walk the setup flow.
- Pick a watch simulator → Run the watch app. Check the screens.
- Fix any compile errors (paste them to me and I'll correct them fast).

## 4. Put it on the real watch (TestFlight — no review wait)
- Product → Archive → Distribute App → App Store Connect → Upload.
- In App Store Connect → TestFlight → add yourself as an internal tester.
- Install TestFlight on the watch (via your paired iPhone) and get the app.

## 5. Submit for App Store review (in parallel)
- Fill the listing from `docs/app-store-listing.md`.
- App Privacy → "Data Not Collected"; add the privacy policy URL
  (`docs/privacy-policy.md`, hosted somewhere public).
- Add screenshots (capture from the simulator, or ask me for framed ones).
- Answer the Kids Category questions (we meet them — see
  `docs/app-store-submission.md`).
- Submit. Approval comes whenever Apple's queue clears; the watch already has
  the app via TestFlight regardless.

## If anything errors
Paste the exact message here. Most likely first-build fixes: a missing Target
Membership on a `Shared/` file, a bundle ID collision, or a small Swift tweak
from the watch wiring — all quick.
