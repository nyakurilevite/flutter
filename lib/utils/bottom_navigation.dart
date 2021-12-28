import 'package:flutter/material.dart';
import '../screens/home_page_screen.dart';
import '../screens/profile.dart';

class BottomMenu extends StatefulWidget {
  String account_id;
  int curr_index;
  BottomMenu({Key? key,required this.account_id,required this.curr_index}) : super(key: key);

  @override
  _State createState() => _State(this.account_id,this.curr_index);
}

class _State extends State<BottomMenu> {
  String acc_id;
  int curr_index;
  _State(this.acc_id,this.curr_index);
  late ValueChanged<int> onClicked;
  int selectedIndex = 0;

  //list of widgets to call ontap
  /*var widgetOptions = [
    HomePageScreen(account_id:this.acc_id),
    ProfileScreen(),
  ];*/

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              index==0?HomePageScreen(account_id:this.acc_id,curr_index:selectedIndex):
              index==4?ProfileScreen(account_id:this.acc_id,curr_index:selectedIndex):
              HomePageScreen(account_id:this.acc_id,curr_index:selectedIndex),
          ),

      );
    });
  }
  //BottomMenu({this.selectedIndex, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,size:36),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search,size:36),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.add,size:36),
            label: ''
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message,size:36),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          icon:Icon(Icons.account_circle,size:36),
          label: 'Me',
        )
      ],
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.black,
      currentIndex: this.curr_index,
      onTap: onItemTapped,
    );
  }

}