import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:todo_offline/database/image.dart';
import 'package:todo_offline/firebase/firebase_firestore.dart';
import 'package:todo_offline/firebase/firebase_storage.dart';
import 'package:todo_offline/utils/storage_handler.dart';
import 'package:todo_offline/widgets/custom_input.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController textEditingController = TextEditingController();
  List<Asset> images;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: CustomInputs(
                controller: textEditingController, label: "Todo", inputTag: ""),
          ),
          Expanded(child: buildGridView()),
          RaisedButton(
            child: Text("Pick images"),
            onPressed: loadAssets,
          ),
          RaisedButton(
            child: Text("Add Todo"),
            onPressed: onAddTodo,
          ),
        ],
      ),
    );
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  onAddTodo() async {
    List<String> imagesRef = [];
    if (images != null) {
      String path = await getApplicationImagesStorage();
      for (var image in images) {
        File file = File("$path/${image.name}");
        ByteData byteData = await image.getByteData();
        file.writeAsBytesSync(byteData.buffer.asUint8List());
        //Upload file to firebase
        String imageRef = uploadFile(file, "'images/${image.name}'");
        imagesRef.add(imageRef);
        //Add file in cache
        await addImageToDB(ImageDB(storageRef: imageRef, localPath: file.path));
        print("FILE WRITE DONE " + image.name);
      }
    }
    addTodo(todo: textEditingController.text.toString(), images: imagesRef);
    Navigator.pop(context);
  }
}
