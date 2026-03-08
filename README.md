# NASA APOD

Flutter app that consumes NASA's APOD API and shows a paginated feed of astronomy images and videos, with a details screen for each entry.

## Requirements

- Flutter SDK compatible with `sdk: ">=3.8.0 <4.0.0"`
- A NASA API key

## Configuration

The app reads its API configuration from `--dart-define` values:

- `apiKey`
- `baseUrl`

Example:

```bash
flutter run \
  --dart-define=apiKey=YOUR_API_KEY \
  --dart-define=baseUrl=https://api.nasa.gov/
```

If you use VS Code, a minimal `.vscode/launch.json` looks like this:

```json
{
  "configurations": [
    {
      "name": "Debug mode",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "args": [
        "--dart-define",
        "apiKey=YOUR_API_KEY",
        "--dart-define",
        "baseUrl=https://api.nasa.gov/"
      ]
    }
  ]
}
```

## Run

```bash
flutter pub get
flutter run --dart-define=apiKey=YOUR_API_KEY --dart-define=baseUrl=https://api.nasa.gov/
```

## Current Architecture

- `main.dart` bootstraps Flutter bindings, initializes GetIt, and launches the app.
- `src/core` contains shared infrastructure such as Dio setup, dependency injection, formatters, and custom exceptions.
- `src/data` contains remote and local data sources, DTO models, and the repository implementation.
- `src/domain` contains entities, pagination rules, and the use case.
- `src/presentation` contains the home feed, explicit `HomeState`, `HomeCubit`, and details UI.

## Current Behavior

- Home feed uses lazy rendering with slivers.
- APOD JSON parsing runs on a background isolate.
- Metadata is cached locally by pagination window.
- Images and videos are handled separately in the domain model.
- Details media is isolated in a dedicated widget to keep hero and loading behavior stable.

## Quality

- `flutter analyze` passes
- `flutter test` passes

## Main Dependencies

- `dio` `^5.9.0`
- `bloc` `^9.0.0`
- `flutter_bloc` `^9.0.0`
- `get_it` `^9.0.0`
- `equatable` `^2.0.8`
- `cached_network_image` `^3.4.1`
- `intl` `^0.20.0`
- `path_provider` `^2.1.5`
- `youtube_player_flutter` `^9.0.0`

## Notes

- The app expects valid `apiKey` and `baseUrl` values at startup.
- Local cache currently stores APOD metadata, not image bytes. Image bytes are still cached by `cached_network_image`.
