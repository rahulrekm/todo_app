import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/db/db_functions.dart';
import 'package:todo_app/screens/listTile.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox("mybox");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter To Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  final _mybox = Hive.box('mybox');
  DBFunctions db = DBFunctions();
  late TabController _tabController;
  TextEditingController taskController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String dateTime = '';
  DateTime selectedDate = DateTime.now();
  String task = '';
  var date1;
  var date;


 void saveTask(){
   setState(() {
     db.toDoList.add([taskController.text,false,timeController.text,date]);

   });
 }
  void view_bottomSheet(BuildContext context) {

    showModalBottomSheet(
      backgroundColor: Colors.teal,
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.name,
              controller: taskController,
              onChanged: (text){task=taskController.text.toString();},
              decoration: InputDecoration(
                label: Text("Enter the Task"),
              ),
            ),

            SizedBox(height: 5,),
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyyy',
              controller: timeController,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              onChanged: (val) => setState(() => dateTime = val),
              validator: (val) {
                setState(() => dateTime = val ?? '');
                return null;
              },
              onSaved: (val) => setState(() => dateTime = val ?? ''),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  date1 = DateFormat('yyyy-MM-dd').parse(dateTime);
                  date  =  DateFormat('EEEE').format(date1);
                  print(date);
                  saveTask();
                  Navigator.of(context).pop();
                  taskController.clear();
                  timeController.clear();
                },
                child: Text("Submit the Task")),
          ],
        ),
      ),
    );
  }
  void checkBoxChanged(bool? value,int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateList();
}

void deleteTask(int index){
   setState(() {
     db.toDoList.removeAt(index);
   });
   db.updateList();
}

  @override
  void initState() {
   if(_mybox.get("TODOLIST")==null){
      db.initialList();
   }else{
     db.loadList();
   }
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: TabBar(
          indicatorColor: Colors.green,
          overlayColor: MaterialStateProperty.all(Colors.greenAccent[200]),
          isScrollable: true,
          controller: _tabController,
          unselectedLabelColor: Colors.cyan,
          labelColor: Colors.green,
          tabs: <Widget>[
            Tab(
              iconMargin: const EdgeInsets.only(bottom: 1),
              icon: Image.asset(
                "assets/icons/icons8-sunday-64.png",
                width: 36,
                height: 36,
              ),
              child: const Text("Sunday"),
            ),
            Tab(
              iconMargin: const EdgeInsets.only(bottom: 1),
              icon: Image.asset(
                "assets/icons/icons8-monday-64.png",
                width: 36,
                height: 36,
              ),
              child: const Text("Monday"),
            ),
            Tab(
              iconMargin: const EdgeInsets.only(bottom: 1),
              icon: Image.asset(
                "assets/icons/icons8-tuesday-64.png",
                width: 36,
                height: 36,
              ),
              child: const Text("Tuesday"),
            ),
            Tab(
              iconMargin: const EdgeInsets.only(bottom: 1),
              icon: Image.asset(
                "assets/icons/icons8-wednesday-64.png",
                width: 36,
                height: 36,
              ),
              child: const Text("Wednesday"),
            ),
            Tab(
              iconMargin: const EdgeInsets.only(bottom: 1),
              icon: Image.asset(
                "assets/icons/icons8-thursday-64.png",
                width: 36,
                height: 36,
              ),
              child: const Text("Thursday"),
            ),
            Tab(
              iconMargin: const EdgeInsets.only(bottom: 1),
              icon: Image.asset(
                "assets/icons/icons8-friday-64.png",
                width: 36,
                height: 36,
              ),
              child: const Text("Friday"),
            ),
            Tab(
              iconMargin: const EdgeInsets.only(bottom: 1),
              icon: Image.asset(
                "assets/icons/icons8-saturday-64.png",
                width: 36,
                height: 36,
              ),
              child: const Text("Saturday"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(key: "key1", string: "Sunday"),
          _buildList(key: "key2", string: "Monday"),
          _buildList(key: "key3", string: "Tuesday"),
          _buildList(key: "key4", string: "Wendesday"),
          _buildList(key: "key5", string: "Thursday"),
          _buildList(key: "key6", string: "Friday"),
          _buildList(key: "key7", string: "Saturday"),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => view_bottomSheet(context),
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  Widget _buildList({required String key, required String string}) {
    return ListView.builder(
        key: PageStorageKey(key),
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ListTileScreen(
            dateTime: db.toDoList[index][2],
            mytask: db.toDoList[index][0],
            iscompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value!, index),
            deleteFunction: (context) => deleteTask(index),
          );
        }
    );
  }
}






