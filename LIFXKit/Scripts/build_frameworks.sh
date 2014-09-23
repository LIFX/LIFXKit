#!/bin/sh

# Run this script from the directory containing LIFXKit.xcodeproj

# Exit immediately on command failure
set -e


# Configurables

LFX_SCHEME_IOS="LIFXKit iOS Static Framework"
LFX_SCHEME_OSX="LIFXKit OS X Framework"
LFX_CONFIGURATION="Release"
LFX_BUILD_DIR="build"
LFX_DERIVED_DATA_DIR="${LFX_BUILD_DIR}/derivedData"
LFX_PRODUCTS="${LFX_BUILD_DIR}/Products"
LFX_PRODUCTS_IOS="${LFX_PRODUCTS}/iOS"
LFX_PRODUCTS_OSX="${LFX_PRODUCTS}/OSX"


# Functions

lfx_build()
{
    local scheme=$1; shift
    
    xcodebuild -scheme "$scheme" -configuration "$LFX_CONFIGURATION" -derivedDataPath "${LFX_DERIVED_DATA_DIR}" build

    if [ $? -ne 0 ]; then
        echo "Build failed"
        exit 1
    fi
}


# Build frameworks

mkdir -p "$LFX_BUILD_DIR"

lfx_build "$LFX_SCHEME_IOS"
lfx_build "$LFX_SCHEME_OSX"


# Copy frameworks to destination

[ -d "$LFX_PRODUCTS_IOS" ] && rm -rf "$LFX_PRODUCTS_IOS"
mkdir -p "$LFX_PRODUCTS_IOS"

[ -d "$LFX_PRODUCTS_OSX" ] && rm -rf "$LFX_PRODUCTS_OSX"
mkdir -p "$LFX_PRODUCTS_OSX"

cp -a "${LFX_DERIVED_DATA_DIR}/Build/Products/Release-iphoneos/LIFXKit.framework" "${LFX_PRODUCTS_IOS}/"
cp -a "${LFX_DERIVED_DATA_DIR}/Build/Products/Release/LIFXKit.framework" "${LFX_PRODUCTS_OSX}/"


# Finished

echo
echo "** Find the built Frameworks in \"${LFX_PRODUCTS}/\" **"
echo
