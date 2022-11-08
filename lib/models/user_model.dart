import 'package:hive/hive.dart';

@HiveType(typeId: 1)

class UserModel {

  @HiveField(0)
  final String task;

  @HiveField(1)
  final String datetime;

  @HiveField(2)
  String? id;

  UserModel({required this.task, required this.datetime}) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }
}