# Phase 3, Step 2 - Quick Reference Guide

## How to Use the Implemented Components

### 1. Initialize Media Library on App Startup

```dart
// In your main.dart or app initialization
final mediaLibraryService = ref.read(mediaLibraryServiceProvider);
final initialized = await mediaLibraryService.initialize();

if (!initialized) {
  // Show permission screen (Phase 3 Step 3)
}
```

### 2. Load All Library Data

```dart
// In a widget with ConsumerWidget
class LibraryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(libraryControllerProvider);
    
    // Load all data
    Future.microtask(() => controller.loadLibrary());
    
    // Get the data
    final tracks = ref.watch(allTracksProvider);
    final albums = ref.watch(allAlbumsProvider);
    final artists = ref.watch(allArtistsProvider);
    
    return ListView(
      children: [
        Text('${controller.getTrackCount()} tracks'),
        Text('${controller.getAlbumCount()} albums'),
        Text('${controller.getArtistCount()} artists'),
        ...tracks.map((track) => ListTile(
          title: Text(track.title),
          subtitle: Text(track.artist),
        )),
      ],
    );
  }
}
```

### 3. Search Functionality

```dart
// Search with input
final query = 'queen';
final controller = ref.read(libraryControllerProvider);
await controller.searchTracks(query);

// Watch search results
final results = ref.watch(searchProvider);

// Clear search
controller.clearSearch();
```

### 4. Permission Checking

```dart
// Check permission status
final permissionStatus = ref.watch(permissionStatusProvider);

if (permissionStatus == PermissionStatus.granted) {
  // Library is available
} else if (permissionStatus == PermissionStatus.permanentlyDenied) {
  // Show button to open settings
} else {
  // Show permission request screen
}
```

### 5. Manual Permission Request

```dart
final permissionNotifier = ref.read(permissionStatusProvider.notifier);

// Check current status
await permissionNotifier.checkPermission();

// Request permission
final granted = await permissionNotifier.requestPermission();

// Open app settings
await permissionNotifier.openSettings();
```

### 6. Direct Media Scanner Usage

```dart
// Get all tracks with raw scanner
final scanner = ref.read(mediaScannerProvider);
final allTracks = await scanner.getAllTracks();

// Get tracks for album
final albumTracks = await scanner.getTracksForAlbum('123');

// Get artwork
final artwork = await scanner.getTrackArtwork(trackId);
```

## File Organization

### Permission Handling
```
services/permissions/
└── permission_service.dart
    ├── hasMediaPermission()
    ├── requestMediaPermission()
    ├── isMediaPermissionPermanentlyDenied()
    └── openAppSettings()

features/permissions/state/
├── permission_state.dart (PermissionNotifier, PermissionStatus)
└── permission_providers.dart (providers)
```

### Media Discovery
```
services/media/
├── media_scanner.dart
│   ├── getAllTracks()
│   ├── getAllAlbums()
│   ├── getAllArtists()
│   ├── searchTracks()
│   └── getTrackArtwork()
├── media_library_service.dart (high-level coordinator)
└── local_media_datasource.dart (data access)

data/repositories/
└── media_repository.dart (implementation)

domain/repositories/
└── media_repository.dart (interface)
```

### State Management
```
features/library/state/
├── library_state.dart (LibraryNotifier, AlbumNotifier, etc.)
└── library_providers.dart (allTracksProvider, etc.)

features/library/controller/
└── library_controller.dart (LibraryController, business logic)
```

## Provider Dependencies

```
libraryControllerProvider
├── allTracksProvider
├── allAlbumsProvider
├── allArtistsProvider
├── searchProvider
└── searchQueryProvider
    ↓ (all depend on)
    mediaRepositoryProvider
        ↓ (depends on)
        localMediaDataSourceProvider
            ↓ (depends on)
            mediaScannerProvider
                ↓ (uses)
                on_audio_query

permissionStatusProvider
    ↓ (depends on)
    permissionServiceProvider

mediaLibraryServiceProvider
    ├── permissionServiceProvider
    └── mediaScannerProvider
```

## Error Handling

### Permission Errors
```dart
try {
  final granted = await permissionNotifier.requestPermission();
} catch (e) {
  // Handle PermissionException
  print('Permission error: $e');
}
```

### Media Scan Errors
```dart
try {
  await controller.loadAllTracks();
} catch (e) {
  // Handle MediaScanException
  print('Media scan error: $e');
}
```

## Common Patterns

### Pattern 1: Load and Display Tracks
```dart
Future<void> _loadTracks(WidgetRef ref) async {
  final controller = ref.read(libraryControllerProvider);
  try {
    await controller.loadAllTracks();
  } catch (e) {
    print('Error: $e');
  }
}
```

### Pattern 2: Auto-load with FutureProvider (alternative)
```dart
final tracksProvider = FutureProvider<List<Track>>((ref) async {
  final controller = ref.watch(libraryControllerProvider);
  await controller.loadAllTracks();
  return ref.watch(allTracksProvider);
});
```

### Pattern 3: Real-time Search
```dart
class SearchWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (query) {
        final controller = ref.read(libraryControllerProvider);
        if (query.isEmpty) {
          controller.clearSearch();
        } else {
          controller.searchTracks(query);
        }
      },
    );
  }
}
```

## Testing Examples

### Test Permission Service
```dart
test('requestMediaPermission returns true when granted', () async {
  final service = PermissionService();
  final result = await service.requestMediaPermission();
  expect(result, isTrue);
});
```

### Test Media Scanner
```dart
test('getAllTracks returns list of tracks', () async {
  final scanner = MediaScannerService();
  final tracks = await scanner.getAllTracks();
  expect(tracks, isNotEmpty);
  expect(tracks[0].title, isNotEmpty);
});
```

### Test Library Controller
```dart
test('loadLibrary loads all data', () async {
  final ref = ProviderContainer();
  final controller = ref.read(libraryControllerProvider);
  await controller.loadLibrary();
  
  expect(controller.getTrackCount(), greaterThan(0));
  expect(controller.getAlbumCount(), greaterThan(0));
});
```

## Next Phase: Permission Request UI

Phase 3, Step 3 will build UI on top of these components:
- Permission request screen
- Permission denied screen with settings button
- Loading screen while scanning
- Integration with app startup flow

## Debugging

### Enable Logging
All services use `AppLogger` which is configured in the project.

### Check Permission Status
```dart
final service = PermissionService();
final status = await service.getPermissionStatus();
print(status); // "Audio: granted, Storage: granted"
```

### Verify Library Initialization
```dart
final mediaLib = MediaLibraryService(...);
final initialized = await mediaLib.initialize();
final size = await mediaLib.getLibrarySize();
print('Library initialized: $initialized, Tracks: $size');
```

### Monitor State Changes
```dart
final controller = ref.read(libraryControllerProvider);
ref.listen(allTracksProvider, (previous, next) {
  print('Tracks changed: ${next.length}');
});
```

## Summary

Phase 3, Step 2 provides a complete media discovery system with:
- ✅ Permission management
- ✅ Media scanning (tracks, albums, artists)
- ✅ Search functionality
- ✅ Riverpod state integration
- ✅ Error handling
- ✅ Clean architecture

Ready to proceed to Phase 3, Step 3: Permission Request UI!

