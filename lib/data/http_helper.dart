import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './user.dart';
import './person.dart';

// https://jsonplaceholder.typicode.com/users

//have one HttpHelper type class per API
class HttpHelper {
  final String domain = 'localhost:3030';

  Future<http.Response> makeRequest(
      String method, Uri uri, Map<String, String>? headers, String? body) {
    body = body ?? '';
    headers = headers ??
        {
          'Content-Type': 'application/json; charset=UTF-8',
        };

    switch (method) {
      case 'post':
        return http.post(uri, headers: headers, body: jsonEncode(body));
        break;
      case 'put':
        return http.put(uri, headers: headers, body: jsonEncode(body));
        break;
      case 'patch':
        return http.patch(uri, headers: headers, body: jsonEncode(body));
        break;
      case 'delete':
        return http.delete(uri, headers: headers);
        break;
      default:
        //get
        return http.get(uri, headers: headers);
    }
  }

  Future<List<User>> getUsers() async {
    Map<String, dynamic> parameters = {
      'sample': '123',
    };
    Uri uri = Uri.https(domain, 'users', parameters);

    http.Response response = await makeRequest('get', uri, null, null);

    if (response.statusCode == 200) {
      //a get request should respond with a 200 status
      List<dynamic> data = jsonDecode(response.body);
      //our data is a list filled with objects
      //we want each of those objects to become a User object
      List<User> users = data.map<User>((element) {
        User user = User.fromJson(element);
        return user;
      }).toList();
      return users;

      //Js     myArray.map(func)  //returns a new Array
      //Dart   myList.map( func ).toList()  //return a new List

      //Js     myArray.filter(func)  //returns a new filtered Array
      //Dart   myList.where( func).toList()  //return a new List

    } else {
      throw Exception('Unable to fetch list of users');
    }
  }

  //add a method for POST to add a user
  Future<Map> addUser(newUser) async {
    //queryString params
    // Map<String, dynamic> parameters = {
    //   'sample': '123',
    // };
    //headers to send to the server
    Map<String, String> headers = {
      'x-api-key': 'adam0457',
      'Content-Type': 'application/json',
    };
    //data to send to the server
    // Map<String, dynamic> newuser = {
    //   'name': 'Bobby Singer',
    //   'username': 'Bobby',
    //   'email': 'willis@fbi.gov',
    //   'address': {
    //     'street': '2194 Main st',
    //     'city': 'Sioux Falls',
    //     'zipcode': '57107',
    //     'geo': {'lat': '43.5460', 'lng': '96.7313'}
    //   },
    //   'phone': '1-605-555-1234',
    //   'website': 'singersalvage.org',
    //   'company': {
    //     'name': 'Singer Salvage Yard',
    //     'catchPhrase': 'Idjit',
    //   }
    // };
    //build the URL for the endpoint
   //Uri uri = Uri.https(domain, 'users', parameters);
    String endpoint = 'auth/users';
    Uri uri = Uri.https(domain, endpoint);

   http.Response response = await makeRequest('post', uri, headers, jsonEncode(newUser));
    //http.Response response = await http.post(uri, body:jsonEncode(newUser));

    if (response.statusCode == 201) {
      //post should get a 201 response status
      //new user created we want the id
      print('Registered with success');
      return jsonDecode(response.body);
    } else {
      //failed
      throw Exception('Unable to create user.');
    }
  }

