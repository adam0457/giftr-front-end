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

  //Map<String, dynamic> means we are declaring a Map object
  // with keys that are strings and the values that are dynamic

  //the fromJson constructor method that will convert from userMap to our User object.
  User.fromJson(Map<String, dynamic> userMap) {
    id = userMap['id'] ?? '';
    firstname = userMap['firstname'] ?? '';
    lastname = userMap['lastname'] ?? '';
    email = userMap['email'] ?? '';  
    
  }
}

/*
Sample object
{
  id: 1,
  name: "Leanne Graham",
  username: "Bret",
  email: "Sincere@april.biz",
  address: {
    street: "Kulas Light",
    suite: "Apt. 556",
    city: "Gwenborough",
    zipcode: "92998-3874",
    geo: {
      lat: "-37.3159",
      lng: "81.1496"
    }
  },
  phone: "1-770-736-8031 x56442",
  website: "hildegard.org",
  company: {
    name: "Romaguera-Crona",
    catchPhrase: "Multi-layered client-server neural-net",
    bs: "harness real-time e-markets"
  }
},
*/