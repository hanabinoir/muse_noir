# Muse Noir - Flutter Music Player Implementation Plan

## Project Overview
**Name:** Muse Noir  
**Type:** Android Music Player Application  
**Architecture:** Layered Architecture + Feature-first with Riverpod state management  
**Target:** Local music playback with playlist management and dark mode support

---

## Implementation Roadmap (Recommended Order)

### Phase 1: Foundation & Core Infrastructure
- [ ] Project structure setup (core, features, data, domain, services layers)
- [ ] Riverpod state management setup
- [ ] Error handling & logging infrastructure
- [ ] Constants & utilities

### Phase 2: Audio Playback Engine
**Step 1: Audio Playback (just_audio)**
- [ ] Create `services/audio/audio_service.dart`
  - Initialize just_audio AudioPlayer
  - Implement play, pause, stop, seek functionality
  - Handle AudioPlayer state streams
  - Error handling for audio operations
- [ ] Create audio state management with Riverpod
  - `features/player/state/audio_state.dart`
  - Current track provider
  - Playback state provider (playing, paused, stopped)
  - Duration & position providers
- [ ] Create domain entities
  - `domain/entities/track.dart`
  - `domain/entities/album.dart`
  - `domain/entities/artist.dart`
  - `domain/entities/playlist.dart`

### Phase 3: Media Discovery & Permissions
**Step 2: Media Scanning (on_audio_query)**
- [ ] Implement permission handling
  - `services/permissions/permission_service.dart`
  - Request READ_EXTERNAL_STORAGE / READ_MEDIA_AUDIO
  - Handle permission states and callbacks
- [ ] Create MediaStore scanner
  - `services/media/media_scanner.dart`
  - Query tracks from Music/ directory
  - Support both .mp3 and .flac formats
  - Handle directory structures: `[track].mp3` and `[artist]/[album]/[track].flac`
- [ ] Create media datasources
  - `data/datasources/local_media_datasource.dart`
  - Query all tracks, albums, artists
  - Cache results efficiently
- [ ] Create media repository
  - `data/repositories/media_repository.dart`
  - Repository pattern implementation
- [ ] Create domain repository interface
  - `domain/repositories/media_repository.dart`
- [ ] Create usecases
  - `domain/usecases/get_all_tracks_usecase.dart`
  - `domain/usecases/get_all_albums_usecase.dart`
  - `domain/usecases/get_all_artists_usecase.dart`
  - `domain/usecases/search_tracks_usecase.dart`

**Step 3: Permissions Framework**
- [ ] Create permission request UI flow
  - Permission request screen/dialog
  - Handle permission denials
  - Guide users to settings if necessary
- [ ] Integrate with app startup
  - Check permissions on app launch
  - Show permission screen if needed

### Phase 4: Data Persistence
**Step 4: Playlist Persistence (Hive)**
- [ ] Setup Hive database
  - `services/storage/hive_service.dart`
  - Initialize Hive boxes for playlists and favorites
- [ ] Create Hive models
  - `data/models/playlist_model.dart`
  - `data/models/track_model.dart` (for storage)
- [ ] Create playlist datasource
  - `data/datasources/playlist_datasource.dart`
  - CRUD operations for playlists
  - Save/load playlists from Hive
- [ ] Create playlist repository
  - `data/repositories/playlist_repository.dart`
- [ ] Create playlist usecases
  - `domain/usecases/create_playlist_usecase.dart`
  - `domain/usecases/get_all_playlists_usecase.dart`
  - `domain/usecases/add_track_to_playlist_usecase.dart`
  - `domain/usecases/remove_track_from_playlist_usecase.dart`
  - `domain/usecases/delete_playlist_usecase.dart`
- [ ] Create playlist state management
  - `features/playlist/state/playlist_state.dart`
  - Provider for all playlists
  - Provider for current playlist
  - Provider for favorites

### Phase 5: User Interface & Theme
**Step 5: Dark Mode & UI Framework**
- [ ] Setup theme system with flex_color_scheme
  - `core/theme/app_theme.dart`
  - Light and dark theme definitions
  - Color palette for Muse Noir branding
- [ ] Create theme provider
  - `features/settings/state/theme_state.dart`
  - Toggle between light/dark mode
  - Persist theme preference with Hive