  Future<User> createUser(newUser) async{
  
        String endpoint = 'auth/users';
        Uri uri = Uri.http(domain,endpoint); //Uri in dart:core
        Map<String, String> headers = {
          'x-my-header': 'My name',
          'content-type': 'application/json', //because we want to send JSON
        };
      Map<String, dynamic> user = {
        'data':{
        'type':"users",
        'attributes': newUser
        }
        
      };
      String body = jsonEncode(user);

      var resp = await http.post(uri, headers: headers, body: body);
      switch (resp.statusCode) {
        case 200:
        case 201:
          //maybe other codes too
          //got some data
          print('successsss');
         Map<String, dynamic> userRegistered = jsonDecode(resp.body);
          //print(userRegistered['data']['id']);
          User currentUser = User.fromJson(userRegistered['data']);
          // return jsonDecode(resp.body);
          return currentUser;
          //return jsonDecode(userRegistered['data']['id']);
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to add user.',
          };
          throw Exception(msg);
      }
  }
  Future<Map> connectUser(usr) async{
      String endpoint = 'auth/tokens';
        Uri uri = Uri.http(domain,endpoint); //Uri in dart:core
        Map<String, String> headers = {
          'x-my-header': 'my name',
          'content-type': 'application/json', //because we want to send JSON
        };
      Map<String, dynamic> connectUser = {
        'data':{
        'type':"users",
        'attributes':usr      
        }
        
      };
      String body = jsonEncode(connectUser);

      var resp = await http.post(uri, headers: headers, body: body);
      switch (resp.statusCode) {
        case 200:
        case 201:
          //maybe other codes too
          //got some data
          print('successsss');
          Map<String, dynamic> data = jsonDecode(resp.body);
          
          //print(data['data']['attributes']['accessToken']);
          return jsonDecode(resp.body);
          //return currentUser;
          //return jsonDecode(userRegistered['data']['id']);
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to connect user.',
          };
          throw Exception(msg);
      }
  }
  
  Future<List<Person>> getListPeople(token) async {
    String endpoint = 'api/people';
        Uri uri = Uri.http(domain,endpoint); //Uri in dart:core
        Map<String, String> headers = {
          'x-my-header': 'my name',
          //'content-type': 'application/json', //because we want to send JSON
          'Authorization':'Bearer $token'
        };  
      
      http.Response resp = await http.get(uri,headers: headers);
      //Map<String, dynamic> resp = jsonDecode(response.body);
        switch (resp.statusCode) {
        case 200:
        case 201:
          //maybe other codes too
          //got some data
          print('good job');
          Map<String, dynamic> result = jsonDecode(resp.body);
          //print(result['data']);
          if(result['data'].length > 0){
              List<Person> people = result['data'].map<Person>((item){
              Person person = Person.fromJson(item['attributes']);
              return person;
              }).toList();
              return people;
          } 
          return  <Person> [];       
          // else {
          //     String errorMessage = "You do not have friends in your list";
          //     throw Exception(errorMessage);
          // }
          
          // print(result);
          //print(data['data']['attributes']['accessToken']);
          //return jsonDecode(resp.body);
          //return currentUser;
          //return jsonDecode(userRegistered['data']['id']);
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to connect user.',
          };
          throw Exception(msg);
      }     
      
  }

  Future<Map> getLoggedInUser(token) async{
      String endpoint = 'auth/users/me';
        Uri uri = Uri.http(domain,endpoint); //Uri in dart:core
        Map<String, String> headers = {
          'x-my-header': 'adam0457 eshwar',
          'content-type': 'application/json', //because we want to send JSON
          'Authorization':'Bearer $token'
        };  
      
      http.Response resp = await http.get(uri,headers: headers);
        switch (resp.statusCode) {
        case 200:
        case 201:      
          Map<String, dynamic> result = jsonDecode(resp.body);
          return result['data'];        
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to get the user.',
          };
          throw Exception(msg);
  }
  }

  Future<Person> createPerson(newPerson,userId, token) async{
      String endpoint = 'api/people';
        Uri uri = Uri.http(domain,endpoint); //Uri in dart:core
        Map<String, String> headers = {
          'x-my-header': 'adam0457 Eswhar',
          'content-type': 'application/json', //because we want to send JSON
          'Authorization':'Bearer $token'
        };
      Map<String, dynamic> person = {
        'data':{
        'type':"people",
        'attributes': {
          'name':newPerson['name'],
          'birthDate':newPerson['dob'],
          'owner':userId,

        }
        }
        
      };
      String body = jsonEncode(person);

      var resp = await http.post(uri, headers: headers, body: body);
      switch (resp.statusCode) {
        case 200:
        case 201:    
        
          Map<String, dynamic> result = jsonDecode(resp.body);
            print(result['data']['attributes']);
            Person personCreated = Person.fromJson(result['data']['attributes']);
            // return jsonDecode(resp.body);
            return personCreated;
            //return jsonDecode(userRegistered['data']['id']);
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to create this person.',
          };
          throw Exception(msg);
      }
  }

}
