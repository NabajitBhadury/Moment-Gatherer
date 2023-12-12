import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:memory_collector/bloc/app_bloc.dart';
import 'package:memory_collector/bloc/app_event.dart';
import 'package:memory_collector/extensions/if_debugging.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'nabajitbhadury@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: '12345678'.ifDebugging);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log in',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email here',
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
              ),
              keyboardAppearance: Brightness.dark,
              obscureText: true,
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                context.read<AppBloc>().add(
                      AppEventLogin(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text(
                'Log in',
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(
                      const AppEventGoToRegistration(),
                    );
              },
              child: const Text(
                'Yet not registered? Click here',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
