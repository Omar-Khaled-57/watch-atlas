#!/bin/bash
set -e

echo "=== Running Flutter Analyze ==="
flutter analyze

echo ""
echo "=== Checking Formatting ==="
dart format --set-exit-if-changed .

echo ""
echo "=== All checks passed! ==="
