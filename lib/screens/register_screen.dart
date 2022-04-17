import 'package:flutter/material.dart';
import 'dart:async';
import '../data/http_helper.dart';
import '../data/user.dart';

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key, required this.nav}) : super(key: key);
  Function nav;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //create global ref key for the form
  final _formKey = GlobalKey<FormState>();
  //state value for user login
  Map<String, dynamic> user = {'firstName':'','lastName':'', 'email': '', 'password': ''};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.home),
        ),
          title: Text('The Register Screen'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFirstName(),
                    SizedBox(height: 16),
                    _buildLastName(),
                    SizedBox(height: 16),
                    _buildEmail(),
                    SizedBox(height: 16),
                    _buildPassword(),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text('Submit'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              //validation has been passed so we can save the form
                              _formKey.currentState!.save();
                              //triggers the onSave in each form field
                              //call the API function to post the data
                              //accept the response from the server and
                              //save the token in SharedPreferences
                              //go to the people screen
                              registerUser(user);
                              widget.nav();
                              //print("${user['firstName']} ${user['lastName']} ${user['email']} ${user['password']}");
                            
                            } else {
                              //form failed validation so exit
                              return;
                            }
                          },
                        ),
                      
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }

  InputDecoration _styleField(String label, String hint) {
    return InputDecoration(
      labelText: label, // label
      labelStyle: TextStyle(color: Colors.black),
      hintText: hint, //placeholder
      border: OutlineInputBorder(),
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      decoration: _styleField('Email', 'Email'),
      controller: emailController,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        print('called validator in email');
        if (value == null || value.isEmpty) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          user['email'] = value;
        });
      },
    );
  }

  TextFormField _buildPassword() {
    return TextFormField(
      decoration: _styleField('Password', ''),
      controller: passwordController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        if (value == null || value.isEmpty || value.length < 5) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          user['password'] = value;
        });
      },
    );
  }

  // build the firstname
  TextFormField _buildFirstName() {
    return TextFormField(
      decoration: _styleField('FirstName', ''),
      controller: firstNameController,
      obscureText: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        if (value == null || value.isEmpty || value.length < 2) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        
        setState(() {
          user['firstName'] = value;
        });
      },
    );
  }

  // build the lastname
  TextFormField _buildLastName() {

    return TextFormField(
      decoration: _styleField('LastName', ''),
      controller: lastNameController,
      obscureText: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        if (value == null || value.isEmpty || value.length < 2) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        
        setState(() {
          user['lastName'] = value;
        });
      },
    );
  }

  // void registerUser(Map<String, dynamic> user){
  //   HttpHelper helper = HttpHelper();
  //   helper.addUser(user);
  // }

  registerUser(Map<String, dynamic> user)async{
    HttpHelper helper = HttpHelper();
    User currentUser =  await helper.createUser(user);
    print(currentUser.id);
    
  }

}
