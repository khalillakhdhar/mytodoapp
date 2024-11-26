import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/db_helper.dart';

class TodoFormScreen extends StatefulWidget {
  final Todo? todo;

  const TodoFormScreen({Key? key, this.todo}) : super(key: key);

  @override
  _TodoFormScreenState createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title, _description, _date, _startTime, _endTime;

  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _title = widget.todo?.title ?? '';
    _description = widget.todo?.description ?? '';
    _date = widget.todo?.date ?? '';
    _startTime = widget.todo?.startTime ?? '';
    _endTime = widget.todo?.endTime ?? '';
  }

  void _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTodo = Todo(
        id: widget.todo?.id,
        title: _title,
        description: _description,
        date: _date,
        startTime: _startTime,
        endTime: _endTime,
      );

      if (widget.todo == null) {
        await dbHelper.insertTodo(newTodo);
      } else {
        await dbHelper.updateTodo(newTodo);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.todo == null ? 'Ajouter une Tâche' : 'Modifier la Tâche'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) =>
                    value!.isEmpty ? 'Le titre est obligatoire' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _date,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (value) =>
                    value!.isEmpty ? 'La date est obligatoire' : null,
                onSaved: (value) => _date = value!,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _startTime,
                      decoration: InputDecoration(labelText: 'Heure de début'),
                      onSaved: (value) => _startTime = value!,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _endTime,
                      decoration: InputDecoration(labelText: 'Heure de fin'),
                      onSaved: (value) => _endTime = value!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTodo,
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
