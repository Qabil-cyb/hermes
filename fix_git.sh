#!/bin/bash

set -e

echo "== Cleaning Flutter build files =="

cat >> .gitignore <<'GITIGNORE'

# Flutter generated
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/

# Flutter build
build/
**/build/

# Android build
android/.gradle/
android/app/build/
*.apk
*.aab

# Hermes agent
hermes-agent/
GITIGNORE


echo "== Removing generated files from git =="

git rm -r --cached --ignore-unmatch spider-panel-android/build
git rm -r --cached --ignore-unmatch spider-panel-android/.dart_tool
git rm -r --cached --ignore-unmatch hermes-agent


echo "== Installing git-filter-repo if needed =="

if ! command -v git-filter-repo >/dev/null; then
    pip install git-filter-repo
fi


echo "== Removing big files from history =="

git filter-repo --force \
 --path spider-panel-android/build \
 --path spider-panel-android/.dart_tool \
 --path hermes-agent \
 --invert-paths


echo "== Commit =="

git add .gitignore
git add -A

git commit -m "Clean Flutter build files and update Spider panel" || true


echo "== Force push =="

git push --force origin main


echo "DONE!"
