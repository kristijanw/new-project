
import 'package:flutter/foundation.dart';

@immutable
class TodoModel {

  TodoModel({
    required this.name,
  });

  final String name;

  Map<String, dynamic> toJson(){
    return {
      "name": name
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      name: json['name']
    );
  }
}