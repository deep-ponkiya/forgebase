import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:forgebase/main.dart';
class AppbarState extends StatefulWidget{
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Material", Icons.settings),
    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("About Us", Icons.info)
  ];
  @override
  AppBars createState()=> AppBars();

}
class AppBars extends State<AppbarState>{
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Home();
      case 1:
        return new MyHomePage();
      case 2:
        return new Settings();
      case 3:
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
  Widget build(BuildContext context) {
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
    return Container(
      height: 55,
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
            icon: Icon(CommunityMaterialIcons.menu,
              color: Colors.black,


            ),
            onPressed: (){
              return Drawer(
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
                                                      style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                                                      children: [
                                                        TextSpan(
                                                          text: 'forge',
                                                        ),
                                                        TextSpan(
                                                            text: 'base',
                                                            style: TextStyle(
                                                                color: Colors.blue
                                                            )
                                                        ),
                                                      ]
                                                  )
                                              ),
                                            )
                                        ),
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
                      )
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Search..",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontFamily: 'GoogleRegular',
                ),
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
                    'https://avatars2.githubusercontent.com/u/24294081?s=460&v=4'),
              ),
            ),
          )
        ],
      ),
    );
  }

}
