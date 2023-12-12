import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_collector/bloc/app_bloc.dart';
import 'package:memory_collector/bloc/app_event.dart';
import 'package:memory_collector/bloc/app_state.dart';
import 'package:memory_collector/dialogs/show_auth_error.dart';
import 'package:memory_collector/loading/loading_screen.dart';
import 'package:memory_collector/views/login_view.dart';
import 'package:memory_collector/views/photo_galler_view.dart';
import 'package:memory_collector/views/register_view.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Memory Collector',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading .....',
              );
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = appState.authError;
            if (authError != null) {
              showAuthError(
                authError: authError,
                context: context,
              );
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else if (appState is AppStateIsInLoginView) {
              return const LoginView();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
