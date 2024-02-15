import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/components/mybutton.dart';
import 'package:ecomm/components/mytextbox.dart';
import 'package:ecomm/pages/loginpage.dart';
import 'package:ecomm/pages/myadspage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilerPage extends StatefulWidget {
  const ProfilerPage({super.key});

  @override
  State<ProfilerPage> createState() => _ProfilerPageState();
}

class _ProfilerPageState extends State<ProfilerPage> {
  final user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? userData; // Initialize userData as nullable
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  //signout method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(
                onTap: () {},
              )),
    );
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        userData = await FirebaseFirestore.instance
            .collection("Ecomm Users")
            .doc(user.uid)
            .get();
      } catch (error) {
        print('Error fetching user data: $error');
        // Implement error handling here
      } finally {
        setState(() {
          isLoading = false; // Update loading state after fetching
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 4, 123, 8),
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : userData == null
                ? Center(child: Text('No user data found'))
                : CustomScrollView(
                    slivers: [
                      SliverPadding(padding: EdgeInsets.only(top: 20)),
                      // SliverToBoxAdapter(
                      //   child: Icon(Icons.person, size: 72,),
                      // ),
                      // SliverPadding(padding: EdgeInsets.only(top: 20)),
                      // SliverToBoxAdapter(
                      //   child: Column(
                      //     children: [
                      //       Text('Email: '+userData!.get('email') as String, style: TextStyle(color: Colors.grey[800], fontSize: 18),),
                      //       SizedBox(height: 10,),
                      //       Text('Username: '+userData!.get('username') as String, style: TextStyle(color: Colors.grey[800], fontSize: 18),),
                      //       SizedBox(height: 10,),
                      //       Text('Phone number: '+userData!.get('phonenumber') as String, style: TextStyle(color: Colors.grey[800], fontSize: 18),),
                      //       SizedBox(height: 10,),
                      //       Text('Address: '+userData!.get('address') as String, style: TextStyle(color: Colors.grey[800], fontSize: 18),),

                      //     ],
                      //   ),
                      // ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25, top: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'MY DETAILS',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 59, 68, 60),
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EMAIL: ',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 4, 123, 8),
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userData!.get('email') as String,
                                    style: TextStyle(
                                        color: Colors.grey[800], fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NAME: ',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 4, 123, 8),
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userData!.get('username') as String,
                                    style: TextStyle(
                                        color: Colors.grey[800], fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PHONE: ',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 4, 123, 8),
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userData!.get('phonenumber') as String,
                                    style: TextStyle(
                                        color: Colors.grey[800], fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ADDRESS: ',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 4, 123, 8),
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userData!.get('address') as String,
                                    style: TextStyle(
                                        color: Colors.grey[800], fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(
                                color: Color.fromARGB(255, 161, 159, 159),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SliverPadding(padding: EdgeInsets.only(bottom: 40)),
                      SliverToBoxAdapter(
                          child: MyProfileTab(
                              image: 'lib/assets/ads.png',
                              textDescription: "My Ads",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserPostsPage()),
                                );
                              })),
                      SliverToBoxAdapter(
                          child: MyProfileTab(
                              image: 'lib/assets/faq.png',
                              textDescription: "FAQ",
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => ProfilerPage()),
                                // );
                              })),
                      SliverPadding(padding: EdgeInsets.only(bottom: 40)),
                      SliverToBoxAdapter(
                        child: MyButton(onTap: signUserOut, text: "Logout"),
                      )
                    ],
                  ));
  }
}
