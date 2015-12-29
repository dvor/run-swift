#!/bin/sh run-swift.sh tests/05_osx_app_test/AppDelegate.swift tests/05_osx_app_test/MyApplication.swift END

import Cocoa

NSApplicationMain(Process.argc, Process.unsafeArgv)