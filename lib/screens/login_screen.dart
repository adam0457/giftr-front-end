import 'package:flutter/material.dart';
import '../data/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON, REGISTER }

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, required this.loginUser, required this.goToRegister}) : super(key: key);
  Function loginUser;
  Function goToRegister;
  

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //create global ref key for the form
  final _formKey = GlobalKey<FormState>();
  //state value for user login
  Map<String, dynamic> user = {'email': '', 'password': ''};
 
  String token = '';
  String? jwtFromSP ='initial jwt from sp';
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login to Giftr'),
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
                    _buildEmail(),
                    SizedBox(height: 16),
                    _buildPassword(),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text('Login'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              //validation has been passed so we can save the form
                              _formKey.currentState!.save();
                              //triggers the onSave in each form field
                              //call the API function to post the data
                             // print(user);
                              widget.loginUser(user);
                              //saveToken(token);
                              // getToken();
                              // final myFuture = Future<void>.delayed(Duration(seconds: 3),() => saveToken(token));
                              // final myFuture2 = Future<void>.delayed(Duration(seconds: 5),() => getToken());
                              // final myFuture1 = Future<void>.delayed(Duration(seconds: 7),() => print(jwtFromSP));
                              //print(jwtFromSP);
                              //print('the token has been saved');
                              //getToken();
                              //print(jwtFromSP);
                              //accept the response from the server and
                              //save the token in SharedPreferences
                              //go to the people screen
                              // widget.nav("people");
                            } else {
                              //form failed validation so exit
                              return;
                            }
                          },
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple,
                          ),
                          child: Text('Sign Up'),
                          onPressed: () {
                            //validate then call the API to signup
                            // widget.nav("register");
                            widget.goToRegister();
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
        if (value == null || value.isEmpty || value.length < 3) {
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

  // loginUser(Map<String, dynamic> user)async{
  //   HttpHelper helper = HttpHelper();
  //   helper.connectUser(user);
  //   Map data =  await helper.connectUser(user);
  //   token = data['data']['attributes']['accessToken']; 
     
  // }

  
// void saveToken(jwtoken) async{
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('token',jwtoken);
//   }

//   void getToken() async{
//     final prefs = await SharedPreferences.getInstance();
//     final String? mytoken = prefs.getString('token');
//     jwtFromSP = mytoken;
//   }
}
