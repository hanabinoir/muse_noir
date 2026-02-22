# Muse Noir - Icon & Splash Screen Update Guide

## Overview
This guide explains how to update the Muse Noir app icon and splash screen with the new Muse Noir branding assets.

## Images Provided
- **App Icon**: Circular logo with "Muse Noir" text and blue waveform design
- **Splash Screen**: Same Muse Noir logo with black background

---

## Step 1: Update the Splash Screen Logo

### 1.1 Prepare the Splash Screen Image
1. Save the splash screen image (second image with waveform design) as:
   - **Filename**: `muse_noir_logo.png`
   - **Size**: 512x512 pixels recommended
   - **Format**: PNG with transparency

### 1.2 Place the Logo in the Drawable Directory
- Copy `muse_noir_logo.png` to:
  ```
  android/app/src/main/res/drawable/muse_noir_logo.png
  ```

### 1.3 Splash Screen Configuration
The `launch_background.xml` has been updated to:
- Use black background (`@android:color/black`)
- Display the Muse Noir logo centered
- This matches your design with the waveform icon on black

---

## Step 2: Update the App Icons

### 2.1 Generate Icon Files
You need to create icon files for different screen densities:

| Density | Size | Location |
|---------|------|----------|
| mdpi | 48x48 | `android/app/src/main/res/mipmap-mdpi/` |
| hdpi | 72x72 | `android/app/src/main/res/mipmap-hdpi/` |
| xhdpi | 96x96 | `android/app/src/main/res/mipmap-xhdpi/` |
| xxhdpi | 144x144 | `android/app/src/main/res/mipmap-xxhdpi/` |
| xxxhdpi | 192x192 | `android/app/src/main/res/mipmap-xxxhdpi/` |

### 2.2 Use Flutter's Icon Generation Tool
The easiest way to generate icons for all densities is to use Flutter's built-in tool.

**Steps:**
1. Place your original icon image (at least 1024x1024 pixels) in a temporary location
2. Run the following command:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons:main
   ```

**Alternative: Manual Generation**
1. Use an image editor (like GIMP or Photoshop) to:
   - Resize the icon to each required size
   - Save as `ic_launcher.png` in each `mipmap-*` directory
   - Replace the existing files at:
     - `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`
     - `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`
     - `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`
     - `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`
     - `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

### 2.3 iOS Icon Update (Optional)
If building for iOS, also update:
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
  - Add the app icon in various sizes (120x120, 152x152, 167x167, 180x180, etc.)

---

## Step 3: Verify Your Changes

### 3.1 Check Android Manifest
Verify that `AndroidManifest.xml` references the correct icon:
```xml
<application
    android:icon="@mipmap/ic_launcher"
    android:label="@string/app_name"
    ...>
```

### 3.2 Rebuild the App
Run the following to rebuild and test:
```bash
flutter clean
flutter pub get
flutter run
```

### 3.3 Verify on Device
- Check that the app icon appears with the new Muse Noir logo
- Verify the splash screen displays during app startup with the logo on black background

---

## Current Configuration

### Launch Screen XML
**File**: `android/app/src/main/res/drawable/launch_background.xml`

**Configuration**:
- Background: Black
- Logo: `muse_noir_logo.png` (centered)
- This creates a clean, professional splash screen

### App Icon References
**File**: `android/app/src/main/res/values/strings.xml`
- App name: `Muse Noir`
- Icon: `@mipmap/ic_launcher`

---

## Additional Notes

### Design Specifications for Your Icon
Based on the provided image:
- **Primary Color**: Cyan/Blue (#00C9FF or similar)
- **Background**: Black (#000000)
- **Style**: Modern, waveform-based design
- **Compatibility**: Ensure transparency in PNG for proper rendering

### Testing on Different Devices
After updating icons, test on:
- Small phones (mdpi)
- Regular phones (hdpi, xhdpi)
- Large phones and tablets (xxhdpi, xxxhdpi)

### Troubleshooting
If the icon doesn't update:
1. Clear Flutter cache: `flutter clean`
2. Delete build folders: `rm -rf build` (or manually delete the `build/` folder)
3. Rebuild: `flutter run`

---

## Files Modified
1. ✅ `android/app/src/main/res/drawable/launch_background.xml` - Updated splash screen config

## Files to Create/Update
1. ✅ `android/app/src/main/res/drawable/muse_noir_logo.png` - **ACTION REQUIRED**: Create this file
2. ❌ App icon files in `mipmap-*` directories - **ACTION REQUIRED**: Create these files

---

## Summary
The splash screen has been configured to use your Muse Noir logo. Next steps:
1. Create the splash screen logo PNG file in the drawable directory
2. Generate and place app icon PNGs in the appropriate mipmap directories
3. Rebuild and test the app

Your new branding will be visible immediately on app launch! 🎵

