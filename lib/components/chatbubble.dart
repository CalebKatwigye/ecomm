import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  bool isSender;
  final Map<String, dynamic> data;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ChatBubble(
      {Key? key,
      required this.message,
      required this.data,
      required this.isSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;
    isSender = (data['senderId'] == _firebaseAuth.currentUser!.uid);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              alignment: alignment,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: isSender ? Color.fromARGB(255, 4, 123, 8) : Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft:
                      isSender ? Radius.circular(15.0) : Radius.circular(0.0),
                  topRight:
                      isSender ? Radius.circular(0.0) : Radius.circular(15.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight:
                      isSender ? Radius.circular(0.0) : Radius.circular(15.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
