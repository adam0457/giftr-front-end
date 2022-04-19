import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

class AddPersonScreen extends StatefulWidget {
  AddPersonScreen({
    Key? key,
    required this.nav,
    required this.currentPerson,
    required this.currentPersonName,
    required this.personDOB,
    required this.addPerson,
    required this.editPerson,
    required this.deletePerson
  }) : super(key: key);

  Function nav;
  String currentPersonName; // could be empty string
  String currentPerson; //could be zero
  DateTime personDOB;
  Function addPerson;
  Function editPerson;
  Function deletePerson;

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();

  //create global ref key for the form
  final _formKey = GlobalKey<FormState>();

  //state value for user login
  Map<String, dynamic> person = {'name': '', 'dob': ''};

  @override
  void initState() {
    super.initState();
    person['name'] = widget.currentPersonName;
    person['dob'] = widget.personDOB;
    nameController.text = person['name'];
    dobController.text = DateFormat.yMMMd().format(person['dob']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //back to the people page using the function from main.dart
            widget.nav(Screen.PEOPLE);
          },
        ),
        title: widget.currentPersonName.isEmpty
            ? Text('Add Person')
            : Text('Edit ${widget.currentPersonName}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildName(),
              SizedBox(height: 16),
              _buildDOB(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Save'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                            //use the API to save the new person
                          //go to the people screen
                          print(person);
                          widget.currentPersonName.isEmpty
                          ? widget.addPerson(person)
                          :widget.editPerson(person);
                          widget.nav(Screen.PEOPLE);
                      }else {
                                //form failed validation so exit
                                return;
                              }
                      
                    },
                  ),
                  SizedBox(width: 16.0),
                  if (widget.currentPerson != '' )
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text('Delete'),
                      onPressed: () {
                        widget.deletePerson();
                        //delete the selected person
                        //needs confirmation dialog
                        widget.nav(Screen.PEOPLE);
                      },
                    ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  InputDecoration _styleField(String label, String hint, bool pickDate) {
    return InputDecoration(
      labelText: label, // label
      labelStyle: TextStyle(color: Colors.black87),
      hintText: hint, //placeholder
      hintStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(),
      suffixIcon: pickDate
          ? IconButton(
              icon: Icon(Icons.calendar_month),
              onPressed: () {
                _showDatePicker();
              },
            )
          : null,
    );
  }

 

  TextFormField _buildName() {
    return TextFormField(
      decoration: _styleField('Person Name', 'person name', false),
      controller: nameController,
      obscureText: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
          //becomes the new errorText value
        }        
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          person['name'] = value;
        });
      },
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then(
      (value) {
        setState(
          () {
            person['dob'] = value;
            dobController.text = DateFormat.yMMMd().format(person['dob']);
          },
        );
      },
    );
  }

  TextFormField _buildDOB() {
    return TextFormField(
      decoration: _styleField('Date of Birth', 'yyyy-mm-dd', true),
      controller: dobController,
      obscureText: false,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid date';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          person['dob'] = value;
        });
      },
    );
  }
}
