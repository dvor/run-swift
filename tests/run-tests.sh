#!/bin/sh

for f in tests/*/; do
	string="Test ${f%?}"
	result="$(./${f}test.swift)"
	expected="$(<${f}result.txt)"
	if [ "${result##*( )}" == "$expected" ]; then
		echo "\033[0;32m✓ $string\033[0m"
	else
		echo "\033[0;31m✗ $string\033[0m"
		echo "Expected:"
		echo $expected
		echo "Actual result:"
		echo $result
	fi
done