#!/bin/sh
set -e

xctool -workspace NXTSegmentedControl.xcworkspace -scheme NXTSegmentedControl -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.1' test
