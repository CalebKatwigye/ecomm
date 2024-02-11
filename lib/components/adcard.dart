import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/pages/messages.dart';
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
  final String imageUrl;

  const MyAdPost({
    Key? key,
    required this.email,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.formattedDate,
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
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (imageUrl != null)
                      Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    SizedBox(height: 20),
                    Text(
                      'Price UGX: $price',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Item: $name',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Category: $category',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Description: $description',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                isUserPost
                                    ? Colors.red
                                    : Color.fromARGB(255, 4, 123, 8),
                              ),
                            ),
                            onPressed: () {
                              if (isUserPost) {
                                deletePost(context);
                              } else {
                                // Implement message seller action
                                
                              }
                            },
                            child: Text(
                              isUserPost ? 'Delete Ad' : 'Message Seller',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                isUserPost
                                    ? Color.fromARGB(255, 4, 123, 8)
                                    : Color.fromARGB(255, 243, 215, 3),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
                  Text('Price: UGX $price'),
                  Text('Item: $name'),
                ],
              ),
              if (imageUrl != null)
                Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
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
