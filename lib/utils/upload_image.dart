import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';


// This handles the upload of the image to the firebase_storage by creating a random file name and return true if the file is successfully uploaded or return false if the file is not uploaded

Future<bool> uploadImage({
  required File file,
  required String userId,
}) =>
    FirebaseStorage.instance
        .ref(userId)
        .child(const Uuid().v4())
        .putFile(file)
        .then((_) => true)
        .catchError((_) => false);
