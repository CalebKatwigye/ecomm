// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecomm/chatservice/chatservice.dart';
// import 'package:ecomm/components/mytextfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   final String receiverEmail;
//   final String receiverUserID;
//   const ChatPage({super.key, required this.receiverEmail, required this.receiverUserID});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ChatService _chatService = ChatService();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


//   void sendMessage()async{
//     if(_messageController.text.isNotEmpty){
//       await _chatService.sendMessage(widget.receiverUserID, _messageController.text);
//       _messageController.clear();
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//        backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(onPressed: (){
//           Navigator.of(context).pop();
//         }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
//         backgroundColor: Color.fromARGB(255, 4, 123, 8),
//         title: Text(widget.receiverEmail, style: TextStyle(color: Colors.white),),
//       ),
//       body: Column(
//         children: [
//           Expanded(child: _buildMessageList()),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageList(){
//     return StreamBuilder(
//       stream: _chatService.getMessages(_firebaseAuth.currentUser!.uid, widget.receiverUserID,), 
//       builder: (context, snapshot){
//         if (snapshot.hasError){
//           return Text("Error ${snapshot.error}");
//         }
//         if (snapshot.connectionState == ConnectionState.waiting){
//           return Text("Loading..");
//         }
//         return ListView(
//           children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
//         );
//       });
//   }

//   Widget _buildMessageItem(DocumentSnapshot document){
//     Map<String, dynamic> data = document.data() as Map<String, dynamic>;

//     //var alignment = (data['senderId']==_firebaseAuth.currentUser!.uid)? Alignment.centerRight: Alignment.centerLeft;

//     return Container(
//       //alignment: alignment,
//       child: Column(
//         //crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end: CrossAxisAlignment.start,
//         children: [
//           Text(data['senderEmail']),
//           Text(data['message']),
//         ],
//       ),
//     );

//   }

//   Widget _buildMessageInput (){
//     return Row(
//       children: [
//         Expanded(
//         child: MyTextFeild(
//           controller: _messageController,
//           hintText: "enter message", 
//           obscureText: false)),
//           IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward, size: 40,))
//           ],
//     );
//   }
// }