import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("Ecomm Users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading..');
          }

          return ListView(
            children: snapshot.data!.docs
                // Filter out the current user
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  

 Widget _buildUserListItem(DocumentSnapshot document) {
  Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

  if (_auth.currentUser!.email != data?['email']) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(_auth.currentUser!.uid + '_' + data?['uid'])
          .collection("messages")
          .where('isRead', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        bool hasUnreadMessages = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: data?['avatarColor'] ?? Color.fromARGB(255, 1, 75, 4) ,
                backgroundImage: data?['photoURL'] != null ? NetworkImage(data?['photoURL']!) : null,
                child: data?['photoURL'] == null ? Text(data?['username']?.substring(0, 1).toUpperCase() ?? '?',
                  style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                ) : null,
              ),
              title: Text(data?['username'] ?? 'Unknown User', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              subtitle: hasUnreadMessages ? Text('New Message', style: TextStyle(color: Color.fromARGB(255, 4, 123, 8),fontWeight: FontWeight.bold)) : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverEmail: data?['email'],
                      receiverUserID: data?['uid'],
                    ),
                  ),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Divider(
                color: Colors.grey[500],
                height: 0.5,
              ),
            ),
          ],
        );
      },
    );
  } else {
    return Container();
  }
}


}
