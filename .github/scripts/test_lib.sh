#!/bin/bash

set -eo pipefail

xcodebuild -workspace Example/LazySequence.xcworkspace \
            -scheme LazySequence-Example \
            -destination platform=iOS\ Simulator,OS=15.2,name=iPhone\ 11 \
            clean test | xcpretty
