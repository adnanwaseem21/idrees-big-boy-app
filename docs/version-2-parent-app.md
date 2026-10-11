# Version 2 — the parent app (iPhone)

Version 1 is the watch app Idrees uses. Version 2 is an iPhone app for the
parent, so you can change things without editing code or re-installing.

## What the parent app does

- **Edit chores & activities** — add, remove, rename, change points and
  reminder times (e.g. move karate to whichever day it lands on this week).
- **Edit the schedule** — school, karate, dinner, bedtime.
- **Prayer settings** — calculation method, Asr madhab, adhan on/off.
- **Rewards** — add rewards and set point costs; approve a reward when he
  asks to redeem it.
- **Games** — a master on/off switch, plus the blackout windows when games
  lock (school hours, bedtime). In version 1 these live in `FamilyConfig`
  (`gamesEnabled`, `gameBlackouts`, `games`); version 2 turns them into
  toggles on your phone, and new games added to the app appear here to
  allow or hide per game.
- **See his week** — the same weekly review, on your phone.
- **Send him a voice message** — he plays it on his watch.
- **Check-in** — tap to make his watch buzz and ask him to send a quick
  voice note or tap "I'm OK". He always sees it; nothing is secret.

## How it syncs (no server, no monthly fee)

The watch and the phone share data through the family's **iCloud** account
using CloudKit. The parent app writes the settings; the watch reads them and
shows his progress back. Both work offline and catch up when they get signal.

## What this version will NOT do

- No hidden/remote microphone listening. watchOS blocks background audio
  recording and always shows a recording indicator, so there is no supported
  way to listen in without Idrees knowing. The check-in button above is the
  open alternative.
- Live GPS tracking already lives in Apple's **Find My** app with Family
  Setup, so the parent app links to it rather than rebuilding it.

## Rough build order

1. Move the settings in `FamilyConfig.swift` into a shared CloudKit record.
2. Build the iPhone app UI to edit that record.
3. Add reward-approval and check-in messages.
4. Mirror the weekly review on the phone.
