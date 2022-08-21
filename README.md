# Simple Shop

The application as name suggest is a simple shop. Data is kept on Firebase Realtime database, account management is possible thanks to Firebes Authentication
and this functionalities are connecting with application by HTTP requests. Additionally, the auto-login system was created with the help of shered preferences. 

## Screenshots

![Screenshots](./screens/sm-screens.gif)

## Development

project uses couple dependecys like:
- [provider](https://pub.dev/packages/provider)
- [http](https://pub.dev/packages/http)
- [shared_preferences](https://pub.dev/packages/shared_preferences)

Full dependency list as usual in pubspec.yaml file.

## How to run

Application was designed for android devices (smartphone), IOS was not tested.
I assume that You allready have Flutter SDK and Android virtual device installed. Aditionally You need to create a new project on Firebase platform with Realtime database and Authentication included. While creating the Firebase project You will be asked for couple changes in android's and IOS's files. All will be covered by Google Firebase documentation.

To run application:

- Download repository ZIP file or if You have Git clone repository to Your hard drive.
- Run Android virtual device.
- Copy Your Web API Key and paste it in to constant named "apiKey" in the projects directory (./lib/providers/auth.dart).
- Change applicationId in ./android/app/src/build.gradle file to Your own aplicationId (all this steps are provided by Google at project creation)
- Open CMD and navigate to repository location.
- In command line type "flutter run" - if your virtual device is detected, flutter will automatically launch the application on the device.
