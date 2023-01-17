import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;
  String? _newTaskContent;
  Box? _box;

  _HomePageState();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    debugPrint("Input Value: $_newTaskContent");
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.15,
        title: const Text(
          "Taskly!",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: _taskView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _tasksList() {
    // Task newTask = Task(content: "Workout", timestamp: DateTime.now(), done: false);
    // _box?.add(newTask.toMap());
    List tasks = _box!.values.toList();
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext _context, int index) {
          var task = Task.fromMap(tasks[index]);
          return ListTile(
            title: Text(
              task.content,
              style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(task.timestamp.toString()),
            trailing: Icon(
              task.done
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              color: Colors.red,
            ),
            onTap: (){

                task.done = !task.done;
                _box!.putAt(index, task.toMap());
                setState(() {});
            },
            onLongPress: (){
              _box!.deleteAt(index);
              setState(() {

              });
            },
          );
        });
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      child: const Icon(Icons.add),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _tasksList();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _displayTaskPopup() {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: const Text("Add new Task"),
            content: TextField(
              onSubmitted: (_value) {
                if (_newTaskContent != null) {
                  var task = Task(
                      content: _newTaskContent!,
                      timestamp: DateTime.now(),
                      done: false);
                  _box!.add(task.toMap());
                  setState(() {
                    _newTaskContent = null;
                    Navigator.pop(context);
                  });
                }
              },
              onChanged: (_value) {
                setState(() {
                  _newTaskContent = _value;
                });
              },
            ),
          );
        });
  }
}