- [ ] Create base UI components
  - `core/widgets/base_scaffold.dart`
  - `core/widgets/custom_app_bar.dart`
  - `core/widgets/loading_indicator.dart`
  - `core/widgets/error_widget.dart`
- [ ] Implement player UI screens
  - `features/player/presentation/screens/player_screen.dart`
    - Album art display
    - Track info (title, artist, album)
    - Progress bar (using audio_video_progress_bar)
    - Play/pause/previous/next controls
    - Current time and duration
  - `features/player/presentation/screens/now_playing_screen.dart` (full-screen variant)
- [ ] Implement library UI screens
  - `features/library/presentation/screens/tracks_screen.dart`
  - `features/library/presentation/screens/albums_screen.dart`
  - `features/library/presentation/screens/artists_screen.dart`
  - `features/library/presentation/screens/search_screen.dart`
- [ ] Implement playlist UI screens
  - `features/playlist/presentation/screens/playlists_screen.dart`
  - `features/playlist/presentation/screens/playlist_detail_screen.dart`
  - `features/playlist/presentation/screens/create_playlist_screen.dart`
- [ ] Implement settings UI screen
  - `features/settings/presentation/screens/settings_screen.dart`
  - Theme toggle
  - About section

### Phase 6: Advanced Features
**Step 6: Background Playback & Notifications**
- [ ] Setup background audio service
  - `services/audio/background_audio_service.dart`
  - Keep audio playing when app is in background
  - Integrate with just_audio_background
- [ ] Implement system notifications
  - `services/notifications/notification_service.dart`
  - Show current track information
  - Play/pause/skip controls in notification
  - Album art in notification
  - Handle notification taps
- [ ] Implement audio focus handling
  - Handle other apps' audio (reduce volume, pause, etc.)
  - Resume playback when appropriate
- [ ] Create background state management
  - `features/player/state/background_state.dart`
  - Track background playback state

### Phase 7: Integration & Polish
- [ ] Create main.dart and app.dart
  - Setup Riverpod ProviderContainer
  - Initialize Hive
  - Setup error handling
  - Configure logging
- [ ] Create navigation structure
  - `core/navigation/app_router.dart`
  - Named routes for all screens
  - Deep link support
- [ ] Create controller layer
  - `features/player/controller/player_controller.dart`
  - `features/library/controller/library_controller.dart`
  - `features/playlist/controller/playlist_controller.dart`
  - `features/settings/controller/settings_controller.dart`
- [ ] Home screen / Main UI
  - `features/player/presentation/screens/home_screen.dart`
  - Bottom navigation or tab-based layout
  - Mini player at bottom
- [ ] Testing setup
  - Unit tests for services and repositories
  - Widget tests for UI screens
  - Integration tests for workflows
- [ ] Debugging & refinement
  - Error logging and reporting
  - Performance monitoring
  - User feedback mechanisms

---

