import 'package:flutter/material.dart';
import 'package:memory_collector/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Account',
    content:
        'Are you sure to delete your account? You cannot undo this operation',
    optionBuilder: () => {
      'Cancel': false,
      'Delete account': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
