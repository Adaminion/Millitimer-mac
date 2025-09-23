# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Millitimer is a high-speed camera test Flutter application designed to verify camera consistency by displaying a millisecond timer with analysis features. The app shows a high-precision timer (MM:SS:MMM format), a progress bar representing milliseconds, lap time recording, and customizable display options.

## Key Features to Implement

Based on the blueprint in `high_speed_timer_blueprint.txt`:

1. **High-precision timer** with MM:SS:MMM format
2. **Progress bar** (1000px wide) that advances pixel-per-millisecond
3. **Lap time recording** with list display
4. **Start delay feature** (countdown from negative values)
5. **Customizable display** (fonts, colors, positions)
6. **JSON persistence** for settings and lap history
7. **Custom text labels** with positioning options

## Development Commands

```bash
# Run the app in debug mode
flutter run

# Run on specific device
flutter run -d chrome    # Web
flutter run -d macos     # macOS desktop
flutter run -d windows   # Windows desktop
flutter run -d linux     # Linux desktop

# Build release versions
flutter build web
flutter build macos
flutter build windows
flutter build linux
flutter build apk        # Android
flutter build ios        # iOS (requires macOS)

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .

# Get dependencies
flutter pub get

# Clean build artifacts
flutter clean
```

## Architecture Considerations

### Timer Implementation
- Use `Stopwatch` class for high-precision timing
- Implement `TickerProviderStateMixin` for frame-synced updates
- Consider using `Timer.periodic` with microsecond precision for millisecond accuracy

### State Management
- Current setup uses basic StatefulWidget
- For this app's complexity, consider:
  - Provider or Riverpod for settings management
  - Local state for timer and laps

### Persistence
- Use `path_provider` package to get appropriate directory
- Store settings in JSON format using `dart:convert`
- Consider `shared_preferences` for simple key-value storage

### UI Structure
- Main timer screen with customizable layout
- Settings screen/dialog for customization options
- Lap times as scrollable list widget

### Platform Considerations
- App targets desktop primarily (as mentioned in blueprint)
- Ensure fixed 1000px progress bar renders correctly on all platforms
- Test high-frequency updates on different platforms

## Testing Strategy

- Widget tests for UI components
- Unit tests for timer logic and lap calculations
- Integration tests for settings persistence
- Performance testing for timer accuracy

## Important Implementation Notes

1. The progress bar must be exactly 1000 pixels wide to represent 1000ms
2. Timer should handle negative values for start delay feature
3. All customization options must persist through app restarts
4. Focus on desktop platforms but maintain mobile compatibility