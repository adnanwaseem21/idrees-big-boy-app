# MacinCloud walkthrough — build & upload from Windows

Goal: rent a Mac in the cloud, build the app on it, and send it to TestFlight —
all from your Windows PC's browser. ~1–2 hours the first time.

## 1. Sign up & pick a plan
Go to **macincloud.com → Plans**.
- **Pay-As-You-Go** (~$1/hour) is cheapest to try first.
- If the server won't let you install tools (some shared servers are locked
  down), that's fine — we build the project **directly in Xcode**, no tools
  needed. If you'd rather have full control (install Homebrew etc.), pick a
  **Managed Server** / **Dedicated** plan with admin access.

Create the account, add the plan, and note the **server address, username,
and password** they give you.

## 2. Connect from Windows
- Install **Microsoft Remote Desktop** (free, Microsoft Store) — or use
  MacinCloud's **browser** connection option.
- Enter the server address + login they gave you. You'll see a Mac desktop in
  a window on your PC.

## 3. Get the code onto the Mac
Easiest (no git setup): download the repo as a ZIP.
1. On the cloud Mac, open **Safari** → go to **github.com** → sign in.
2. Open your repo **idrees-big-boy-app** → green **Code** button → **Download
   ZIP**.
3. In Finder, double-click the ZIP to unzip it (e.g. to Desktop).

## 4. Sign in with your Apple ID
- Open **Xcode** → menu **Xcode → Settings → Accounts → +** → add your Apple
  ID (the one with your Developer membership).

## 5. Open / create the project
We'll do this part **together, live** — it's the fiddly bit. Two routes:

- **If the server allows installs:** Terminal →
  `brew install xcodegen`, then `cd` into the unzipped folder and
  `xcodegen generate`, then open `IdreesBigBoyApp.xcodeproj`. One command and
  the whole project is built.
- **If installs are blocked:** we make the project in Xcode by hand
  (File → New → Project → watchOS App, then add the iOS app and drag the
  source files in). More clicks, but works on any server. I'll walk you
  through each screen.

Either way, **take a screenshot and paste it here** when you reach this step
and I'll tell you exactly what to click.

## 6. Build
- Pick an **iPhone simulator**, press **Run (▶)** — the parent app.
- Pick a **Watch simulator**, run the watch app.
- Paste me any red errors; I'll fix them fast.

## 7. Upload to TestFlight (no App Store review needed)
- Set the run target to **Any iOS Device**.
- **Product → Archive** → when the Organizer opens, **Distribute App → App
  Store Connect → Upload**.
- In **App Store Connect → TestFlight**, add yourself as an internal tester,
  then install it on Idrees's watch via your iPhone.

## 8. (Optional) Submit for public App Store review
Follow `docs/app-store-submission.md` and `docs/app-store-listing.md`.

---

### What to do right now
1. Sign up for MacinCloud and get connected to the Mac desktop.
2. Come back here and say **"I'm on the Mac"** — then we do steps 3–7 together,
   you pasting screenshots and I guide each click.
