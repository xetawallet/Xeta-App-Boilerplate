# Xeta App Boilerplate v1.0.0

This repository is a reusable Flutter and Android starter for building new apps. It includes a working Flutter project, light and dark themes, an optional crypto donation page, APK build tooling, and Play Store asset generation tools. Use this folder as the repository root when creating a new app. Build outputs, test APKs, and internal notes belong in the sibling `Not Uploaded to Github` folder in the original workspace.

## Apps built from this boilerplate

- [Xeta File Manager](https://github.com/xetawallet/Xeta-File-Manager-App) — Android file manager.

Add each published app as a new list entry in this section.

## Build the starter app

The Flutter project is in `App Code`. Set a unique package name in `pubspec.yaml`, `android/app/build.gradle.kts`, and `android/app/src/main/kotlin/com/example/new_app/MainActivity.kt` before publishing.

```sh
cd "App Code"
flutter pub get
flutter run
```

The sample home page includes a light/dark theme toggle and an optional donation page with QR codes and copyable public addresses listed in `App Code/assets/donation_wallets.json`. Never put private keys or seed phrases in the app.

Build an APK from this folder:

```sh
python3 tool/build_apk.py test --app-slug my-app
python3 tool/build_apk.py production --app-slug my-app
```

The script builds from `App Code` and creates the output folders as needed under the sibling `Not Uploaded to Github/APK's (Test,Uploaded and To be Uploaded)`. Test APKs go into `Test`; release APKs go into `To be Uploaded`. Configure release signing in the app's Android Gradle files before distributing a release build.

## Play Store assets and privacy site

`tool/generate_playstore_package.py` creates a 512 x 512 PNG app icon, feature graphics, tablet screenshots, and a static app/privacy website. Add the source app icon at `App Code/assets/app_icon.png` (the generator fits it to a square without stretching), add phone screenshots to `App Code/assets/Play Store Assets-Master/Screenshots Taken from Phone/Google Play Screenshots`, and edit `App Code/assets/privacy_policy.md` to describe the app accurately. Replace the sample text in `App Code/assets/website_features.json`.

Run the generator from this folder:

```sh
python3 tool/generate_playstore_package.py --app-name "App name" --tagline "Short description"
```

The source-code URL is optional. Generated files stay under `App Code/assets/Play Store Assets-Master` (including `App icon/app_icon.png`) and `App Code/assets/Website/build`. Review generated text before publishing.

After adding a square app icon, create Android density assets with:

```sh
python3 tool/generate_app_icon.py
```

Feel free to submit a Merge Request if any features are needed.
