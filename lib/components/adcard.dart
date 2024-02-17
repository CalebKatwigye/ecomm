import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/pages/chatpage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyAdPost extends StatelessWidget {
  final String email;
  final String name;
  final String price;
  final String category;
  final String description;
  final String formattedDate;
  final String location;
  final String imageUrl;
   final String receiverUserID; 

  const MyAdPost({
    Key? key,
    required this.email,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.formattedDate,
    required this.location, required this.receiverUserID,
  }) : super(key: key);

  void savePost(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection("Ecomm Users")
          .doc(user.uid)
          .update({
        'savedPosts': FieldValue.arrayUnion([formattedDate])
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post saved successfully!',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 4, 123, 8),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving post: $error')),
      );
    }
  }

  void deletePost(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("UserAdPosts")
          .doc(formattedDate)
          .delete();

      if (imageUrl != null) {
        Reference reference = FirebaseStorage.instance.refFromURL(imageUrl!);
        await reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ad deleted successfully!')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting ad: $error')),
      );
    }
  }

   void messageVendor(BuildContext context) {
    // Navigate to the ChatPage with receiver's details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverEmail: email,
          receiverUserID: receiverUserID,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final bool isUserPost = user.email == email;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[400],
                ),
                padding: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4.0,
                          color: Colors.grey,
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (imageUrl != null)
                        Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                      SizedBox(height: 20),
                      Text(
                        'PRICE: UGX $price',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 4, 123, 8)),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Item: $name',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Category: $category',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Location: $location',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Description: $description',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 30),
                      Divider(
                        color: Colors.grey[700],
                      ),
                      SizedBox(height: 30),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the value as per your requirement
                                    side: BorderSide(
                                        color: Colors
                                            .white), // Outline color as white
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  isUserPost
                                      ? Color.fromARGB(255, 179, 13, 1)
                                      : Color.fromARGB(255, 4, 123, 8),
                                ),
                              ),
                              onPressed: () {
                                if (isUserPost) {
                                  deletePost(context);
                                } else {
                                  // Implement message seller action
                                  messageVendor(context);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => ChatPage(receiverEmail: 'email', receiverUserID: 'uid',)));
                                }
                              },
                              child: Text(
                                isUserPost ? 'Delete Ad' : 'Message Vendor',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the value as per your requirement
                                    side: BorderSide(
                                        color: Colors
                                            .white), // Outline color as white
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  isUserPost
                                      ? Color.fromARGB(255, 4, 123, 8)
                                      : Color.fromARGB(255, 243, 191, 3),
                                ),
                              ),
                              onPressed: () {
                                if (isUserPost) {
                                  Navigator.of(context).pop();
                                } else {
                                  savePost(context);
                                }
                              },
                              child: Text(
                                isUserPost ? 'Cancel' : 'Save',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(51, 134, 131, 131),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        padding: EdgeInsets.all(25),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRICE: UGX $price',
                    style: TextStyle(
                        fontSize: 17, color: Color.fromARGB(255, 4, 123, 8)),
                  ),
                  Text(
                    'Item: $name',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '$location',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 70,
                color: Colors.grey,
                margin: EdgeInsets.symmetric(vertical: 10),
              ),
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Text('No Image'),
            ],
          ),
        ),
      ),
    );
  }
}
