import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/db_helper.dart';
import 'todo_form_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late DatabaseHelper dbHelper;
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _fetchTodos();
  }

  void _fetchTodos() async {
    final fetchedTodos = await dbHelper.fetchTodos();
    setState(() {
      todos = fetchedTodos;
    });
  }

  void _deleteTodo(int id) async {
    await dbHelper.deleteTodo(id);
    _fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Tâches'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle:
                Text('${todo.date} (${todo.startTime} - ${todo.endTime})'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTodo(todo.id!),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoFormScreen(todo: todo),
                ),
              ).then((_) => _fetchTodos());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoFormScreen(),
            ),
          ).then((_) => _fetchTodos());
        },
      ),
    );
  }
}
