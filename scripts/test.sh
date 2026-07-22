#!/bin/bash
set -e

echo "=== Running Flutter Tests ==="
flutter test --coverage

echo ""
echo "=== Generating Coverage Report ==="
if command -v genhtml &> /dev/null; then
  genhtml coverage/lcov.info -o coverage/html
  echo "Report generated at coverage/html/index.html"
else
  echo "lcov not installed. Install with: brew install lcov"
fi

echo ""
echo "=== Tests Complete! ==="
