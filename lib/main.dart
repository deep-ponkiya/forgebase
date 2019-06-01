import 'dart:convert';
import 'dart:async' show Future;
import 'dart:math';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlayStyle, rootBundle;
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'PurchaseOrders.dart';
import 'Material Details List.dart';
import 'Drawer.dart';
import 'LoginPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forgebase',
      routes: <String,WidgetBuilder>{
        "/Mainpage":(BuildContext context)=>Mainpage(),
        "/LoginState":(BuildContext context)=>LoginState()
      },
      home: LoginState(),
    );
  }
}

class Mainpage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Material", Icons.list),
    new DrawerItem("PurchaseOrders", Icons.list),
    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("About Us", Icons.info)
  ];

  @override
  Dashboard createState() => Dashboard();
}

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class Dashboard extends State<Mainpage> {
  List data;
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Home();
      case 1:
        return new MyHomePage();
      case 2:
        return new POState();
      case 3:
        return new Settings();
      case 4:
        return new Settings();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarIconBrightness: Brightness.dark));
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(300),
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: CustomAppBar(),
        ),
      ),
      drawer: Drawer(
        child: Container(
          child: new Center(
              child: Scaffold(
            body: Scrollbar(
                child: Container(
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 70.0,
                        child: DrawerHeader(
                            child: Container(
                          child: RichText(
                              text: TextSpan(
                                  // set the default style for the children TextSpans
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(fontSize: 30),
                                  children: [
                                TextSpan(
                                  text: 'forge',
                                ),
                                TextSpan(
                                    text: 'base',
                                    style: TextStyle(color: Colors.blue)),
                              ])),
                        )),
                      )
                    ],
                  ),
                  ListTile(
                    title: Text(
                      "All Lebles",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    subtitle: new Column(children: drawerOptions),
                  )
                ],
              ),
            )),
          )),
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            offset: Offset(0.2, 0.2),
            color: Colors.grey[400],
          )
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu,color: Colors.black54,),

            onPressed: (){
             return AppbarState();
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: myController,
                decoration: new InputDecoration.collapsed(
                    hintText: 'Search Materials..',)
              ),
            ),
          ),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/715d519f-0e05-4956-8f99-a0dbfd96709f/d2qc5jy-ecc1acd3-c013-4a9e-a6ac-92dbba8c81aa.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzcxNWQ1MTlmLTBlMDUtNDk1Ni04Zjk5LWEwZGJmZDk2NzA5ZlwvZDJxYzVqeS1lY2MxYWNkMy1jMDEzLTRhOWUtYTZhYy05MmRiYmE4YzgxYWEuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.u9FXL-U20gVZ4miAGk13OhvpovI1cBFDzBeHrh2fLAc'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child:  RichText(
              text: TextSpan(
                // set the default style for the children TextSpans
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(fontSize: 30, fontFamily: 'GoogleRegular'),
                  children: [
                    TextSpan(
                        text: '       Coming ',
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                        text: 'soon...', style: TextStyle(color: Colors.blue)),
                    TextSpan(
                      text: '\nforge',
                    ),
                    TextSpan(text: 'base ', style: TextStyle(color: Colors.blue)),
                    TextSpan(
                        text: 'dashboard', style: TextStyle(color: Colors.black)),
                  ])),
        )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data;
  String IP;
  final DatabaseReference database =
      FirebaseDatabase.instance.reference().child("test");

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

  Future<String> getQuote() async {
    String url = "http://192.168.31.22/api/materials/list";
    var response = await http.get(url, headers: {"Accept": "application/json"});
    setState(() {
      var extradata = json.decode(response.body);
      data = extradata["materials"];
    });
  }

  @override
  void initState() {
    this.getData();
    this.getQuote();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> _refresh() async {
    String url = "http://" + IP + "/api/materials/list";
    var response = await http.get(url, headers: {"Accept": "application/json"});
    setState(() {
      var extradata = json.decode(response.body);
      data = extradata["materials"];
    });
  }

  final List<Color> circleColors = [
    Colors.red,
    Colors.green,
    Colors.deepOrange,
    Colors.blue,
    Colors.amberAccent,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: Scrollbar(
            child: ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MDL(id: data[i]["id"],)),
                      );
                    },
                    child: Container(
                      width: 100,
                        child: Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 14.0, right: 14.0, top: 5.0, bottom: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: 40,
                              child: CircleAvatar(
                                backgroundColor: circleColors[i],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      data[i]["name"][0].toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 25.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          data[i]["name"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87,
                                              fontSize: 17.0),
                                        ),
                                        Text(
                                          "10-5-19" /*DateFormat.yMMMMd(data[i]["createdDate"]).toString()*/,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                              fontSize: 13.5),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "MaterialType :  " +
                                                  data[i]["materialType"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                  fontSize: 15.5),
                                            ),
                                            Text(
                                              "ManuFacturer : " +
                                                  data[i]["manufacturer"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                  fontSize: 15.5),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ])),
                  ),
                );
              },
            ),
          )),
    );
  }
}

class Settings extends StatelessWidget {
  final DatabaseReference database =
      FirebaseDatabase.instance.reference().child("test");
  String ip;

  sendData() {
    database.push().set({
      'IP Adress': myController.text,
    });
  }

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      width: 300,
      margin: EdgeInsets.only(left: 30, top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new TextField(
            controller: myController,
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)),
                hintText: 'Your IP Adress Hear',
                labelText: 'IP Adress',
                suffixStyle: const TextStyle(color: Colors.green)),
          ),
          new RaisedButton(
            onPressed: () {
              sendData();
            },
            child: new Text('Send IP'),
          ),
        ],
      ),
    ));
  }
}
class MatirealDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MDL();
  }
}
