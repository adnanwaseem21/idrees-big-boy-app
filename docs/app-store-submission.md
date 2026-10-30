# App Store submission — step by step

This is the part only you can do, because it needs a Mac with Xcode and your
Apple Developer account. I've set everything up so it's mostly clicking
through. Budget an afternoon the first time.

## 0. Before you start
- An **Apple Developer Program** membership ($99/year) — you have this.
- The project open in **Xcode** on your Mac (pull the latest from GitHub).
- A **support URL** and a **privacy policy URL** live on the web. Use
  `docs/privacy-policy.md` as the text; host it anywhere public (a free
  Notion page or GitHub Pages works).

## 1. Make it one app that contains the watch app
Right now the repo has two targets: the watch app (`NoorWatch`) and the parent
iPhone app (`ParentApp`). For the App Store, the cleanest shape is **one iOS
app (the parent app) with the watch app embedded in it**, so a single
submission ships both.

In Xcode:
1. Select the project → the iOS (ParentApp) target → **General → Frameworks,
   Libraries, and Embedded Content** (or **File → New → Target → watchOS →
   App** and move the `NoorWatch` files in) so the watch app is embedded in
   the iOS app.
2. Make sure every file in `Shared/` has **both** targets checked under Target
   Membership.
3. Add the **iCloud → Key-value storage** capability to both targets, same
   container.

(If you'd rather ship the watch app on its own, that's allowed too, but the
embedded setup is simpler to manage and review.)

## 2. Identifiers & signing
- Give each target a real **Bundle Identifier** (e.g.
  `com.ewsnetworks.idreesbigboy` and `.watchkitapp`).
- In **Signing & Capabilities**, pick your Team and let Xcode manage signing.
- Set the **Display Name** (Idrees Big Boy App) and bump **Version** to 1.0
  and **Build** to 1.

## 3. App icon
The watch icon is in the asset catalog. Add the **iOS app icon** too
(1024×1024 for the App Store). Use the same IW artwork — I can render the iOS
icon sizes from `iw-logo.svg` on request.

## 4. Export compliance
In the iOS target's **Info** tab add:
`ITSAppUsesNonExemptEncryption` = `NO`
(The app uses only standard HTTPS/iCloud encryption — exempt.)

## 5. Create the app in App Store Connect
1. Go to appstoreconnect.apple.com → **Apps → +** → **New App**.
2. Platform iOS, pick your bundle ID, set the name and primary language.
3. Fill the listing from `docs/app-store-listing.md`.
4. **Privacy:** in App Privacy, answer **"Data Not Collected"** (true for this
   app). Add the privacy policy URL.
5. Set **Age rating** 4+.

## 6. Kids Category (optional but likely)
If you choose the **Kids** category, Apple adds rules — all of which this app
already meets:
- No third-party analytics or advertising. ✓ (we have none)
- No external links or purchases without a **parental gate**. We have no
  purchases; the watch-setup links live in the parent app, not the child's
  watch.
- A privacy policy is required. ✓ (step 0)
Just confirm these in the Kids Category questionnaire.

## 7. Archive and upload
1. In Xcode choose **Any iOS Device** as the run destination.
2. **Product → Archive.**
3. When the Organizer opens, **Distribute App → App Store Connect → Upload.**
4. Let it validate and upload. The build appears in App Store Connect in a few
   minutes to an hour.

## 8. TestFlight first (recommended)
Before going public, add the build to **TestFlight** and install it on your
own iPhone + Idrees's watch to test end to end once the watch arrives. Add
yourself as an internal tester — no review needed for internal TestFlight.

## 9. Submit for review
When you're happy: attach the build to the 1.0 version, add **App Review
notes** (see below), and **Submit for Review**. First reviews usually take a
day or two. Kids apps can take longer.

### App Review notes to paste
> This app pairs with an Apple Watch set up via Family Setup for a child. All
> data stays in the user's own iCloud; there is no account, no server, and no
> data collection. Faith features (prayer times) are optional and parent-
> toggled. Calls/messages use the watch's cellular plan to parent-entered
> numbers only.

## What I can't do from here
I can't archive, sign, or upload — that needs your Mac, Xcode and your Apple
credentials. Everything above the upload step I've prepared in the repo. Ping
me for the iOS icon sizes or any listing tweaks.
