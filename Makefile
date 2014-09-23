default: analyze

clean:
	@echo "\n\033[04m+ clean\033[0m"
	rm -rf ~/Library/Developer/Xcode/DerivedData/LIFXKit*/Build

analyze: analyze-ios analyze-osx

analyze-ios:
	set -o pipefail && xcodebuild -scheme 'LIFXKit iOS Static Library' -project LIFXKit/LIFXKit.xcodeproj clean analyze | xcpretty -c && exit

analyze-osx:
	set -o pipefail && xcodebuild -scheme 'LIFXKit OS X Static Library' -project LIFXKit/LIFXKit.xcodeproj clean analyze | xcpretty -c && exit
