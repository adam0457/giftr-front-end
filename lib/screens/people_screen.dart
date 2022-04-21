import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/person.dart';
import 'dart:async'; 
import '../data/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Function logout;
  String? token;
  

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {

  List<Person> people = <Person>[];

  DateTime today = DateTime.now();
  String? jwt = "Initial value of jwt";
  HttpHelper helper = HttpHelper();
  void initState() {
    super.initState();  
    getPeople(widget.token);
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
              widget.logout();
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

}
