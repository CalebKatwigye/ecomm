
import 'package:ecomm/pages/homerpage.dart';
import 'package:ecomm/pages/messages.dart';
import 'package:ecomm/pages/profilepage.dart';
import 'package:ecomm/pages/savedpage.dart';
import 'package:ecomm/pages/sellpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int navBarIndex = 0;

  List navBody = [
    const HomerPage(),
    const SavedPage(),
    const SellPage(),
    const MessagesPage(),
    const ProfilePage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
              color: Colors.grey,
              activeColor: Color.fromARGB(255, 4, 123, 8),
              //tabBackgroundColor: Color.fromARGB(57, 155, 39, 176),
              backgroundColor: Colors.white,
              tabBorderRadius: 12,
              padding: EdgeInsets.all(15),
              gap: 4,
              selectedIndex: navBarIndex,
              onTabChange: (index) {
                setState(() {
                  navBarIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.bookmark_outline,
                  text: "Saved",
                ),
                GButton(
                  icon: Icons.sell_outlined,
                  text: "Sell",
                ),
                GButton(
                  icon: Icons.message_outlined,
                  text: "Messages",
                ),
                GButton(
                  icon: Icons.person_2_outlined,
                  text: "Profile",
                ),
                
              ]),
        ),
      ),
      body: navBody[navBarIndex]
      
    );
  }
}