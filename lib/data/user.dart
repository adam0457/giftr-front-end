import 'package:flutter/material.dart';

//one custom data class per object type
//they could all be in one file but more commonly in their own
class User {
    String id = '';
    String firstname = '';
    String lastname = '';
    String email = '';
    
    //constructor
    User(this.id, this.firstname, this.lastname, this.email);
  

    //the fromJson constructor method that will convert from userMap to our User object.
    User.fromJson(Map<String, dynamic> userMap) {
      id = userMap['id'] ?? '';
      firstname = userMap['firstname'] ?? '';
      lastname = userMap['lastname'] ?? '';
      email = userMap['email'] ?? '';        
    }
}

