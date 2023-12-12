import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-credential': AuthErrorInvalidCredentials(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'operation-not-allowed': AuthErrorOpperaionNotAllowed(),
  'requires-recent-login': AuthErrorRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnknown();
}

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogTitle: 'Authentication error',
          dialogText: 'Unknown authentication error',
        );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: 'No current user',
          dialogText: 'No current user with this information was found',
        );
}

@immutable
class AuthErrorRecentLogin extends AuthError {
  const AuthErrorRecentLogin()
      : super(
          dialogTitle: 'Requires recent login',
          dialogText:
              'You need to log out and log back in again in order to perferm this operation',
        );
}

@immutable
class AuthErrorOpperaionNotAllowed extends AuthError {
  const AuthErrorOpperaionNotAllowed()
      : super(
          dialogTitle: 'Opperaion not allowed',
          dialogText: 'You cannot register using this method at this moment',
        );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: 'User not found',
          dialogText: 'The given user is not found in the server',
        );
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogTitle: 'Weak password',
          dialogText:
              'Please provide a stronger password consisting of UpperCase letters and characters',
        );
}

@immutable
class AuthErrorInvalidCredentials extends AuthError {
  const AuthErrorInvalidCredentials()
      : super(
          dialogTitle: 'Invalid login credentials',
          dialogText: 'Please double check your email or password',
        );
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: 'Email already in use',
          dialogText: 'Please choose another email to register with',
        );
}
