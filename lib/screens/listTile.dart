import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListTileScreen extends StatelessWidget{
   final String mytask;
   final String dateTime;
   final bool iscompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
   ListTileScreen({
    super.key,
    required this.mytask,
    required this.dateTime,
    required this.iscompleted,
    required this.onChanged,
    this.deleteFunction,
  });

  final bool value = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(), 
          children: [
            SlidableAction(
                onPressed: deleteFunction,
            icon: Icons.delete,
              backgroundColor: Colors.redAccent,
            )
          ],

        ),
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: Text(mytask,style: TextStyle(
                      fontSize: 20,
                      color: Colors.cyan,
                      decoration: iscompleted ? TextDecoration.lineThrough : TextDecoration.none
                  ),
                  ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(dateTime,style: TextStyle(fontSize: 18),),
                    ),

                    checkColor: Colors.green,
                    tileColor: Colors.blueGrey,
                    contentPadding: EdgeInsets.all(20),
                    value: iscompleted,
                    onChanged: onChanged,
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }

}