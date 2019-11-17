import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
// import 'package:my_barter/tab_screen2.dart';
// import 'package:my_barter/tab_screen3.dart';
// import 'tab_screen.dart';

class MainScreen extends StatefulWidget {
  final String email;

  const MainScreen({Key key, this.email}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      //   TabScreen("Home", widget.email),
      //   TabScreen2("MyThings"),
      //   TabScreen2("Message"),
      //   TabScreen3("Profile"),
      Text(
        " Email: " + widget.email,
      ),
    ];
  }

  String $pagetitle = "My Trade Barter";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("Things"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("My Things"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail, color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text(
              "Messages",
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }
}
