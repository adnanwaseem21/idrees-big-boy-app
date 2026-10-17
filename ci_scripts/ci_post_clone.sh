#!/bin/sh
# Runs on Apple's Xcode Cloud build machine after it clones the repo.
# It installs XcodeGen, generates the Xcode project, and resolves the Swift
# package dependencies (Adhan) so the archive step has a Package.resolved —
# this keeps updates fully automatic without committing the generated project.
set -e
brew install xcodegen
cd "$CI_PRIMARY_REPOSITORY_PATH"
xcodegen generate
# Pre-resolve Swift packages so Xcode Cloud's archive (which has automatic
# resolution disabled) finds a resolved file.
xcodebuild -resolvePackageDependencies -project IdreesBigBoyApp.xcodeproj
