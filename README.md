* Kanaspeech, an hybrid application built with ionic framework

** Android Deploy process

Increase version number in /config.xml

<widget id="com.ionicframework.kanaspeech" version="0.0.2" xmlns="http://www.w3.org/ns/widgets" xmlns:cdv="http://cordova.apache.org/ns/1.0">

Build
cordova build --release android

Sign the unsigned APK, in platforms\android\ant-build, run: (passphrase for keystore)
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore android-release-unsigned.apk alias_name

in D:\dev\android\android-sdk\sdk\build-tools\android-4.4W
zipalign -v 4 android-release-unsigned.apk kanaspeech.apk

** Tests with Karma

command: node_modules/karma/bin/karma start