# Building

## Download dependencies

`download.sh` will take care of installing the Android SDK/NDK and downloading the sources.

```
./download.sh
```

## Build

```
./buildall.sh --arch arm64 mpv
./buildall.sh
```

Run `buildall.sh` with `--clean` to clean the build directories before building.

# Developing

## Getting logs

```
adb logcat # get all logs, useful when drivers/vendor libs output to logcat
adb logcat -s "mpv" # get only mpv logs
```

## Rebuilding a single component

If you've made changes to a single component (e.g. ffmpeg or mpv) and want a new build you can of course just run ./buildall.sh but it's also possible to just build a single component like this:

```
./buildall.sh --no-deps ffmpeg
# optional: add --clean to build from a clean state
```

Note that you might need to rebuild for arm64 depending on your device by adding `--arch arm64` to the command above.

Afterwards, build mpv-android and install the apk:

```
./buildall.sh --no-deps mpv-android
adb install -r ./mpv-android/app/build/outputs/apk/app-debug.apk
```

## Using Android Studio

You can use Android Studio to develop the Java part of the codebase. Before using it, make sure to build the project at least once by following the steps in the **Build** section.

You should point Android Studio to existing SDK installation at `mpv-android-build/sdk/android-sdk-linux`. Then click "Open an existing Android Studio project" and select `mpv-android-build/mpv-android`.

If Android Studio complains about project sync failing (`Error:Exception thrown while executing model rule: NdkComponentModelPlugin.Rules#createNativeBuildModel`), go to "File -> Project Structure -> SDK Location" and set "Android NDK Location" to `mpv-android-build/sdk/android-ndk-rVERSION`.

Note that if you build from Android Studio only the Java part will be built. If you make any changes to libraries (ffmpeg, mpv, ...) or mpv-android native code (`app/src/main/jni/*`), first rebuild native code with:

```
./buildall.sh --no-deps mpv-android
```

then build the project from Android Studio.

Also, debugging native code does not work from within the studio at the moment, you will have to use gdb for that.

## Debugging native code with gdb

You first need to rebuild mpv-android with gdbserver support:

```
NDK_DEBUG=1 ./buildall.sh --no-deps mpv-android
adb install -r ./mpv-android/app/build/outputs/apk/app-debug.apk
```

After that, ndk-gdb can be used to debug the app:

```
cd mpv-android/app/src/main/
../../../../sdk/android-ndk-r*/ndk-gdb --launch
```

# Credits, notes, etc

These build scripts were created by @sfan5, thanks!

