import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image, String name) async {
    StorageReference reference =
        _storage.ref().child("store/" + name + extension(image.path));

    StorageUploadTask uploadTask = reference.putFile(image);
    String location =
        (await (await uploadTask.onComplete).ref.getDownloadURL()).toString();
    return location;
  }

  Future<bool> deleteImage(String image) async {
    try {
      StorageReference reference = await _storage.getReferenceFromUrl(image);
      await reference.delete();
    } catch (e) {}
    return true;
  }
}

final FirebaseStorageService firebaseStorageService = FirebaseStorageService();
