import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './user.dart';
import './person.dart';
import './gift.dart';


class HttpHelper {
  final String domain = 'localhost:3030';  

  Future<User> createUser(newUser) async{
  
        String endpoint = 'auth/users';
        Uri uri = Uri.http(domain,endpoint); 
        Map<String, String> headers = {
          'x-my-header': 'My name',
          'content-type': 'application/json', 
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
            Map<String, dynamic> userRegistered = jsonDecode(resp.body);
            User currentUser = User.fromJson(userRegistered['data']);
            return currentUser;           
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to create a user.',
          };
          throw Exception(msg);
      }
  }
  
  
  Future<Map> connectUser(usr) async{
      String endpoint = 'auth/tokens';
        Uri uri = Uri.http(domain,endpoint); 
        Map<String, String> headers = {
          'x-my-header': 'my name',
          'content-type': 'application/json', 
        };
      Map<String, dynamic> connectUser = {
        'data':{
        'type':"users",
        'attributes':{
          'email': usr['email'],
          'password': usr['password']
        }      
        }
        
      };
      String body = jsonEncode(connectUser);      

      var resp = await http.post(uri, headers: headers, body: body);
      switch (resp.statusCode) {
        case 200:
        case 201:          
          Map<String, dynamic> data = jsonDecode(resp.body);        
          
          return jsonDecode(resp.body);          
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to connect the user.',
          };
          throw Exception(msg);
      }
  }
  
  
  Future<List<Person>> getListPeople(token) async {
    String endpoint = 'api/people';
        Uri uri = Uri.http(domain,endpoint); 
        Map<String, String> headers = {
          'x-my-header': 'my name',          
          'Authorization':'Bearer $token'
        };  
      
      http.Response resp = await http.get(uri,headers: headers);
    
        switch (resp.statusCode) {
        case 200:
        case 201: 
        
            Map<String, dynamic> result = jsonDecode(resp.body);         
            if(result['data'].length > 0){
                List<Person> people = result['data'].map<Person>((item){
                Person person = Person.fromJson(item['attributes']);
                return person;
                }).toList();
                return people;
            } 
          return  <Person> [];     
          default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to get the list of person.',
          };
          throw Exception(msg);
      }     
      
  }

  
  Future<Map> getLoggedInUser(token) async{
      String endpoint = 'auth/users/me';
        Uri uri = Uri.http(domain,endpoint); 
        Map<String, String> headers = {
          'x-my-header': 'adam0457 eshwar',
          'content-type': 'application/json', 
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
        Uri uri = Uri.http(domain,endpoint); 
        Map<String, String> headers = {
          'x-my-header': 'adam0457 Eswhar',
          'content-type': 'application/json', 
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
            return personCreated;           
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to create this person.',
          };
          throw Exception(msg);
      }
  }

  
  Future<Person> editPerson(personEdited, userId, personId, token) async{
      String endpoint = 'api/people/$personId';
        Uri uri = Uri.http(domain,endpoint); 
        Map<String, String> headers = {
          'x-my-header': 'adam0457 Eswhar',
          'content-type': 'application/json', 
          'Authorization':'Bearer $token'
        };
      Map<String, dynamic> person = {
        'data':{
        'type':"people",
        'attributes': {
          'name':personEdited['name'],
          'birthDate':personEdited['dob'],
          'owner':userId,

        }
        }
        
      };
      String body = jsonEncode(person);

      var resp = await http.patch(uri, headers: headers, body: body);
      switch (resp.statusCode) {
        case 200:
        case 201:    
        
          Map<String, dynamic> result = jsonDecode(resp.body);
            print(result['data']['attributes']);
            Person personCreated = Person.fromJson(result['data']['attributes']);           
            return personCreated;            
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to edit this person.',
          };
          throw Exception(msg);
      }
  }

  
  Future<Person> deletePerson(personId, token) async{
      String endpoint = 'api/people/$personId';
        Uri uri = Uri.http(domain,endpoint); 
        Map<String, String> headers = {
          'x-my-header': 'adam0457 Eswhar',
          'content-type': 'application/json', 
          'Authorization':'Bearer $token'
        };      

      var resp = await http.delete(uri, headers: headers);
      switch (resp.statusCode) {
        case 200:
        case 201:    
        
          Map<String, dynamic> result = jsonDecode(resp.body);
            print(result['data']['attributes']);
            Person personCreated = Person.fromJson(result['data']['attributes']);
            return personCreated;           
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to delete this person.',
          };
          throw Exception(msg);
      }


  }
  
  
  Future<List<Gift>> getListGifts(personId,token) async {
    String endpoint = 'api/people/$personId/gifts';
        Uri uri = Uri.http(domain,endpoint); //Uri in dart:core
        Map<String, String> headers = {
          'x-my-header': 'my name',
          'Authorization':'Bearer $token'
        };  
      
      http.Response resp = await http.get(uri,headers: headers);
        switch (resp.statusCode) {
        case 200:
        case 201:          
          print('good job');
          Map<String, dynamic> result = jsonDecode(resp.body);
          //print(result['data']);
          if(result['data'].length > 0){
              List<Gift> gifts = result['data'].map<Gift>((item){
              Gift gift = Gift.fromJson(item);
              return gift;
              }).toList();
              return gifts;
          } 
          return  <Gift> [];       
        
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to get the list of gifts.',
          };
          throw Exception(msg);
      }     
      
  }
  
  
  Future<void> createGift(newGift,personId, token) async{
      String endpoint = 'api/people/$personId/gifts';
        Uri uri = Uri.http(domain,endpoint); //Uri in dart:core
        Map<String, String> headers = {
          'x-my-header': 'adam0457 Eswhar',
          'content-type': 'application/json', //because we want to send JSON
          'Authorization':'Bearer $token'
        };
      Map<String, dynamic> gift = {
          'data': {
                    'type': 'gifts',
                    'attributes': {
                                    'name':newGift['name'],
                                    'price':newGift['price'],
                                    'store':{
                                              'name': newGift['store'],
                                              'productURL':newGift['url']
                                            }

                                    }
            }
        
      };
      String body = jsonEncode(gift);

      var resp = await http.post(uri, headers: headers, body: body);
      switch (resp.statusCode) {
        case 200:
        case 201:    
        
          
            break;
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to create this gift.',
          };
          throw Exception(msg);
      }
  }


  Future<void> deleteGift(personId,giftId, token) async{
      String endpoint = 'api/people/$personId/gifts/$giftId';
        Uri uri = Uri.http(domain,endpoint); 
        Map<String, String> headers = {
          'x-my-header': 'adam0457 Eswhar',
          'content-type': 'application/json', 
          'Authorization':'Bearer $token'
        };      

      var resp = await http.delete(uri, headers: headers);
      switch (resp.statusCode) {
        case 200:
        case 201:
                print('The gift has been deleted');
          
            break;         
        default:
          Map<String, dynamic> msg = {
            'code': resp.statusCode,
            'message': 'Bad things happening. Failed to delete this gift.',
          };
          throw Exception(msg);
      }


  }

}
