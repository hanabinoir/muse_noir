# Phase 3, Step 2: Media Scanning Implementation

## Overview
Phase 3, Step 2 implements media discovery and scanning using the `on_audio_query` package and permission handling. This step creates the foundation for discovering music files on the device.

## Completed Components

### 1. Permission Service (`services/permissions/permission_service.dart`)
✅ Handles all permission-related operations
- `hasMediaPermission()` - Check if audio permission is granted
- `requestMediaPermission()` - Request READ_MEDIA_AUDIO permission
- `isMediaPermissionDenied()` - Check if permission is denied
- `isMediaPermissionPermanentlyDenied()` - Check if permanently denied
- `openAppSettings()` - Guide users to app settings
- `requestAllMediaPermissions()` - Request both audio and storage
- `hasAllMediaPermissions()` - Check all permissions
- `getPermissionStatus()` - Get status string for debugging

### 2. Media Scanner Service (`services/media/media_scanner.dart`)
✅ Scans device storage for media files
- `getAllTracks()` - Get all audio tracks
- `getAllAlbums()` - Get all albums
- `getAllArtists()` - Get all artists
- `getTracksForAlbum(albumId)` - Get tracks in an album
- `getTracksForArtist(artistId)` - Get tracks by an artist
- `searchTracks(query)` - Search across tracks, artists, albums
- `getTrackArtwork(trackId)` - Fetch track artwork
- `getAlbumArtwork(albumId)` - Fetch album artwork
- `getTrackCount()` - Get total track count

### 3. Local Media Data Source (`data/datasources/local_media_datasource.dart`)
✅ Data access layer for media queries
- Delegates to MediaScannerService
- Provides logging for debugging
- Consistent error handling

### 4. Media Repository Implementation (`data/repositories/media_repository.dart`)
✅ Data layer repository pattern
- Implements MediaRepository interface
- Uses LocalMediaDataSource
- Proper error handling and logging

### 5. Media Library Service (`services/media/media_library_service.dart`)
✅ High-level service for library initialization
- `initialize()` - Request permission and scan library
- `isInitialized` - Track initialization state
- `isPermissionPermanentlyDenied()` - Check if user denied permanently
- `requestPermission()` - Direct permission request
- `getLibrarySize()` - Get track count

### 6. Permission State Management (`features/permissions/state/`)
✅ Riverpod state for permissions
- `PermissionStatus` enum (notRequested, granted, denied, permanentlyDenied)
- `PermissionNotifier` - StateNotifier for permission state
  - `checkPermission()` - Check current status
  - `requestPermission()` - Request with state update
  - `openSettings()` - Open app settings
- `permission_providers.dart` - Riverpod providers

### 7. Library State Management (`features/library/state/`)
✅ Riverpod state for library browsing
- **LibraryNotifier** - Manages all tracks
  - `fetchAllTracks()` - Load all tracks
- **AlbumNotifier** - Manages albums
  - `fetchAllAlbums()` - Load all albums
- **ArtistNotifier** - Manages artists
  - `fetchAllArtists()` - Load all artists
- **SearchNotifier** - Manages search
  - `searchTracks(query)` - Search with state
  - `clearSearch()` - Clear results
- **library_providers.dart** - Riverpod providers:
  - `allTracksProvider` - All tracks state
  - `allAlbumsProvider` - All albums state
  - `allArtistsProvider` - All artists state
  - `searchProvider` - Search results state
  - `searchQueryProvider` - Search input state

### 8. Library Controller (`features/library/controller/library_controller.dart`)
✅ Controller for library operations
- `loadAllTracks()` - Load tracks
- `loadAllAlbums()` - Load albums
- `loadAllArtists()` - Load artists
- `loadLibrary()` - Load all in parallel
- `searchTracks(query)` - Perform search
- `clearSearch()` - Clear search
- `getTrackCount()` - Get track count
- `getAlbumCount()` - Get album count
- `getArtistCount()` - Get artist count
- `libraryControllerProvider` - Provider for controller

### 9. Domain Repository Update (`domain/repositories/media_repository.dart`)
✅ Updated interface with Phase 3 methods
- `getTracksForAlbum(String albumId)`
- `getTracksForArtist(String artistId)`
- `getTrackArtwork(int trackId)` - Optional artwork
- `getAlbumArtwork(int albumId)` - Optional artwork
- `getTrackCount()` - Library size

### 10. Core Providers Update (`core/providers/providers.dart`)
✅ Integrated Phase 3 services
- `permissionServiceProvider` - Permission service instance
- `mediaScannerProvider` - Media scanner instance
- `mediaLibraryServiceProvider` - Library initialization
- `localMediaDataSourceProvider` - Data source
- Updated `mediaRepositoryProvider` with implementation

## File Structure (Phase 3 Step 2)

