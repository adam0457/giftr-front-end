import 'package:flutter/material.dart';
import 'package:flutter_multi_screen/screens/add_person_screen.dart';
import 'package:flutter_multi_screen/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
//screens
import '../screens/login_screen.dart';
import '../screens/people_screen.dart';
import '../screens/gifts_screen.dart';
import '../screens/add_person_screen.dart';
import '../screens/add_gift_screen.dart';
//data and api classes
import '../data/http_helper.dart';
import '../data/user.dart';
import '../data/person.dart';

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON, REGISTER }

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //put the things that are the same on every page here...
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  //stateful widget for the main page container for all pages
  // we do this to keep track of current page at the top level
  // the state information can be passed to the BottomNav()
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var currentScreen = Screen.LOGIN;
  String currentPerson = ''; //use for selecting person for gifts pages.
  String currentPersonName = '';
  DateTime currentPersonDOB = DateTime.now(); //right now as default
  String? token;
  String? currentUserId;
  

  // to access variables from MainPage use `widget.`
  @override
  Widget build(BuildContext context) {
    return loadBody(currentScreen);
  }

  Widget loadBody(Enum screen) {
    switch (screen) {
      case Screen.REGISTER:
        return RegisterScreen(registerUser: registerUser);
        break;
      case Screen.LOGIN:
            return LoginScreen(loginUser: loginUser, goToRegister:goToRegister);       
        break;
      case Screen.PEOPLE:
        return PeopleScreen(
          token:token,
          goGifts: (String pid, String name) {           
            print('from people to gifts for person $pid');
            setState(() {
              currentPerson = pid;
              currentPersonName = name;
              currentScreen = Screen.GIFTS;
            });
          },
          goEdit: (String pid, String name, DateTime dob) {
            //edit the person
            print('go to the person edit screen');
            setState(() {
              currentPerson = pid;
              currentPersonName = name;
              currentPersonDOB = dob;
              currentScreen = Screen.ADDPERSON;
            });
          },
          logout: (Enum screen) {
            //back to people
            setState(() => currentScreen = Screen.LOGIN);
          },
          
        );
      case Screen.GIFTS:
        return GiftsScreen(
           token:token,
            goPeople: (Enum screen) {
              //back to people
              setState(() => currentScreen = Screen.PEOPLE);
            },
            logout: (Enum screen) {
              setState(() => currentScreen = Screen.LOGIN);
            },
            addGift: () {
              //delete gift idea and update state
              setState(() => currentScreen = Screen.ADDGIFT);
            },
            currentPerson: currentPerson,
            currentPersonName: currentPersonName);

      case Screen.ADDPERSON:
        return AddPersonScreen(
          nav: (Enum screen) {
            //back to people
            setState(() => currentScreen = Screen.PEOPLE);
          },
          currentPerson: currentPerson,
          currentPersonName: currentPersonName,
          personDOB: currentPersonDOB,
          addPerson:addPerson,
          editPerson:editPerson,
          deletePerson:deletePerson
        );
      case Screen.ADDGIFT:
        return AddGiftScreen(
          nav: (Enum screen) {
            //save the gift idea
            //go back to list of gifts
            setState(() => currentScreen = Screen.GIFTS);
          },
          currentPerson: currentPerson,
          currentPersonName: currentPersonName,
        );
      default:
        return LoginScreen(loginUser: loginUser, goToRegister:goToRegister);
      
    }
  }

  registerUser(Map<String, dynamic> user)async{
    HttpHelper helper = HttpHelper();
    User currentUser =  await helper.createUser(user); 
    setState(() => currentScreen = Screen.LOGIN);   
  }

  goToRegister(){
    setState(() => currentScreen = Screen.REGISTER);    
  }

  loginUser(Map<String, dynamic> user)async{
    HttpHelper helper = HttpHelper();
    helper.connectUser(user);
    Map data =  await helper.connectUser(user);
    token = data['data']['attributes']['accessToken']; 
    saveToken(token);
    setState(() => currentScreen = Screen.PEOPLE);
    getCurrentUser(token);
  }

  getCurrentUser(token) async{
    HttpHelper helper = HttpHelper();
    Map result = await helper.getLoggedInUser(token);
    currentUserId = result['id'];    
  }

  void saveToken(jwtoken) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token',jwtoken);
  }

  addPerson(Map<String, dynamic> person) async{
    HttpHelper helper = HttpHelper();
    Person newPerson =  await helper.createPerson(person,currentUserId,token); 
   // print(newPerson);
  }

  editPerson(Map<String, dynamic> person) async {
    HttpHelper helper = HttpHelper();   
    Person personEdited =  await helper.editPerson(person, currentUserId, currentPerson,token);
  }

  deletePerson() async {
    HttpHelper helper = HttpHelper();   
    Person personEdited =  await helper.deletePerson(currentPerson,token);
  }

}
