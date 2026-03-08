# NASA APOD

Flutter app that consumes NASA's APOD API and presents a paginated feed of astronomy images and videos, with animated transitions into a richer details screen for each entry.

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
- `src/presentation` contains the home feed, explicit `HomeState`, `HomeCubit`, error panels, and details UI.

## Current Behavior

- Home feed uses lazy rendering with slivers.
- Home header expands to roughly one-third of the viewport and collapses on scroll.
- Feed items show date and media-type badges, and those badges participate in hero transitions to the details page.
- APOD JSON parsing runs on a background isolate.
- Metadata is cached locally by pagination window.
- Images and videos are handled separately in the domain model.
- Details media is isolated in a dedicated widget to keep hero and loading behavior stable.
- Details page uses a structured sliver layout with metadata chips and a dedicated reading section.
- Initial-load and pagination errors use a reusable alert-card layout.

## Key UX Decisions

- Image cards use smaller decoded thumbnails for smoother scrolling.
- The home pagination trigger is throttled to avoid repeated load-more calls near the end of the list.
- The details media area keeps stable geometry while loading to avoid layout shift.
- Local metadata cache stores APOD responses by pagination window, while image bytes are still handled by `cached_network_image`.

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
- Local cache stores APOD metadata, not image bytes. Image bytes are still cached by `cached_network_image`.
- For a deeper architecture walkthrough, see [docs/ARCHITECTURE.md](/Users/alencar/Projects/personal/nasa_apod/docs/ARCHITECTURE.md).