## File Structure (After Implementation)

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── duration_constants.dart
│   │   └── string_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   ├── utils/
│   │   ├── duration_formatter.dart
│   │   ├── file_utils.dart
│   │   └── logger.dart
│   ├── errors/
│   │   ├── app_exception.dart
│   │   └── error_handler.dart
│   ├── extensions/
│   │   ├── duration_extension.dart
│   │   ├── string_extension.dart
│   │   └── context_extension.dart
│   └── widgets/
│       ├── base_scaffold.dart
│       ├── custom_app_bar.dart
│       ├── loading_indicator.dart
│       └── error_widget.dart
├── features/
│   ├── player/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── player_screen.dart
│   │   │   │   ├── now_playing_screen.dart
│   │   │   │   └── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── progress_bar_widget.dart
│   │   │       ├── player_controls.dart
│   │   │       ├── track_info_widget.dart
│   │   │       └── mini_player.dart
│   │   ├── controller/
│   │   │   └── player_controller.dart
│   │   └── state/
│   │       ├── audio_state.dart
│   │       └── background_state.dart
│   ├── library/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── tracks_screen.dart
│   │   │   │   ├── albums_screen.dart
│   │   │   │   ├── artists_screen.dart
│   │   │   │   └── search_screen.dart
│   │   │   └── widgets/
│   │   │       ├── track_tile.dart
│   │   │       ├── album_card.dart
│   │   │       └── artist_card.dart
│   │   ├── controller/
│   │   │   └── library_controller.dart
│   │   └── state/
│   │       └── library_state.dart
│   ├── playlist/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── playlists_screen.dart
│   │   │   │   ├── playlist_detail_screen.dart
│   │   │   │   └── create_playlist_screen.dart
│   │   │   └── widgets/
│   │   │       ├── playlist_card.dart
│   │   │       └── playlist_track_tile.dart
│   │   ├── controller/
│   │   │   └── playlist_controller.dart
│   │   └── state/
│   │       ├── playlist_state.dart
│   │       └── favorites_state.dart
│   └── settings/
│       ├── presentation/
│       │   ├── screens/
│       │   │   └── settings_screen.dart
│       │   └── widgets/
│       │       └── theme_toggle.dart
│       ├── controller/
│       │   └── settings_controller.dart
│       └── state/
│           └── theme_state.dart
├── data/
│   ├── datasources/
│   │   ├── local_media_datasource.dart
│   │   └── playlist_datasource.dart
│   ├── models/
│   │   ├── track_model.dart
│   │   ├── album_model.dart
│   │   ├── artist_model.dart
│   │   └── playlist_model.dart
│   └── repositories/
│       ├── media_repository.dart
│       └── playlist_repository.dart
├── domain/
│   ├── entities/
│   │   ├── track.dart
│   │   ├── album.dart
│   │   ├── artist.dart
│   │   └── playlist.dart
│   ├── repositories/
│   │   ├── media_repository.dart
│   │   └── playlist_repository.dart
│   └── usecases/
│       ├── get_all_tracks_usecase.dart
│       ├── get_all_albums_usecase.dart
│       ├── get_all_artists_usecase.dart
│       ├── search_tracks_usecase.dart
│       ├── create_playlist_usecase.dart
│       ├── get_all_playlists_usecase.dart
│       ├── add_track_to_playlist_usecase.dart
│       ├── remove_track_from_playlist_usecase.dart
│       └── delete_playlist_usecase.dart
└── services/
    ├── audio/
    │   ├── audio_service.dart
    │   └── background_audio_service.dart
    ├── media/
    │   └── media_scanner.dart
    ├── permissions/
    │   └── permission_service.dart
    ├── storage/
    │   └── hive_service.dart
    └── notifications/
        └── notification_service.dart
