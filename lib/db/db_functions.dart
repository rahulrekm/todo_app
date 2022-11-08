import 'package:hive/hive.dart';

import '../models/user_model.dart';

class DBFunctions {
 List toDoList = [];
 final _mybox = Hive.box('mybox');

 void initialList(){
  toDoList = [
   ["my task", false,"date"],
   ["do app",true,"date"]
  ];
 }

 void loadList(){
 toDoList = _mybox.get('TODOLIST');
 }

 void updateList(){
 _mybox.put('TODOLIST', toDoList);
 }
}

