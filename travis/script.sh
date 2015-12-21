#!/bin/sh
set -e

xctool -workspace NXTSegmentedControl.xcworkspace -scheme NXTSegmentedControl -sdk iphonesimulator -destination 'iPhone 6s: 9.1' test
