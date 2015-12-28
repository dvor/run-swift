#!/bin/sh run-swift.sh tests/03_appkit_test/include.swift END

import AppKit

print("03_appkit_test: test.swift")

let shadow = NSShadow()
shadow.shadowBlurRadius = 17.0
print("shadow blur radius: \(shadow.shadowBlurRadius)")