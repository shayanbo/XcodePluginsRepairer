#! /bin/sh

XCODE_VERSION="$(xcrun xcodebuild -version | head -n1 | awk '{ print $2 }')"
XCODE_INFO_PLIST_PATH="$(dirname $(dirname $(xcode-select -p)))/Contents/Info.plist"
XCODE_UUID=$(/usr/libexec/PlistBuddy -c "Print :DVTPlugInCompatibilityUUID" "$XCODE_INFO_PLIST_PATH")
PLUGIN_DIR="$HOME/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
hasChange="0"
for plugin in $(ls -1 "$PLUGIN_DIR")
do
  PLUGIN_INFO_PLIST_PATH="$PLUGIN_DIR/$plugin/Contents/Info.plist"
  COMPABILITY_UUIDS=$(/usr/libexec/PlistBuddy -c "Print :DVTPlugInCompatibilityUUIDs" "$PLUGIN_INFO_PLIST_PATH")
  if [[ ! $COMPABILITY_UUIDS =~ $XCODE_UUID ]]; then
    hasChange = "1"
    /usr/libexec/PlistBuddy -c "Add :DVTPlugInCompatibilityUUIDs: string $XCODE_UUID" "$PLUGIN_INFO_PLIST_PATH"
  fi
done

if [[ $hasChange == "0" ]]; then
  echo "All Plugins is Compatible!"
else
  echo "Please Restart Xcode $XCODE_VERSION🍺"
fi
