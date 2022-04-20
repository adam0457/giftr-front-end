import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/gift.dart';
import '../data/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

class GiftsScreen extends StatefulWidget {
  GiftsScreen(
      {Key? key,
      required this.token,
      required this.goPeople,
      required this.logout,
      required this.addGift,
      required this.currentPerson,
      required this.currentPersonName})
      : super(key: key);

  String currentPerson; //the id of the current person
  String currentPersonName;
  Function(Enum) goPeople;
  Function(Enum) logout;
  Function addGift;
  String? token;

  @override
  State<GiftsScreen> createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  List<Gift> gifts = <Gift>[];
  HttpHelper helper = HttpHelper();
  void initState() {
    super.initState();
    getGifts(widget.token);  

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //back to the people page using the function from main.dart
            widget.goPeople(Screen.PEOPLE);
          },
        ),
        title: Text('Ideas - ${widget.currentPersonName}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              //logout and return to login screen
              widget.logout(Screen.LOGIN);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: gifts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(gifts[index].name),
              //NumberFormat.simpleCurrency({String? locale, String? name, int? decimalDigits})
              //gifts[index]['price'].toStringAsFixed(2)
              subtitle: Text(
                  '${gifts[index].store['name']} - ${gifts[index].store['productURL']} - ${NumberFormat.simpleCurrency(locale: 'en_CA', decimalDigits: 2).format(gifts[index].price)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      print('delete ${gifts[index].name}');
                      //remove from gifts with setState
                      setState(() {
                        // list.where(func).toList()
                        // is like JS array.filter(func)
                        //real app needs to use API to do this.
                        gifts = gifts
                            .where((gift) => gift.id != gifts[index].id)
                            .toList();
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //go to the add gift page
          widget.addGift();
        },
      ),
    );
  }

 getGifts(token)async{
    List<Gift> result = await helper.getListGifts(widget.currentPerson,token); 
    //print(result);   
    setState(() {
      gifts = result;
    });
    
  }

}
