import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/controllers/todo_controller.dart';
import 'package:myproject/models/todos.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _nameController = TextEditingController();
  final todosRef = FirebaseFirestore.instance.collection('todos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: TodoController.getData(),
        builder: (context, snapshot) {
          
          if(snapshot.hasError){
            return const Center(
              child: Text('Error'),
            );
          }

          if(!snapshot.hasData){
            return const Center(
              child: Text('Data is empty.'),
            );
          }
          
          return ListView.separated(
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];

              String nameTodo = data['name'];

              return ListTile(
                onTap: () {},
                onLongPress: () {},
                title: Text(nameTodo),
                subtitle: Text('okej'),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit), 
                          onPressed: () { 
                            _update(data);
                          },
                      ),
                      IconButton(
                          icon: const Icon(Icons.delete), 
                          onPressed: () { 
                            _delete(data.id);
                          },
                      ),
                    ],
                  ),
                ),
              );
            }, 
            separatorBuilder: (context, index) => SizedBox(height: 10,),
            itemCount: snapshot.data!.docs.length,
          );
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Create'),
                onPressed: () async {
                  Navigator.pop(context);

                  final modelTodo = TodoModel(name: _nameController.text);
                  TodoController.saveData(todoModel: modelTodo);

                  _nameController.text = '';
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {

      _nameController.text = documentSnapshot['name'];
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text( 'Update'),
                onPressed: () async {
                  Navigator.pop(context);

                  final String name = _nameController.text;
                  await todosRef.doc(documentSnapshot!.id).update({"name": name});

                  _nameController.text = '';
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)
                ),
              )
            ],
          ),
        );
      });
  }

  Future<void> _delete(String productId) async {
    await todosRef.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

}