import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/chatservice/chatservice.dart';
import 'package:ecomm/components/chatbubble.dart';
import 'package:ecomm/components/mytextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverUserID;
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   // Variable to hold the receiver's username
  String receiverUsername = '';

  @override
  void initState() {
    super.initState();
    // Fetch receiver's username from Firestore
    fetchReceiverUsername();
  }

  // Fetch receiver's username from Firestore
  void fetchReceiverUsername() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Ecomm Users")
        .doc(widget.receiverUserID)
        .get();
    if (snapshot.exists) {
      setState(() {
        receiverUsername = snapshot.data()!['username'];
      });
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 4, 123, 8),
        centerTitle: true,
        title: Text(
          receiverUsername,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading..");
          }

          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

 Widget _buildMessageItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

  return Padding(
    padding: const EdgeInsets.only(left: 14.0, right: 14, top: 10),
    child: Row(
      mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          alignment: alignment,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['message'],
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                ? Color.fromARGB(255, 4, 123, 8) // Green for sender
                : Colors.grey,                      // Grey for receiver
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                (data['senderId'] == _firebaseAuth.currentUser!.uid) ? 15.0 : 0.0
              ),
              topRight: Radius.circular(
                (data['senderId'] == _firebaseAuth.currentUser!.uid) ? 15.0 : 15.0
              ),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(
                (data['senderId'] == _firebaseAuth.currentUser!.uid) ? 0.0 : 15.0
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Row(
        children: [
          Expanded(
              child: MyTextFeild(
                  controller: _messageController,
                  hintText: "enter message",
                  obscureText: false)),
          IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.send_rounded,
                size: 35,
                color: Color.fromARGB(255, 4, 123, 8),
              ))
        ],
      ),
    );
  }
}
