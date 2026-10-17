#!/bin/sh
# Runs on Apple's Xcode Cloud build machine after it clones the repo.
# Installs XcodeGen, generates the Xcode project, and drops the committed
# Package.resolved into place so the archive (which has automatic Swift package
# resolution disabled) builds without re-resolving.
set -e
brew install xcodegen
cd "$CI_PRIMARY_REPOSITORY_PATH"
xcodegen generate
if [ -f Package.resolved ]; then
  mkdir -p IdreesBigBoyApp.xcodeproj/project.xcworkspace/xcshareddata/swiftpm
  cp Package.resolved IdreesBigBoyApp.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved
fi