```

---

## Dependencies Already Included

- **just_audio**: ^0.10.5 - Audio playback engine
- **just_audio_background**: ^0.0.1-beta.17 - Background audio support
- **on_audio_query**: ^2.9.0 - MediaStore queries
- **permission_handler**: ^12.0.1 - Permission management
- **hive**: ^2.2.3 - Local database
- **hive_flutter**: ^1.1.0 - Hive Flutter integration
- **riverpod**: ^3.2.1 - State management
- **audio_video_progress_bar**: ^2.0.3 - UI progress bar
- **cached_network_image**: ^3.4.1 - Image caching (for album art)
- **flex_color_scheme**: ^8.4.0 - Theme system
- **animations**: ^2.1.1 - UI animations

---

## Android Configuration Requirements

### AndroidManifest.xml Updates Needed
- READ_EXTERNAL_STORAGE (Android < 13)
- READ_MEDIA_AUDIO (Android 13+)
- FOREGROUND_SERVICE (for background playback)
- WAKE_LOCK (to keep audio playing)

### Android Build Configuration
- minSdk: Ensure compatibility with permission model
- targetSdk: 34 or higher recommended
- Kotlin version: ^1.8.0

---

## iOS Configuration Requirements (Optional)

### Info.plist Updates
- NSAppleMusicUsageDescription
- NSLocalNetworkUsageDescription
- NSBonjourServiceTypes

---

## Data Model: Track File Structure

### Supported Formats
1. **Flat Structure**: `Music/[track].mp3`
2. **Nested Structure**: `Music/[artist]/[album]/[track].flac`

### Implementation Considerations
- Parse file metadata using on_audio_query
- Handle missing metadata gracefully
- Build album/artist aggregates from tracks
- Cache results in Hive for performance

---

## State Management Strategy (Riverpod)

### Core Providers
- **audioPlayerProvider**: Manages just_audio AudioPlayer instance
- **currentTrackProvider**: Current playing track
- **playbackStateProvider**: Current playback state
- **tracksProvider**: All available tracks
- **albumsProvider**: All albums
- **artistsProvider**: All artists
- **playlistsProvider**: User's playlists
- **favoritesProvider**: Favorite tracks
- **themeProvider**: Current theme setting

### Controller Layer
- Controllers manage complex interactions
- Consume multiple providers
- Handle business logic
- Expose simplified APIs to UI

---

## UI/UX Design Notes

### Color Scheme (Dark Theme First)
- Primary: Deep purple/noir colors
- Accent: Vibrant accent for interactive elements
- Background: Dark with subtle gradients
- Text: High contrast white/light gray

### Key Screens
1. **Home/Player Screen**: Now playing with controls
2. **Library Tabs**: Tracks, Albums, Artists
3. **Playlist Management**: Create, edit, delete
4. **Search**: Cross-library search
5. **Settings**: Theme, about, help

### Micro-interactions
- Smooth transitions between screens
- Album art fade-in with cached_network_image
- Progress bar scrubbing feedback
- Animation when track changes
- Haptic feedback on button presses

---

## Performance Optimization Strategies

### Media Scanning
- Cache results in Hive
- Implement incremental scanning for updates
- Lazy-load album art
- Use indexed queries for search

### Audio Playback
- Pre-load next track metadata
- Implement efficient queue management
- Use audio focus for competing audio apps
- Stream audio buffer efficiently

### UI Rendering
- Use const constructors where possible
- Implement list virtualization for long lists
- Lazy-load screens in tab navigation
- Optimize rebuild triggers with Riverpod

---

## Testing Strategy

### Unit Tests
- Audio service methods
- Repository implementations
- Usecase logic
- Data model conversions

### Widget Tests
- Player controls functionality
- Navigation between screens
- Theme application
- Permission dialogs

### Integration Tests
- End-to-end playback flow
- Playlist creation and management
- Settings persistence
- Background audio

---

## Future Enhancements (Not in MVP)

- Lyrics display
- Audio equalizer
- Streaming service integration (Spotify, YouTube Music)
- Audio visualization
- Sync with cloud storage
- Social features (sharing playlists)
- Widget for lock screen
- Voice command support
- Sleep timer

---

## Development Environment Setup

### Tools Required
- Flutter SDK (3.10.4 or higher)
- Dart 3.10.4 or higher
- Android SDK with API 34+
- Gradle 8.x

### Development Workflow
1. Create feature branches for each phase
2. Test on physical Android device
3. Monitor background audio behavior
4. Profile media scanning performance
5. Test permission flows on different Android versions

---

## Risk Mitigation

### Known Challenges
1. **Media Scanning Performance**: Large music libraries may take time to scan
   - Mitigation: Implement caching and incremental updates
2. **Permission Handling**: Different behavior on Android 6-12 vs 13+
   - Mitigation: Test on multiple API levels
3. **Background Playback**: May stop on some devices with battery optimization
   - Mitigation: Use just_audio_background properly, guide users on battery settings
4. **File Format Support**: FLAC support varies by device
   - Mitigation: Test on target devices, provide fallback error messages

---

## Success Criteria

- [ ] Music playback works for MP3 and FLAC files
- [ ] All tracks from Music/ directory discovered automatically
- [ ] Playlists created and persisted correctly
- [ ] Dark theme applied consistently across app
- [ ] Background audio continues when app minimized
- [ ] Notifications show current track with controls
- [ ] Permissions requested appropriately
- [ ] No crashes or memory leaks in normal usage
- [ ] Smooth 60fps UI performance

---

## Timeline Estimation

- Phase 1 (Foundation): 2-3 days
- Phase 2 (Audio & Entities): 3-4 days
- Phase 3 (Media & Permissions): 4-5 days
- Phase 4 (Persistence): 2-3 days
- Phase 5 (UI & Theme): 5-7 days
- Phase 6 (Background & Notifications): 3-4 days
- Phase 7 (Integration & Polish): 3-4 days

**Total Estimated Time**: 22-30 days (aggressive implementation)

---

## Notes for Implementation

- Follow the architecture document strictly
- Use consistent naming conventions across layers
- Implement error handling at each layer
- Add logging for debugging
- Keep UI separated from business logic
- Test each feature independently
- Document public APIs
- Handle edge cases (empty library, no permissions, etc.)

