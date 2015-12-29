#!/bin/sh

result=0

run_test() {
	test_name=$1
	test_path="tests/$test_name"
	string="Test $test_name"
	test_result="$($test_path/test.swift)"
	expected="$(<$test_path/result.txt)"
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
}

if [ $# -lt 1 ]; then
	for test_path in tests/*/; do
		test=${test_path:6}
		run_test ${test%?}
	done
else
	for test in "$@"; do
		run_test $test
	done
fi

exit $result