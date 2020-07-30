import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

FirebaseStorage storage = FirebaseStorage.instance;

////Uploads files to storage and give the URL
//Future<String> uploadFile({@required File file}) async {
//  String uuid = Uuid().v1();
//  final StorageReference ref = storage.ref().child('images/$uuid');
//  StorageUploadTask uploadTask = ref.putFile(file);
////  //Adding delay to get the URL and to avoid storage exception
////  await new Future.delayed(const Duration(seconds: 4));
//  await uploadTask.onComplete;
//  return await ref.getDownloadURL();
//}

//deleteFile using url
Future<void> deleteFileUsingURL({@required url}) async {
  var ref = await storage.getReferenceFromUrl(url);
  return ref.delete();
}

//Upload file
String uploadFile(File file, String refPath) {
  final StorageReference ref = storage.ref().child(refPath);
  StorageUploadTask uploadTask = ref.putFile(file);
  return ref.path;
}
