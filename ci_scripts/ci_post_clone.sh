#!/bin/sh
# Runs on Apple's Xcode Cloud build machine after it clones the repo.
# It installs XcodeGen and generates the Xcode project, so we never have to
# commit the generated .xcodeproj and updates are fully automatic.
set -e
brew install xcodegen
cd "$CI_PRIMARY_REPOSITORY_PATH"
xcodegen generate
