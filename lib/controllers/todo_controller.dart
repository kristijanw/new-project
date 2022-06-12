import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/models/todos.dart';

final firestore = FirebaseFirestore.instance.collection('todos');

class TodoController {

  static Stream<QuerySnapshot> getData() {
    return firestore.snapshots();
  }

  static Future<void> saveData({required TodoModel todoModel}) async {
    DocumentReference docRef = firestore.doc(todoModel.name);

    await docRef.set(todoModel.toJson()).whenComplete(() => 
    print('Data saved.')).catchError((e) => print(e));
  }

  static Future<void> updateData({required TodoModel todoModel}) async {
    DocumentReference docRef = firestore.doc(todoModel.name);

    await docRef.update(todoModel.toJson()).whenComplete(() => 
    print('Data is updated.')).catchError((e) => print(e));
  }
  
}