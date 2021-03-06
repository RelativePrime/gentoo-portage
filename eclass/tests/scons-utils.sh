#!/bin/bash

source tests-common.sh

inherit scons-utils

test-scons_clean_makeopts() {
	local sconsopts=$(scons_clean_makeopts ${1})

	if [[ ${sconsopts} != ${2-${1}} ]]; then
		eerror "Self-test failed:"
		eindent
		eerror "MAKEOPTS: ${1}"
		eerror "Expected: ${2-${1}}"
		eerror "Actual: ${sconsopts}"
		eoutdent
		(( ++failed ))
		return 1
	fi

	return 0
}

# jobcount expected for non-specified state
jc=5
# failed test counter
failed=0

ebegin "Testing scons_clean_makeopts()"

# sane MAKEOPTS
test-scons_clean_makeopts '--jobs=14 -k'
test-scons_clean_makeopts '--jobs=14 -k'
test-scons_clean_makeopts '--jobs 15 -k'
test-scons_clean_makeopts '--jobs=16 --keep-going'
test-scons_clean_makeopts '-j17 --keep-going'
test-scons_clean_makeopts '-j 18 --keep-going'

# needing cleaning
test-scons_clean_makeopts '--jobs -k' "--jobs=${jc} -k"
test-scons_clean_makeopts '--jobs --keep-going' "--jobs=${jc} --keep-going"
test-scons_clean_makeopts '-kj' "-kj ${jc}"

# broken by definition (but passed as it breaks make as well)
test-scons_clean_makeopts '-jk'
test-scons_clean_makeopts '--jobs=randum'
test-scons_clean_makeopts '-kjrandum'

# needing stripping
test-scons_clean_makeopts '--load-average=25 -kj16' '-kj16'
test-scons_clean_makeopts '--load-average 25 -k -j17' '-k -j17'
test-scons_clean_makeopts '-j2 HOME=/tmp' '-j2'
test-scons_clean_makeopts '--jobs funnystuff -k' "--jobs=${jc} -k"

# bug #388961
test-scons_clean_makeopts '--jobs -l3' "--jobs=${jc}"
test-scons_clean_makeopts '-j -l3' "-j ${jc}"

eend ${failed}
