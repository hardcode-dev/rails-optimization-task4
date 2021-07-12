#!/bin/sh

NO_METRIC=1 TEST_STACK_PROF=1 TEST_STACK_PROF_FORMAT=callgrind rspec $@
stackprof --callgrind tmp/test_prof/stack-prof-report-wall-raw-total.dump > tmp/test_prof/stack-prof-report-wall-raw-total.callgrind
qcachegrind tmp/test_prof/stack-prof-report-wall-raw-total.callgrind

