# Gopalakrishnan Salem — TV & Videos

Tamil-language HLS live TV and local video app.

## Build a debug APK locally

Requirements: Node.js 20, Java 17, Android SDK, and Android platform/build tools installed.

```bash
npm install
npx cap add android   # only needed the first time
bash scripts/build-android-apk.sh
```

The script builds and copies the debug APK to `dist-apk/salem-cluster-mis-debug.apk`. The generated `android/`, `www/`, and `dist-apk/` directories are build outputs and are intentionally ignored by Git.

For installing the debug APK on a connected Android device with ADB:

```bash
adb install -r dist-apk/salem-cluster-mis-debug.apk
```

A debug APK is intended for testing, not Play Store distribution. Release distribution requires a protected signing keystore and release signing configuration.
