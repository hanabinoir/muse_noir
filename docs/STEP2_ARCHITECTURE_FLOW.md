# Step 2 - Architecture & Data Flow

## Complete Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         UI Layer                                │
│  (Screens & Widgets - Phase 3)                                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌─────────────────────────────▼────────────────────────────────────┐
│                    Controllers Layer                            │
│  • LibraryController                                            │
│  • PlayerController                                             │
│  └─ Uses: Ref to access providers                              │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌─────────────────────────────▼────────────────────────────────────┐
│                State Management (Riverpod)                      │
│  • Notifiers (LibraryNotifier, PlayerNotifier, etc)            │
│  • Providers (allTracksProvider, playlistProvider, etc)        │
│  └─ Uses: Usecases via ref.watch()                             │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌─────────────────────────────▼────────────────────────────────────┐
│                       Usecases Layer                            │
│  • GetAllTracksUseCase                                          │
│  • GetAllAlbumsUseCase                                          │
│  • GetAllArtistsUseCase                                         │
│  • SearchTracksUseCase                                          │
│  └─ Uses: Repository.call()                                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌─────────────────────────────▼────────────────────────────────────┐
│                    Repository Layer                             │
│  (MediaRepositoryImpl)                                           │
│  ├─ getAllTracks()                                             │
│  ├─ getAllAlbums()                                             │
│  ├─ getAllArtists()                                            │
│  ├─ getTracksForAlbum()                                        │
│  ├─ getTracksForArtist()                                       │
│  ├─ searchTracks()                                             │
│  ├─ getTrackArtwork()                                          │
│  ├─ getAlbumArtwork()                                          │
│  └─ getTrackCount()                                            │
│  └─ Uses: LocalMediaDataSource                                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌─────────────────────────────▼────────────────────────────────────┐
│                  Datasource Layer                               │
│  (LocalMediaDataSource)                                         │
│  └─ Wraps MediaScannerService                                  │
│  └─ Adds logging at datasource level                           │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌─────────────────────────────▼────────────────────────────────────┐
│                     Services Layer                              │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ PermissionService                                          │ │
│  │ • hasMediaPermission()                                     │ │
│  │ • requestMediaPermission()                                 │ │
│  │ • isMediaPermissionPermanentlyDenied()                     │ │
│  │ └─ Uses: permission_handler plugin                         │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ MediaScannerService                                        │ │
│  │ • getAllTracks()                                           │ │
│  │ • getAllAlbums()                                           │ │
│  │ • getAllArtists()                                          │ │
│  │ • getTracksForAlbum()                                      │ │
│  │ • getTracksForArtist()                                     │ │
│  │ • searchTracks()                                           │ │
│  │ • getTrackArtwork()                                        │ │
│  │ └─ Uses: on_audio_query plugin                             │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ MediaLibraryService                                        │ │
│  │ • initialize()                                             │ │
│  │ • Orchestrates Permission & Scanner                        │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ AudioService                                               │ │
│  │ • playTrack(), playPlaylist()                              │ │
│  │ • pause(), resume(), stop()                                │ │
│  │ • seek(), next(), previous()                               │ │
│  │ • setLoopMode(), setShuffleModeEnabled()                   │ │
│  │ • setSpeed(), initialize(), dispose()                      │ │
│  │ └─ Uses: just_audio plugin                                 │ │
│  └────────────────────────────────────────────────────────────┘ │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌─────────────────────────────▼────────────────────────────────────┐
│                 External Libraries                              │
│  • permission_handler - Permission management                  │
│  • on_audio_query - Media scanning (Android)                   │
│  • just_audio - Audio playback                                 │
│  • riverpod - State management                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Flow Examples

### Example 1: Load All Tracks

```
UI Component
  │
  └─> ref.read(libraryControllerProvider)
        │
        └─> LibraryController.loadAllTracks()
              │
              └─> ref.read(allTracksProvider.notifier).fetchAllTracks()
                    │
                    └─> LibraryNotifier.fetchAllTracks()
                          │
                          ├─> GetAllTracksUseCase.call()
                          │     │
                          │     └─> MediaRepository.getAllTracks()
                          │           │
                          │           └─> MediaRepositoryImpl.getAllTracks()
                          │                 │
                          │                 └─> LocalMediaDataSource.getAllTracks()
                          │                       │
                          │                       └─> MediaScannerService.getAllTracks()
                          │                             │
                          │                             └─> on_audio_query plugin
                          │
                          └─> Update state with List<Track>
                                │
                                └─> UI rebuilds with new tracks
```

