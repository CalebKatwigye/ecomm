import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/components/adcard.dart';
import 'package:ecomm/pages/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 4, 123, 8),
        centerTitle: true,
        title: Text(
          "Messages",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      //body: _buildUserList(),
    );
  }

  // Widget _buildUserList() {
    

  //   return StreamBuilder(
  //       stream:
  //           FirebaseFirestore.instance.collection("Ecomm Users").snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return const Text('error');
  //         }
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Text('loading..');
  //         }

  //         return ListView(
  //           children: snapshot.data!.docs
  //               // Filter out the current user
  //               .map<Widget>((doc) => _buildUserListItem(doc))
  //               .toList(),
  //         );
  //       });
  // }

  // Widget _buildUserListItem(DocumentSnapshot document) {
  //   Map<String, dynamic>? data =
  //       document.data() as Map<String, dynamic>?; // Nullable map

  //   if (_auth.currentUser!.email != data?['email']) {
  //     return ListTile(
  //     title: Text(data?['email']), // Convert to string if not null
  //     onTap: () {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => ChatPage(
  //                     receiverEmail: data?['email'],
  //                     receiverUserID: data?['username'],
  //                   )));
  //     }); // Return an empty widget if data is null or email/username is null
  //   }else{
  //     return Container();
  //   }

  //   // return ListTile(
  //   //   title: Text(data['username']), // Convert to string if not null
  //   //   onTap: () {
  //   //     Navigator.push(
  //   //         context,
  //   //         MaterialPageRoute(
  //   //             builder: (context) => ChatPage(
  //   //                   receiverEmail: data['email'],
  //   //                   receiverUserID: data['username'],
  //   //                 )));
  //   //   },
  //   // );
  // }
}
