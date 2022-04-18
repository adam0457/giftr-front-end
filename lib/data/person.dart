import 'package:flutter/material.dart';

//one custom data class per object type
//they could all be in one file but more commonly in their own
class Person {
  String id = '';
  String name = '';
  DateTime birthDate = DateTime.now();
  List<dynamic> gifts = [];
  String owner = '';
  
  //constructor
  Person({
    required this.id, 
    required this.name, 
    required this.birthDate, 
    required this.owner, 
    required this.gifts
  });

  //Map<String, dynamic> means we are declaring a Map object
  // with keys that are strings and the values that are dynamic

  //the fromJson constructor method that will convert from userMap to our User object.
  Person.fromJson(Map<String, dynamic> userMap) {
    id = userMap['_id'];
    name = userMap['name'];
    birthDate = DateTime.parse(userMap['birthDate']);
    gifts = userMap['gifts'];
    owner = userMap['owner'];  
    
  }
}

