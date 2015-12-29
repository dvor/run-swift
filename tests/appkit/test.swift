#!/bin/sh run-swift.sh
#!import include.swift

import AppKit

print("03_appkit_test: test.swift")

let shadow = NSShadow()
shadow.shadowBlurRadius = 17.0
print("shadow blur radius: \(shadow.shadowBlurRadius)")