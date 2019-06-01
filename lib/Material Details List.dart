import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class MDL extends StatefulWidget{
  final String id;

  MDL({Key key, @required this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MaterialList(id);
  }

}
class MaterialList extends State<MDL>{
  String id,
      name,
      createdDate,
      materialType,
      manufacturer,
      modifiedDate,
      conversion,
      createdBy,
      modifiedBy;
  String Mid;
  MaterialList(this.Mid);

  //GET JSON DATA FROM API
  bool isData = false;
  String IP;
  final DatabaseReference database =
  FirebaseDatabase.instance.reference().child("test");

  FetchJSON() async {
    var Response = await http.get(
      "http://192.168.31.22/api/materials/details/" + Mid,
      headers: {"Accept": "application/json"},
    );

    if (Response.statusCode == 200) {
      String responseBody = Response.body;
      var responseJSON = json.decode(responseBody);
      id = responseJSON['id'];
      name = responseJSON['name'];
      materialType = responseJSON['materialType'];
      manufacturer = responseJSON['manufacturer'];
      createdDate = responseJSON['createdDate'];
      modifiedDate = responseJSON['modifiedDate'];
      conversion = responseJSON['conversion'];
      createdBy = responseJSON['createdBy'];
      modifiedBy = responseJSON['modifiedBy'];

      isData = true;
      setState(() {
        print('SUCCESS');
      });
    } else {
      print('Something went wrong. \nResponse Code : ${Response.statusCode}');
    }
  }

  //CALL FETCHJSON METHOD
  @override
  void initState() {
    FetchJSON();
    getData();
  }

  //END GET DAT FROM JSON

  //PULL REFRESS CODE
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  Future<Null> _refresh() async {
    var Response = await http.get(
      "http://192.168.31.22/api/materials/details/" + Mid,
      headers: {"Accept": "application/json"},
    );

    if (Response.statusCode == 200) {
      String responseBody = Response.body;
      var responseJSON = json.decode(responseBody);
      id = responseJSON['id'];
      name = responseJSON['name'];
      materialType = responseJSON['materialType'];
      manufacturer = responseJSON['manufacturer'];
      createdDate = responseJSON['createdDate'];
      modifiedDate = responseJSON['modifiedDate'];
      conversion = responseJSON['conversion'];
      createdBy = responseJSON['createdBy'];
      modifiedBy = responseJSON['modifiedBy'];

      isData = true;
      setState(() {
        print('SUCCESS');
      });
    } else {
      print('Something went wrong. \nResponse Code : ${Response.statusCode}');
    }
  }
  final List<Color> circleColors = [
    Colors.red,
    Colors.green,
    Colors.deepOrange,
    Colors.blue,
    Colors.lightGreenAccent,
    Colors.purple,
    Colors.blueGrey,
    Colors.deepPurpleAccent,
    Colors.redAccent,
    Colors.teal,
    Colors.deepPurpleAccent,
    Colors.purpleAccent,
    Colors.black12,
    Colors.orangeAccent,
    Colors.lightBlueAccent,
    Colors.indigo,
    Colors.cyan,
    Colors.lightGreen
  ];

  Container _getToolbar(BuildContext context) {
    return new Container(
      height: 30,
      margin: new EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, right: 280),
      child: new BackButton(color: Colors.white),
    );
  }

  Container _getBackground() {
    return new Container(
      decoration: new BoxDecoration(
          image: new DecorationImage(image: new NetworkImage("https://cdn.wallpapersafari.com/35/13/ptkifa.jpg"),
              fit: BoxFit.cover)
      ),
      constraints: new BoxConstraints.expand(height: 200.0,),
    );
  }
  void getData() {
    /*database.once().then((DataSnapshot snapshot) {
      IP=snapshot.value.toString();
    });
*/
    database.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        IP = values["IP Adress"];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Container(
          constraints: new BoxConstraints.expand(),
          color: Colors.white,
          child: Scrollbar(
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      _getBackground(),
                      _getToolbar(context),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 80,
                            width: 80,
                            margin: EdgeInsets.only(left: 20, top: 100),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    name[0].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 45.0, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            margin: EdgeInsets.only(top: 90, left: 10),
                            child: Text(
                              name,
                              style: TextStyle(color: Colors.white, fontSize: 28),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Text("ALL",style: TextStyle(fontSize: 15,color: Colors.grey),),
                  ListTile(
                    title: Text('MaterialType ' ,style: TextStyle(color: Colors.grey,fontSize: 15),),
                    subtitle: Text(materialType ,style: TextStyle(color: Colors.black,fontSize: 15),),
                  ),
                  Divider(height: 1),
                  ListTile(
                    title: Text('Manufacturer ' ,style: TextStyle(color: Colors.grey,fontSize: 15),),
                    subtitle: Text(manufacturer ,style: TextStyle(color: Colors.black,fontSize: 15),),
                  ),
                  Divider(height: 1),
                  ListTile(
                    title: Text('CreatedDate ' ,style: TextStyle(color: Colors.grey,fontSize: 15),),
                    subtitle: Text("10/5/2019"/*createdDate*/ ,style: TextStyle(color: Colors.black,fontSize: 15),),
                  ),
                  Divider(height: 1),
                  ListTile(
                    title: Text('ModifiedDate ' ,style: TextStyle(color: Colors.grey,fontSize: 15),),
                    subtitle: Text("10/5/2019"/*modifiedDate*/ ,style: TextStyle(color: Colors.black,fontSize: 15),),
                  ),
                  Divider(height: 1), ListTile(
                    title: Text('Conversion ' ,style: TextStyle(color: Colors.grey,fontSize: 15),),
                    subtitle: Text(conversion ,style: TextStyle(color: Colors.black,fontSize: 15),),
                  ),
                  Divider(height: 1), ListTile(
                    title: Text('CreatedBy ' ,style: TextStyle(color: Colors.grey,fontSize: 15),),
                    subtitle: Text(createdBy ,style: TextStyle(color: Colors.black,fontSize: 15),),
                  ),
                ],
              )),
        ),
      )
    );
  }

}