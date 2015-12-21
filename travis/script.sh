#!/bin/sh
set -e

xctool -workspace NXTSegmentedControl.xcworkspace -scheme NXTSegmentedControl -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6s,OS=9.1' test
