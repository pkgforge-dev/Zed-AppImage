#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON="$PWD"/zed.app/share/icons/hicolor/512x512/apps/zed.png
export DESKTOP="$PWD"/zed.app/share/applications/dev.zed.Zed.desktop
export DEPLOY_VULKAN=1
export URUNTIME_PRELOAD=1
export ZED_ALLOW_ROOT=true
export STARTUPWMCLASS=dev.zed.Zed

# Deploy dependencies
quick-sharun ./zed.app/*/*
ln -s bin ./AppDir/libexec

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
