import 'package:flutter/material.dart';
import 'package:memory_collector/auth/auth_error.dart';
import 'package:memory_collector/dialogs/generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionBuilder: () => {
      'OK': true,
    },
  );
}
