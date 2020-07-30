import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class ImageDB {
  final String storageRef;
  final String localPath;

  ImageDB({this.storageRef, this.localPath});

  Map<String, dynamic> toMap() {
    return {'storage_ref': storageRef, 'local_path': localPath};
  }
}

// Define a function that inserts images into the database
Future<void> addImageToDB(ImageDB imageDB) async {
  var db = await DBHelper.database;
  final List<Map<String, dynamic>> images = await db.rawQuery(
      'SELECT * FROM images WHERE storage_ref=?', [imageDB.storageRef]);
  if (images.length != 0) {
    return;
  }
  await db.insert(
    'images',
    imageDB.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

//getLocalURL list
Future<List<ImageDB>> getImagesFromDB(String storageRef) async {
  var db = await DBHelper.database;
  List<Map<String, dynamic>> maps = [];

  maps = await db
      .rawQuery('SELECT * FROM images WHERE storage_ref=?', [storageRef]);

  return List.generate(maps.length, (i) {
    return ImageDB(
        localPath: maps[i]['local_path'], storageRef: maps[i]['storage_ref']);
  });
}

//delete Project
Future deleteImageFromDB(String storageRef) async {
  var db = await DBHelper.database;
  await db.delete("images", where: "storage_ref = ?", whereArgs: [storageRef]);
}

Future<void> updateImageToDB(ImageDB imageDB) async {
  var db = await DBHelper.database;
  await db.update(
    'images',
    imageDB.toMap(),
    // Ensure that the project has a matching id.
    where: "storage_ref = ?",
    // Pass the project's id as a whereArg to prevent SQL injection.
    whereArgs: [imageDB.storageRef],
  );
}
