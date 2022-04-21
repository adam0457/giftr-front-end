import 'package:flutter/material.dart';

class Gift {
    String id = '';
    String name = '';
    int price = 0;
    Map<String, dynamic> store = {'name': '','productURL':''};
      

    Gift({
      required this.id,
      required this.name,
      required this.price,
      required this.store,

    });

    Gift.fromJson(Map<String, dynamic> userMap){
        id = userMap['id'];
        name = userMap['attributes']['name'];
        price = userMap['attributes']['price'] ;
        store =  userMap['attributes']['store'] ?? {'name':'','productURL':''} ;
      
    }

}

