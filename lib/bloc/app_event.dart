import 'package:flutter/foundation.dart' show immutable;

// this is the actual event and other events will implemet this so when the bloc is called we can access other app events too

@immutable
abstract class AppEvent {
  const AppEvent();
}

// Here we write the events of the app like where on press of which button what action will be done and what page will do what thing

// This is the app event while the user will upload the image so it takes a string of the path of the file
@immutable
class AppEventUploadImage implements AppEvent {
  final String filePathToUpload;

  const AppEventUploadImage({
    required this.filePathToUpload,
  });
}

// This is the app event of deleting the user
@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

// This is the app event of log out of the user
@immutable
class AppEventLogOut implements AppEvent {
  const AppEventLogOut();
}

// This is needed when the user is login then it will directly go to the actual screen but if user is not login then it will open the login page

@immutable
class AppEventInitialize implements AppEvent {
  const AppEventInitialize();
}

// This is the event of log the user in by taking the string email and string password
@immutable
class AppEventLogin implements AppEvent {
  final String email;
  final String password;

  const AppEventLogin({
    required this.email,
    required this.password,
  });
}

// this is the event to go to the register view from the login view if the user is not logged in
@immutable
class AppEventGoToRegistration implements AppEvent {
  const AppEventGoToRegistration();
}

// This is the event to go to the login view from the register view if the user has done registration or already registered
@immutable
class AppEventGoToLogin implements AppEvent {
  const AppEventGoToLogin();
}

// This is the event of registering the user with string email and password
@immutable
class AppEventRegister implements AppEvent {
  final String email;
  final String password;

  const AppEventRegister({
    required this.email,
    required this.password,
  });
}
