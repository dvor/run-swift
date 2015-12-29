#!/bin/sh

result=0

for f in tests/*/; do
	string="Test ${f%?}"
	test_result="$(./${f}test.swift)"
	expected="$(<${f}result.txt)"
	if [ "${test_result}" == "$expected" ]; then
		echo "\033[0;32m✓ $string\033[0m"
	else
		echo "\033[0;31m✗ $string\033[0m"
		echo "Expected:"
		echo $expected
		echo "Actual result:"
		echo $test_result
		result=1
	fi
done

exit $result