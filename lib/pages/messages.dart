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
    Map<String, dynamic>? data =
        document.data() as Map<String, dynamic>?; // Nullable map

    if (_auth.currentUser!.email != data?['email']) {
      return Column(
        children: [
          ListTile(
            // Leading avatar with customizable colors and initials
            leading: CircleAvatar(
              radius: 25.0, // Adjust radius as needed
              backgroundColor: data?['avatarColor'] ??
                  const Color.fromARGB(
                      255, 91, 89, 89), // Use provided avatarColor or a default
              backgroundImage:
                  (data?['photoURL'] != null) // Check for photoURL first
                      ? NetworkImage(
                          data?['photoURL']!) // Use photoURL if available
                      : null, // Otherwise, use initials
              child: (data?['photoURL'] ==
                      null) // If no photoURL, create initials
                  ? Text(
                      // Extract initials from username or use placeholder
                      data?['username']?.substring(0, 1).toUpperCase() ?? '?',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),

            // Title with customizable font size and weight
            title: Text(
              data?['username'] ?? 'Unknown User', // Handle missing username
              style: TextStyle(
                fontSize: 16.0, // Adjust font size
                fontWeight:
                    FontWeight.bold, // Consider adjusting weight as needed
              ),
            ),

            // Tap action
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

            // Add visual polish with a subtle elevation
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0), // Adjust padding as needed
            // Customize elevation as desired
          ),
          Padding(
            padding: const EdgeInsets.only(left:15.0, right: 15),
            child: Divider(
              color: Colors.grey[500], // Customize color as needed
              height: 0.5, // Adjust height as needed
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
