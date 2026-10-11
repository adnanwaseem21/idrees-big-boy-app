# Idrees Big Boy App – a Muslim kids' app for Apple Watch

The display name under the icon is **Idrees Big Boy App**. The Xcode project
is named `NoorWatch` internally — that name never shows on the watch, only the
display name does. To set it: select the watch app target → General → set
**Display Name** to `Idrees Big Boy App`.


Prayer times and reminders, Qibla, chores and daily activities, a daily
schedule, call and message parents, voice notes, duas and tasbih, a weekly
review, points you can trade for rewards, and a game of Snake.

Everything runs on the watch. Prayer times are calculated from the date and
the last known location, and all reminders are scheduled on the watch, so no
Wi-Fi or internet is needed. Calls and texts use the watch's cellular plan.

## Set up in Xcode (about 15 minutes)

1. **New project.** Open Xcode, then File → New → Project → **watchOS** →
   **App**. Name it `NoorWatch`, set Interface to SwiftUI, and choose
   **Watch-only App**.
2. **Add the code.** In the new project, delete the template's
   `ContentView.swift` and `NoorWatchApp.swift`. Drag everything from the
   `NoorWatch/` folder here (including `Views/`) into the
   `NoorWatch Watch App` group. Tick "Copy items if needed".
3. **Add the prayer-time library.** File → Add Package Dependencies, paste
   `https://github.com/batoulapps/adhan-swift`, and add `Adhan` to the
   watch app target.
4. **Permissions.** Select the watch app target → Info tab, and add:
   - `Privacy - Location When In Use Usage Description`: "Noor uses your location to work out prayer times and the Qibla."
   - `Privacy - Microphone Usage Description`: "Noor uses the microphone to record voice notes."
5. **Your family's details.** Open `FamilyConfig.swift` and change his name,
   your phone numbers, the chores, the schedule, the rewards and the prayer
   calculation method.
6. **Try it.** Choose an Apple Watch simulator and press Run (⌘R).

## Putting it on his watch

A Family Setup watch is managed through your iPhone instead of being paired
like a normal watch, so do a quick test early:

- **TestFlight (try this first):** Product → Archive → Distribute → App Store
  Connect, then add his Apple Account as a tester in App Store Connect →
  TestFlight, and install from the TestFlight app on his watch.
- **If TestFlight isn't offered on his watch:** submit it to the App Store as
  an *unlisted* app. Only people with the link can find it, and you install it
  through the App Store on his watch with Ask to Buy.

## Changing things later

Edit `FamilyConfig.swift` and re-install. A parent iPhone app for changing
chores and seeing his weekly review from your phone is planned for version 2.

## Please check

- Review the duas in `IslamicContent.swift` against your family's preferred
  wording and translation.
- Compare the prayer times against your masjid's timetable for a few days and
  adjust `calculationMethod` / `madhab` if needed.
- Quick messages open the Messages app with the text filled in. Test this on
  the real watch, because watchOS can be picky about pre-filled texts.
