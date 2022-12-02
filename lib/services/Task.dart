import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Task
{
  String id;
  String task_name;
  bool pressed;
  Task(this.id,this.task_name, this.pressed);
  Task.fromMap(Map map) :
      this.id = map['id'],
      this.task_name = map['task_name'],
      this.pressed = map['pressed'];
  Map toMap(){
    return {
      'id' : this.id,
      'task_name' : this.task_name,
      'pressed' : this.pressed,
    };
  }
}
