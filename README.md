# Flutter Nasa APOD Api

A Project who will consume the Nasa Apod API, to retrieve images of space with a description of each image.

## Getting Started

### FLutter
This project is a Flutter application, to run this application you need to have flutter installed on your machine, we made this project using flutter v3.13.1.

If you want to install flutter, you can use [this oficial guide](https://docs.flutter.dev/get-started/install)

### Configuring project

When your flutter instalation is ready to use, you can follow the sptes below.

To run this project you will need an API_KEY, you can get your own accessing: [Nasa Apod API](https://api.nasa.gov), click Browse APIs and check APOD

If you are using the VSCode to code, you will need to create a `.vscode/launch.json` file, with this code, substituting YOUR_API_KEY, by the key generated on the step above :

```
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
            ],
        },
    ],
}
```

After create and configure this file, you will need to run a command in your terminal at the project home:
```
flutter pub get
```
after this you can run your project!
