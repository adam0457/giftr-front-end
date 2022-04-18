import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/person.dart';
import 'dart:async'; //for Future
//import 'dart:math'; //for Random
import '../data/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

class PeopleScreen extends StatefulWidget {
  PeopleScreen(
      {Key? key,
      required this.token,
      required this.logout,
      required this.goGifts,
      required this.goEdit})
      : super(key: key);

  Function(String, String) goGifts;
  Function(String, String, DateTime) goEdit;
  Function(Enum) logout;
  String? token;
  

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  //state var list of people
  //real app will be using the API to get the data
  //Future<List<Person>> people =  Future(() => <Person>[]);
  List<Person> people = <Person>[];
  // List<Map<String, dynamic>> people = [
  //   {'id': 11, 'name': 'Bobby Singer', 'dob': DateTime(1947, 5, 4)},
  //   {'id': 13, 'name': 'Crowley', 'dob': DateTime(1661, 12, 4)},
  //   {'id': 12, 'name': 'Sam Winchester', 'dob': DateTime(1983, 5, 2)},
  //   {'id': 10, 'name': 'Dean Winchester', 'dob': DateTime(1979, 1, 24)},
  // ];
  DateTime today = DateTime.now();
  String? jwt = "Initial value of jwt";
   HttpHelper helper = HttpHelper();
  void initState() {
    super.initState();
    print('hellloooo');
    print(widget.token);
    getPeople(widget.token); 
    //print(people);
   //final myFuture = Future<void>.delayed(Duration(seconds: 5),() => print(people));
   
    // setState(() {
       // people = data;
        //print('Got ${users.length} FutureBuilder users.');
      //});

  }

  @override
  Widget build(BuildContext context) {
    //code here runs for every build
    //someObjects.sort((a, b) => a.someProperty.compareTo(b.someProperty));
    //people.sort((a, b) => a['dob'].month.compareTo(b['dob'].month));
    //sort the people by the month of birth

    return Scaffold(
      appBar: AppBar(
        title: Text('Giftr - People'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              //logout and return to login screen
              //widget.logout(Screen.LOGIN);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          return ListTile(
            //different background colors for birthdays that are past
            tileColor: today.month > people[index].birthDate.month
                ? Colors.black12
                : Colors.white,
            title: Text(people[index].name),
            subtitle: Text(DateFormat.MMMd().format(people[index].birthDate)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    print('edit person $index');
                    print('go to the add_person_screen');
                    print(people[index].birthDate);
                    widget.goEdit(people[index].id, people[index].name,
                        people[index].birthDate);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.lightbulb, color: Colors.amber),
                  onPressed: () {
                    print('view gift ideas for person $index');
                    print('go to the gifts_screen');
                    widget.goGifts(people[index].id, people[index].name);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //go to the add gift page
          DateTime now = DateTime.now();
          widget.goEdit('', '', now);
        },
      ),
    );
  }

    getPeople(token)async{
    List<Person> result = await helper.getListPeople(token);
    
    //print(people);
     setState(() {
      people = result;
    });
    
  }

  // getToken() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? mytoken = prefs.getString('token');
  //   Future<void>.delayed(Duration(seconds: 5), () {
  //     //setState(() {
  //       //jwt = mytoken;
  //       print(mytoken);
                
  //    // });
  //   });
  
  // }

}