```
lib/
├── services/
│   ├── permissions/
│   │   └── permission_service.dart ✅
│   └── media/
│       ├── media_scanner.dart ✅
│       └── media_library_service.dart ✅
├── data/
│   ├── datasources/
│   │   └── local_media_datasource.dart ✅
│   └── repositories/
│       └── media_repository.dart ✅ (impl)
├── domain/
│   └── repositories/
│       └── media_repository.dart ✅ (updated interface)
└── features/
    ├── library/
    │   ├── state/
    │   │   ├── library_state.dart ✅
    │   │   └── library_providers.dart ✅
    │   └── controller/
    │       └── library_controller.dart ✅
    └── permissions/
        └── state/
            ├── permission_state.dart ✅
            └── permission_providers.dart ✅
```

## Architecture Overview

```
UI Layer (Future)
    ↓
Library Controller (features/library/controller/)
    ↓ (manages)
Library State (StateNotifier)
    ↓ (calls)
Use Cases (domain/usecases/)
    ↓ (uses)
Media Repository (data/repositories/)
    ↓ (uses)
Local Media Data Source (data/datasources/)
    ↓ (uses)
Media Scanner Service (services/media/)
    ↓ (uses)
on_audio_query (external package)
    ↓
Device MediaStore
```

## Integration Points

### With Phase 2 (Audio Playback)
- Can now provide actual tracks to play
- Track entities from media scanner integrate with player
- Track metadata available for display

### With Future Phases
- **Phase 4 (Persistence)**: Playlist repository will use similar patterns
- **Phase 5 (UI)**: Controllers provide data to screens
- **Phase 6 (Background)**: MediaLibraryService handles initialization

## Usage Example (Will be used in UI)

```dart
// In a widget/screen
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(libraryControllerProvider);
    
    // Initialize library on first load
    useEffect(() {
      controller.loadLibrary();
      return null;
    }, []);
    
    // Get all tracks
    final tracks = ref.watch(allTracksProvider);
    
    // Search
    controller.searchTracks('query');
    
    // Get counts
    final trackCount = controller.getTrackCount();
    
    return YourWidget(tracks: tracks);
  }
}
```

## Permissions Workflow

```
1. App starts
2. Check permission status (PermissionNotifier.checkPermission)
3. If not granted, show permission screen
4. User grants permission
5. MediaLibraryService.initialize() called
6. Media scanner queries device
7. Tracks/Albums/Artists loaded into providers
8. UI displays library
```

## Key Design Decisions

### 1. StateNotifier Pattern
- Used for mutable state (tracks, albums, search results)
- Provides update methods like `fetchAllTracks()`
- Automatically triggers UI rebuilds

### 2. Separation of Concerns
- **Services**: Low-level operations (permissions, scanning)
- **DataSources**: Data access layer
- **Repositories**: Business logic layer
- **UseCases**: High-level operations
- **Controllers**: UI coordination
- **StateNotifiers**: State management

### 3. Error Handling
- Custom exceptions (PermissionException, MediaScanException)
- Logging at each layer
- Graceful fallbacks

### 4. Performance
- Queries sorted by display name
- Support for incremental loading (future enhancement)
- Artwork fetched on-demand
- Caching support through repository pattern

## Testing Strategy

### Unit Tests (for Phase 3 Step 2)
```dart
test('PermissionService requests permission correctly')
test('MediaScannerService queries all tracks')
test('LibraryNotifier fetches and updates state')
test('LibraryController loads library in parallel')
test('SearchNotifier filters tracks correctly')
```

### Widget Tests (for Phase 5+)
- Permission request dialog
- Library screen displays tracks
- Search functionality
- Loading states

## Next Steps (Phase 3, Step 3)

The next step is creating the Permission Request UI Flow:
- Permission request screen/dialog
- Handle permission denials
- Guide users to app settings
- Integrate with app startup flow

## Known Limitations & Future Enhancements

### Current Limitations
1. No incremental scanning (full scan each time)
2. Artwork is loaded on-demand (could be pre-cached)
3. Search is client-side filtering (not indexed)
4. No support for playlists from device

### Future Enhancements
1. Implement incremental media scanning for updates
2. Cache artwork in Hive
3. Implement full-text search indexing
4. Support parsing M3U playlists
5. Add file watch for real-time updates
6. Implement smart caching strategies

## Debugging Tips

### Check Permission Status
```dart
final permService = ref.read(permissionServiceProvider);
final status = await permService.getPermissionStatus();
print(status); // "Audio: granted, Storage: granted"
```

### Check Media Scanner
```dart
final scanner = ref.read(mediaScannerProvider);
final count = await scanner.getTrackCount();
print('Total tracks: $count');
```

### Monitor Library Loading
```dart
final controller = ref.read(libraryControllerProvider);
await controller.loadLibrary();
final tracks = ref.read(allTracksProvider);
print('Loaded ${tracks.length} tracks');
```

## Conclusion

Phase 3, Step 2 is now complete with full media scanning capabilities. The architecture supports:
- ✅ Permission handling
- ✅ Media discovery
- ✅ Track/Album/Artist browsing
- ✅ Search functionality
- ✅ Riverpod state management
- ✅ Clean architecture patterns
- ✅ Error handling and logging

Ready to proceed to Phase 3, Step 3 (Permissions UI Framework).

