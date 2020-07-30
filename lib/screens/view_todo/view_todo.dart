import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:todo_offline/database/image.dart';
import 'package:todo_offline/firebase/firebase_storage.dart';
import 'package:todo_offline/services/apiservice.dart';
import 'package:todo_offline/utils/storage_handler.dart';
import 'package:todo_offline/widgets/custom_input.dart';

class ViewTodo extends StatefulWidget {
  final DocumentSnapshot todo;
  ViewTodo({this.todo});
  @override
  _ViewTodoState createState() => _ViewTodoState(todo: todo);
}

class _ViewTodoState extends State<ViewTodo> {
  TextEditingController textEditingController = TextEditingController();
  List<Image> images = [];
  DocumentSnapshot todo;
  _ViewTodoState({this.todo});
  @override
  void initState() {
    images = [];
    downloadImages(widget);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textEditingController.text = widget.todo["todo"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo details"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: CustomInputs(
                controller: textEditingController, label: "Todo", inputTag: ""),
          ),
          Expanded(child: buildGridView(widget)),
        ],
      ),
    );
  }

  Widget buildGridView(ViewTodo widget) {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          return images[index];
        }),
      );
    else
      return Container(
        child: Text("NO IMAGE"),
      );
  }

  void downloadImages(ViewTodo widget) async {
    if (widget.todo["images"] != null)
      for (String imageRef in widget.todo["images"]) {
        final StorageReference ref = storage.ref().child(imageRef);
        //If its in local cache take from local cache todo
        List<ImageDB> imageDbs = await getImagesFromDB(ref.path);
        if (imageDbs.length != 0) {
          setState(() {
            images.add(Image.file(File(imageDbs.first.localPath)));
          });
          print("IMAGE RETRIVED FROM CACHE " + ref.path);
          continue;
        }
        //Else Download and save image
        ref.getDownloadURL().then((value) async {
          setState(() {
            images.add(Image.network(value));
          });
          //Save the image locally todo
          String savePath =
              (await getApplicationImagesStorage()) + "/${await ref.getName()}";
          await ApiService().downloadImage(url: value, savePath: savePath);
          await addImageToDB(
              ImageDB(storageRef: ref.path, localPath: savePath));
          print("IMAGE SAVED " + ref.path);
        });
      }
  }
}
