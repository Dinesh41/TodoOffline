import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_offline/firebase/firebase_firestore.dart';
import 'package:todo_offline/screens/view_todo/view_todo.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Todo Offline"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTodos(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return Text("No Todos");
            }
            List<Widget> content = [];
            for (int index = 0;
                index < snapshot.data.documents.length;
                index++) {
              content.add(
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewTodo(todo: snapshot.data.documents[index]),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(snapshot.data.documents[index]["todo"]),
                    ),
                    elevation: 10,
                  ),
                ),
              );
            }
            return ListView(children: content);
          } else {
            return Text("Loading");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/addtodo");
        },
      ),
    );
  }
}
