import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memory_collector/auth/auth_error.dart';
import 'package:memory_collector/bloc/app_event.dart';
import 'package:memory_collector/bloc/app_state.dart';
import 'package:memory_collector/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            // As the default constructor requires the initial state of the app here the AppStateLoggedOut is quiete obvious the initial state as in the beginning the user is obvious to be logged out
            isLoading: false,
          ),
        ) {
    // Handle to go to registration screen
    on<AppEventGoToRegistration>(
      (event, emit) {
        emit(
          const AppStateIsInRegistrationView(
            isLoading: false,
          ),
        );
      },
    );
    on<AppEventLogin>((event, emit) async {
      emit(
        // Here the user is initially in the logged out otherwise it is unable to login
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      try {
        // Now log the user in with the email and password and grab the user to show the images in the UI
        final email = event.email;
        final password = event.password;
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        final user = userCredential.user!;
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    // This will take the user to the login screen from the registration screen
    on<AppEventGoToLogin>((event, emit) {
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });
    on<AppEventRegister>((event, emit) async {
      // Start loading
      emit(
        // Update in UI that we are in register view
        const AppStateIsInRegistrationView(
          isLoading: true,
        ),
      );
      // Now retrieve the email and password from the input
      final email = event.email;
      final password = event.password;
      try {
        // Create the user with email and password
        final credintials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Finally enable the user to login
        emit(
          const AppStateIsInLoginView(
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });
    // Handle app initialization here
    on<AppEventInitialize>(
      (event, emit) async {
        // get currentUser
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // Means the user login is not done so stay in the log out state
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
        } else {
          // go and grab the users image as the user has already done the app login
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              user: user,
              images: images,
              isLoading: false,
            ),
          );
        }
      },
    );

    // Handle log out event
    on<AppEventLogOut>(
      (event, emit) async {
        // Start loading the user to be logged out
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );

        // Log the user out
        await FirebaseAuth.instance.signOut();
        // Update in the UI that the user is logged out as well
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      },
    );

    // Handle account deletion
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        // log user out if we dont have any currentUser
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }

        // Start loading the user which needs to be deleted
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );

        // delete the user folder

        try {
          // delete user folder
          final folderContents =
              await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in folderContents.items) {
            await item.delete().catchError(
                (_) {}); // the error should be handled if we cannot delete any image but for now we forcefully delete the account
          }

          // after deleting the images from the user folder now delete the user folder
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});

          // now delete the user itself and log it out
          await user.delete();
          await FirebaseAuth.instance.signOut();
          // Update in the UI that the user is logged out as well
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              user: user,
              images: state.images ?? [],
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          // we might not be able to delete the folder due to some unknown reason hence log the user out
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );

    // handle uploading images
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state
            .user; // Here we have the user already logged in so we dont need to grab the user from firebase_auth rather we bring the user from the app_state

        // log user out if we dont have any valid logged user in app state
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }
        // If the user is not null then the user is valid and hence we can load the images from the AppStateLoggedIn
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );

        // Upload the image with the uploadImage function by passing the actual user.uid to upload images for the current user
        final file = File(event.filePathToUpload);
        await uploadImage(
          file: file,
          userId: user.uid,
        );

        // After upload of images is complete, grab the latest image file references and in the AppStateLoggedIn display the images
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(
          user: user,
          images: images,
          isLoading:
              false, // As new images are emmited so loading should be turned off
        ));
      },
    );
  }

  // This is the function to grab images from FirebaseStorage for the current user of the given userId
  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
