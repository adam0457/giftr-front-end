import 'package:flutter/material.dart';

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

class AddGiftScreen extends StatefulWidget {
  AddGiftScreen(
      {Key? key,
      required this.nav,
      required this.currentPerson,
      required this.currentPersonName,
      required this.logout,
      required this.addGift})
      : super(key: key);

  Function nav;
  Function addGift;
  Function logout;
  String currentPersonName; // could be empty string
  String currentPerson; //could be zero

  @override
  State<AddGiftScreen> createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final nameController = TextEditingController();
  final storeController = TextEditingController();
  final urlController = TextEditingController();
  final priceController = TextEditingController();
  //create global ref key for the form
  final _formKey = GlobalKey<FormState>();
  //state value for user login
  Map<String, dynamic> gift = {'name': '', 'store': '', 'url':'','price': 0};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //back to the people page using the function from main.dart
            widget.nav(Screen.GIFTS);
          },
        ),
        title: Text('Add Gift - ${widget.currentPersonName}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildName(),
                SizedBox(height: 16),
                _buildStore(),
                SizedBox(height: 16),
                _buildUrl(),
                SizedBox(height: 16),
                _buildPrice(),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                        //print(gift);
                        widget.addGift(gift);
                        widget.nav(Screen.GIFTS);
                    }else {
                                //form failed validation so exit
                                return;
                              }
                    
                    //use the API to save the new gift for the person
                    //after confirming the save then
                    //go to the gifts screen
                  
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _styleField(String label, String hint) {
    return InputDecoration(
      labelText: label, // label
      labelStyle: TextStyle(color: Colors.black87),
      hintText: hint, //placeholder
      hintStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(),
    );
  }

  TextFormField _buildName() {
    return TextFormField(
      decoration: _styleField('Idea Name', 'gift idea'),
      controller: nameController,
      obscureText: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
       // print('called validator in email');
        if (value == null || value.isEmpty) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          gift['name'] = value;
        });
      },
    );
  }

  TextFormField _buildStore() {
    return TextFormField(
      decoration: _styleField('Store name', 'Store name'),
      controller: storeController,
      obscureText: false,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
       // print('called validator in store url');
        if (value == null || value.isEmpty) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          gift['store'] = value;
        });
      },
    );
  }

   TextFormField _buildUrl() {
    return TextFormField(
      decoration: _styleField('Store URL', 'Store URL'),
      controller: urlController,
      obscureText: false,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
       // print('called validator in store url');
        if (value == null || value.isEmpty) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          gift['url'] = value;
        });
      },
    );
  }

  TextFormField _buildPrice() {
    return TextFormField(
      decoration: _styleField('Price', 'Approximate gift price'),
      controller: priceController,
      obscureText: false,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a price';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          if (value != null) {
            gift['price'] = num.parse(value);
          }
        });
      },
    );
  }
}
