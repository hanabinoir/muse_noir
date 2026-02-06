# State Management Pattern Guide

## Quick Reference

### Modern Pattern (Current Implementation)

#### Notifier Class
```dart
class MyNotifier extends Notifier<MyState> {
  late MyService _service;
  
  @override
  MyState build() {
    // Initialize dependencies here
    _service = ref.watch(myServiceProvider);
    return MyState.initial();
  }
  
  Future<void> myMethod() async {
    try {
      // Do work
      state = newState;
      AppLogger.info('Operation succeeded');
    } catch (e, st) {
      AppLogger.error('Error: $e', error: e, stackTrace: st);
      rethrow;
    }
  }
}

// Provider definition
final myProvider = NotifierProvider<MyNotifier, MyState>(() {
  return MyNotifier();
});
```

#### Usage in Widget
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    final notifier = ref.read(myProvider.notifier);
    
    return Column(
      children: [
        Text('Current state: $state'),
        ElevatedButton(
          onPressed: () => notifier.myMethod(),
          child: const Text('Do something'),
        ),
      ],
    );
  }
}
```

---

## Key Differences from Old Pattern

### Dependency Injection

**Old (Constructor-based)**:
```dart
class OldNotifier extends StateNotifier<State> {
  final MyService _service;
  
  OldNotifier(this._service) : super(State.initial());
}

// Provider
final provider = StateNotifierProvider((ref) {
  final service = ref.watch(myServiceProvider);
  return OldNotifier(service);
});
```

**New (build-method based)**:
```dart
class NewNotifier extends Notifier<State> {
  late MyService _service;
  
  @override
  State build() {
    _service = ref.watch(myServiceProvider);
    return State.initial();
  }
}

// Provider
final provider = NotifierProvider(() {
  return NewNotifier();
});
```

### Benefits
✅ Automatic dependency tracking
✅ Better lifecycle management
✅ Simpler provider definitions
✅ Improved performance
✅ Easier testing

---

## Common Patterns

### 1. Simple State Updates
```dart
void updateState(NewState newState) {
  state = newState;
  AppLogger.debug('State updated');
}
```

### 2. Async Operations with Error Handling
```dart
Future<void> fetchData() async {
  try {
    state = await _service.getData();
    AppLogger.info('Data fetched successfully');
  } catch (e, st) {
    AppLogger.error('Error fetching data: $e', error: e, stackTrace: st);
    rethrow;
  }
}
```

### 3. Conditional State Updates
```dart
Future<bool> performAction() async {
  try {
    if (state.isValid) {
      await _service.doSomething();
      state = state.copyWith(status: Status.success);
      AppLogger.info('Action completed');
      return true;
    } else {
      AppLogger.warning('Invalid state for action');
      return false;
    }
  } catch (e, st) {
    AppLogger.error('Error: $e', error: e, stackTrace: st);
    return false;
  }
}
```

### 4. Watching Multiple Providers
```dart
@override
MyState build() {
  final service1 = ref.watch(service1Provider);
  final service2 = ref.watch(service2Provider);
  final config = ref.watch(configProvider);
  
  // Initialize based on multiple dependencies
  return MyState(service1, service2, config);
}
```

---

## Modules Using This Pattern

### Permissions Module
- **Notifier**: `PermissionNotifier`
- **Provider**: `permissionStatusProvider`
- **File**: `lib/features/permissions/state/`

### Library Module
- **Notifiers**: 
  - `LibraryNotifier` (tracks)
  - `AlbumNotifier` (albums)
  - `ArtistNotifier` (artists)
  - `SearchNotifier` (search)
- **File**: `lib/features/library/state/`

### Player Module
- **Notifiers**:
  - `CurrentTrackNotifier`
  - `PlaylistNotifier`
  - `LoopModeNotifier`
  - `ShuffleModeNotifier`
  - `PlaybackSpeedNotifier`
- **File**: `lib/features/player/state/audio_state.dart`

---

## Do's and Don'ts

### ✅ DO
- Use `build()` for dependency initialization
- Use `ref.watch()` for reactive dependencies
- Use `ref.read()` for one-time access
- Add proper error handling
- Log operations for debugging
- Use `AppLogger` consistently

### ❌ DON'T
- Initialize dependencies in constructor
- Call `ref.watch()` outside of `build()`
- Forget to handle errors
- Leave silent failures
- Mix logging approaches
- Create manual service instances

---

## Testing Example

```dart
test('MyNotifier updates state correctly', () async {
  final container = ProviderContainer();
  final notifier = container.read(myProvider.notifier);
  
  // Initial state
  expect(container.read(myProvider), equals(MyState.initial()));
  
  // After method call
  await notifier.myMethod();
  expect(container.read(myProvider), equals(expectedState));
});
```

---

## Resources

- [Riverpod Documentation](https://riverpod.dev)
- [Notifier vs StateNotifier](https://riverpod.dev/docs/migration/migration_v2)
- [State Notifiers](https://riverpod.dev/docs/basics/defining_a_notifier)