### Example 2: Play a Track

```
UI Component
  │
  └─> ref.read(playerControllerProvider).playTrack(track)
        │
        └─> PlayerController.playTrack(track)
              │
              ├─> ref.read(currentTrackProvider.notifier).setCurrentTrack(track)
              │
              ├─> ref.read(playlistProvider.notifier).setPlaylist([track])
              │
              └─> audioService.playTrack(track)
                    │
                    └─> AudioService (just_audio) starts playback
                          │
                          └─> Emit playerStateStream events
                                │
                                └─> UI rebuilds with playback state
```

### Example 3: Search Tracks

```
UI Component (Search Input)
  │
  └─> ref.read(libraryControllerProvider).searchTracks(query)
        │
        └─> LibraryController.searchTracks(query)
              │
              ├─> Update searchQueryProvider with query
              │
              └─> ref.read(searchProvider.notifier).searchTracks(query)
                    │
                    └─> SearchNotifier.searchTracks(query)
                          │
                          ├─> SearchTracksUseCase.call(query)
                          │     │
                          │     └─> MediaRepository.searchTracks(query)
                          │           │
                          │           └─> MediaRepositoryImpl.searchTracks(query)
                          │                 │
                          │                 └─> LocalMediaDataSource.searchTracks(query)
                          │                       │
                          │                       └─> MediaScannerService.searchTracks(query)
                          │
                          └─> Update state with filtered List<Track>
                                │
                                └─> UI displays search results
```

---

## Error Handling Flow

```
Service Method (e.g., MediaScannerService.getAllTracks())
  │
  └─> try {
        ├─ Execute operation
        ├─ Log info: "Scanning for all tracks..."
        └─ Return results
      }
      catch (e) {
        ├─ Log error: "Error scanning tracks: $e"
        ├─ Throw custom exception (MediaScanException)
        │
        └─> DataSource catches (if needed)
              │
              └─> Repository catches
                    ├─ Log error
                    ├─ Return default/null (graceful fallback)
                    └─ OR rethrow
                          │
                          └─> Usecase doesn't catch (bubbles up)
                                │
                                └─> Notifier catches
                                      ├─ Log error
                                      └─ Notify user (UI error state)
```

---

## Logging Points

### Services Layer
```dart
_logger.info('Scanning for all tracks...');
_logger.error('Error scanning tracks: $e');
_logger.warning('No media permission, requesting...');
```

### Data Layer
```dart
_logger.info('LocalMediaDataSource: Fetching all tracks');
_logger.info('MediaRepositoryImpl: Getting all tracks');
_logger.error('Error getting all tracks: $e');
```

### State Management
```dart
AppLogger.info('Fetched ${state.length} tracks');
AppLogger.debug('Current track set: ${track?.title}');
AppLogger.error('Error fetching tracks: $e');
```

---

## Key Design Patterns

### 1. **Dependency Injection via Constructor**
```dart
class MediaRepositoryImpl implements MediaRepository {
  final LocalMediaDataSource _localMediaDataSource;
  
  MediaRepositoryImpl(this._localMediaDataSource);
}
```

### 2. **Dependency Injection via Riverpod**
```dart
class LibraryNotifier extends Notifier<List<Track>> {
  late GetAllTracksUseCase _getAllTracksUseCase;
  
  @override
  List<Track> build() {
    _getAllTracksUseCase = ref.watch(getAllTracksUsecaseProvider);
    return [];
  }
}
```

### 3. **Error Handling with Custom Exceptions**
```dart
try {
  // Operation
} catch (e) {
  throw MediaScanException(message: 'Failed to scan: $e');
}
```

### 4. **Static Logger Usage**
```dart
// Consistent across all files
AppLogger.info('Operation succeeded');
AppLogger.error('Operation failed: $e');
```

---

## Thread Safety & Async Handling

All media operations are async:
- Permission checks are async
- Media scanning is async
- Audio playback is async
- All properly awaited in notifiers

---

## Performance Optimizations

1. **Service Caching**: Services are singletons (created once)
2. **Stream-based**: AudioService uses reactive streams
3. **Lazy Loading**: Usecases only call methods when needed
4. **Error Defaults**: Graceful fallbacks prevent crashes

---

## Security Considerations

1. **Permission Checking**: All media access requires permission
2. **Error Transparency**: Errors logged but don't expose internals
3. **Graceful Degradation**: App continues on permission denial

---

**This completes the Step 2 - Media Scanning layer!** ✅

