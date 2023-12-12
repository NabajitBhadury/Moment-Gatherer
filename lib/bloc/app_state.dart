import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:memory_collector/auth/auth_error.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
    this.authError,
  });
}

// The AppStateLoggedIn when the user is logged in has some initial stuffs like the user of whom the images will be shown and the images so it is extending the AppState class
@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;
  // ignore: use_super_parameters
  const AppStateLoggedIn({
    required this.user,
    required this.images,
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

// Here this is done due to the reason when a new image is uploaded then the app state needs to be updated to load the new image each time so we need the equality of the previous app state and the current app state
  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        user.uid,
        images,
      );

  @override
  String toString() => 'AppStateLoggedIn, images.length = ${images.length}';
}

// The AppStateLoggedOut when the user is logged out has no initial stuffs so it is just extending the AppState class
@immutable
class AppStateLoggedOut extends AppState {
  // ignore: use_super_parameters
  const AppStateLoggedOut({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  String toString() =>
      'AppStateLoggedOut, isLoading = $isLoading, authError = $authError';
}

// The AppStateIsInRegistrationView when the user is registration view and has no initial stuffs so it is also just extending the AppState class
@immutable
class AppStateIsInRegistrationView extends AppState {
  // ignore: use_super_parameters
  const AppStateIsInRegistrationView({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );
}

@immutable
class AppStateIsInLoginView extends AppState {
  // ignore: use_super_parameters
  const AppStateIsInLoginView({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );
}

// Now we need to extract the user out of the AppStateLoggedIn using an extension as it is the only instance of the AppState where there is the user present
extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

// In the same way as we did in the previous one we need to extract the images out of the AppStateLoggedIn
extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
