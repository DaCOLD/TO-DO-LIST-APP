import 'package:to_do_app/intro_screen.dart';
import 'package:to_do_app/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  await Hive.initFlutter("hive_box");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TasksPage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/model/task.dart';
class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  double? _deviceHeight, _deviceWidth;
  String? content;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight! * 0.1,
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: const Text("To Do List App of Luis",
        style: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _tasksWidget(),
        floatingActionButton: FloatingActionButton(
    onPressed: displayTaskPop,
        child: Icon(Icons.add),
    ),

    );
  }

  Widget _todoList(){
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index){
        var task = Task.fromMap(tasks[index]);

      return ListTile(
        title: Text(task.todo),
        subtitle: Text(task.timeStamp.toString()),
        trailing: task.done ? Icon(Icons.check_box_outlined,
          color: Colors.green,
        ):
        Icon(Icons.check_box_outline_blank),
        onTap: (){
          task.done = !task.done;
          _box!.putAt(index, task.toMap());

          setState(() {});
        },

        onLongPress: (){
          _box!.deleteAt(index);
          setState(() {});
        },
      );
    });
  }


  Widget _tasksWidget(){
    return FutureBuilder( future: Hive.openBox("Tasks"),
        builder: (BuildContext context, AsyncSnapshot snapshot){
      if(snapshot.hasData){
        _box = snapshot.data;
        return _todoList();
      }else{
        return Center(child: const CircularProgressIndicator());
      }
    });
  }
