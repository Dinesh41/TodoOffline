import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final Firestore fireStore = Firestore.instance;

//get todo_list
Stream<QuerySnapshot> getTodos() {
  return fireStore.collection('todos').snapshots();
}

//Add Todo_Item
Future addTodo({@required String todo, @required List<String> images}) async {
  await fireStore.collection("todos").add({
    'todo': todo,
    'images': images,
  });
}
