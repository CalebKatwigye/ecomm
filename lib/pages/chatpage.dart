import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/chatservice/chatservice.dart';
import 'package:ecomm/components/chatbubble.dart';
import 'package:ecomm/components/mytextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        widget.receiverUserID,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading..");
        }

        // Get messages from snapshot
        List<DocumentSnapshot> documents = snapshot.data!.docs;
        // Mark messages as read
        documents.forEach((doc) {
          _markMessageAsRead(doc);
        });

        return ListView(
          children: documents.map((document) {
            return _buildMessageItem(document);
          }).toList(),
        );
      },
    );
  }

  void _markMessageAsRead(DocumentSnapshot document) async {
    if (!document['isRead'] &&
        document['senderId'] != _firebaseAuth.currentUser!.uid) {
      await document.reference.update({'isRead': true});
    }
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;
    var timeAlignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.bottomRight
        : Alignment.bottomLeft;

    DateTime messageTime = (data['timeStamp'] as Timestamp).toDate();
    String formattedTime =
        DateFormat.jm().format(messageTime); // Format hour:minute AM/PM

    // Check if the message has been read by the receiver
    bool isRead = data['isRead'] ?? false;

    // Determine the color of the ticks based on whether the message has been read
    Color tickColor = isRead ? Colors.blue : Colors.white;

    // Display blue ticks only on the sender's message
    Widget ticksWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          alignment: timeAlignment,
          child: Text(
            formattedTime,
            style: TextStyle(fontSize: 12, color: Colors.grey[300]),
          ),
        ),
        if (data['senderId'] ==
            _firebaseAuth
                .currentUser!.uid) // Add condition only for sender's message
          SizedBox(width: 4), // Add spacing between timestamp and ticks
        // Display blue ticks based on message read status
        if (data['senderId'] == _firebaseAuth.currentUser!.uid)
          Icon(Icons.done_all,
              size: 16, color: tickColor), // Display ticks only for sender
      ],
    );
    // Return an empty SizedBox for the receiver's message

    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 10, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: alignment,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                alignment: alignment == MainAxisAlignment.end
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 2,
                      ),
                      child: Text(
                        data['message'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                        height: 4), // Add spacing between message and timestamp
                    ticksWidget, // Show ticks aligned with the timestamp
                  ],
                ),
                decoration: BoxDecoration(
                  color: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? Color.fromARGB(255, 4, 123, 8) // Green for sender
                      : Colors.grey, // Grey for receiver
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        (data['senderId'] == _firebaseAuth.currentUser!.uid)
                            ? 15.0
                            : 0.0),
                    topRight: Radius.circular(
                        (data['senderId'] == _firebaseAuth.currentUser!.uid)
                            ? 15.0
                            : 15.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(
                        (data['senderId'] == _firebaseAuth.currentUser!.uid)
                            ? 0.0
                            : 15.0),
                  ),
                ),
              ),
            ],
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
