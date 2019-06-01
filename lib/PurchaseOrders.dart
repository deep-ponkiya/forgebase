import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'main.dart';

class POState extends StatefulWidget {
  @override
  PO createState() => new PO();
}

class PO extends State<POState> {
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
    String url = "http://192.168.31.22/api/PurchaseOrders/List";
    var response = await http.get(url, headers: {"Accept": "application/json"});
    setState(() {
      var extradata = json.decode(response.body);
      data = extradata["purchaseOrders"];
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
    String url = "http://" + IP + "/api/PurchaseOrders/List";
    var response = await http.get(url, headers: {"Accept": "application/json"});
    setState(() {
      var extradata = json.decode(response.body);
      data = extradata["purchaseOrders"];
    });
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

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarIconBrightness: Brightness.dark));
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
                            builder: (context) =>
                                PODetails(
                                  id: data[i]["id"],
                                )),
                      );
                    },
                    child: Container(
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
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Text(
                                          data[i]["supplier"][0].toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.white),
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
                                              data[i]["number"],
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
                                                  data[i]["supplier"],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      color: Colors.black54,
                                                      fontSize: 15.5),
                                                ),
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

class PODetails extends StatefulWidget {
  final String id;

  PODetails({Key key, @required this.id}) : super(key: key);

  @override
  PoStates createState() => new PoStates(id);
}

class PoStates extends State<PODetails> {
  String id,
      number,
      createdDate,
      status,
      createdBy,
      amountInWords,
      supplier,
      poMaterials;
  String Mid;
  double amount;
  List PO,GRN;

  PoStates(this.Mid);

  //GET JSON DATA FROM API
  bool isData = false;
  //GRN DATA FATCH FROM API
  FetchGRN() async {
    var Response = await http.get(
      "http://192.168.31.22/api/PurchaseOrders/Details/" + Mid,
      headers: {"Accept": "application/json"},
    );
    if (Response.statusCode == 200) {
      String responseBody = Response.body;
      var responseJSON = json.decode(responseBody);
      id = responseJSON['id'];
      number = responseJSON['number'];
      createdDate = responseJSON['createdDate'];
      status = responseJSON['status'];
      createdBy = responseJSON['createdBy'];
      amount = responseJSON['amount'];
      amountInWords = responseJSON['amountInWords'];
      supplier = responseJSON['supplier'];
      PO = responseJSON["poMaterials"];

      isData = true;
      setState(() {
        print('SUCCESS');
      });
    } else {
      print('Something went wrong. \nResponse Code : ${Response.statusCode}');
    }
  }


  //PO DATA FATCH FROM API
  FetchJSON() async {
    var Response = await http.get(
      "http://192.168.31.22/api/PurchaseOrders/Details/" + Mid,
      headers: {"Accept": "application/json"},
    );
    if (Response.statusCode == 200) {
      String responseBody = Response.body;
      var responseJSON = json.decode(responseBody);
      id = responseJSON['id'];
      number = responseJSON['number'];
      createdDate = responseJSON['createdDate'];
      status = responseJSON['status'];
      createdBy = responseJSON['createdBy'];
      amount = responseJSON['amount'];
      amountInWords = responseJSON['amountInWords'];
      supplier = responseJSON['supplier'];
      PO = responseJSON["poMaterials"];

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
    FetchGRN();
  }

  //PULL REFRESS CODE
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  Future<Null> _refresh() async {
    var Response = await http.get(
      "http://192.168.31.22/api/PurchaseOrders/Details/" + Mid,
      headers: {"Accept": "application/json"},
    );

    if (Response.statusCode == 200) {
      String responseBody = Response.body;
      var responseJSON = json.decode(responseBody);
      id = responseJSON['id'];
      number = responseJSON['number'];
      createdDate = responseJSON['createdDate'];
      status = responseJSON['status'];
      createdBy = responseJSON['createdBy'];
      amount = responseJSON['amount'];
      amountInWords = responseJSON['amountInWords'];
      supplier = responseJSON['supplier'];

      isData = true;
      setState(() {
        print('SUCCESS');
      });
    } else {
      print('Something went wrong. \nResponse Code : ${Response.statusCode}');
    }
  }

  //END REFRESS CODE
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
//GET TOOLBAR CODE
  Container _getToolbar(BuildContext context) {
    return new Container(
      height: 30,
      margin: new EdgeInsets.only(
          top: MediaQuery
              .of(context)
              .padding
              .top, right: 280),
      child: new BackButton(color: Colors.white),
    );
  }

  //GET BACKGROUND CODE

  Container _getBackground() {
    return new Container(
      decoration: BoxDecoration(color: Colors.blue),
      constraints: new BoxConstraints.expand(
        height: 200.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(200),
            child: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(text: "Details",),
                  Tab(text: "Materials"),
                  Tab(text: "GRN")
                ],
              ),
              title: Text(number),
            ),
          ),
          body: TabBarView(
            children: [
              Scrollbar(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'CreatedDate ',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      subtitle: Text(
                        createdDate,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    Divider(height: 1),
                    ListTile(
                      title: Text(
                        'Status ',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      subtitle: Text(
                        status,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    Divider(height: 1),
                    ListTile(
                      title: Text(
                        'CreatedBy ',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      subtitle: Text(
                        createdBy,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    Divider(height: 1),
                    ListTile(
                      title: Text(
                        'Amount ',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      subtitle: Text(
                        amount.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    Divider(height: 1),
                    ListTile(
                      title: Text(
                        'AmountInWords ',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      subtitle: Text(
                        amountInWords,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    Divider(height: 1),
                    ListTile(
                      title: Text(
                        'Supplier ',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      subtitle: Text(
                        supplier,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              )
             ,ListView.builder(
                itemCount: PO.length,
                itemBuilder: (context, position) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Material ',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          subtitle: Text(
                            PO[position]["material"],
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Divider(height: 1),
                        ListTile(
                          title: Text(
                            'Quantity ',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          subtitle: Text(
                            PO[position]["quantity"].toString(),
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Divider(height: 1),
                        ListTile(
                          title: Text(
                            'ExpectedDelivery ',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          subtitle: Text(
                            PO[position]["expectedDelivery"],
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          title: Text(
                            'Status ',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          subtitle: Text(
                            PO[position]["status"],
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ],
                    )
                  );
                },
              ),
              Center(
                child: Text("Loading..",style: TextStyle(fontSize: 20),),
              )
            ],
          ),
        ),
      ),
    );
  }
}