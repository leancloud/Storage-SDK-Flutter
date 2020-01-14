#!/bin/sh

flutter test --coverage ./test/*_test.dart
genhtml ./coverage/lcov.info -o ./coverage/html