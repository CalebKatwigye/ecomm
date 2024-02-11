import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }

  void unsavePost(BuildContext context) async {
    // try {
    //   final user = FirebaseAuth.instance.currentUser!;
    //   await FirebaseFirestore.instance
    //       .collection("Ecomm Users")
    //       .doc(user.uid)
    //       .update({
    //     'savedPosts': FieldValue.arrayRemove([formattedDate])
    //   });
    //   Navigator.of(context).pop();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         'Post unsaved successfully!',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       backgroundColor: Color.fromARGB(255, 4, 123, 8),
    //     ),
    //   );
    // } catch (error) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error unsaving post: $error')),
    //   );
    // }
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
          "Saved",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Ecomm Users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.data() == null) {
              return Center(child: CircularProgressIndicator());
            }

            Map<String, dynamic>? userData =
                snapshot.data!.data() as Map<String, dynamic>?;

            if (userData == null || !userData.containsKey('savedPosts')) {
              return Center(
                child: Text('No saved posts.'),
              );
            }

            List<dynamic>? savedPosts = userData['savedPosts'];

            if (savedPosts == null || savedPosts.isEmpty) {
              return Center(
                child: Text('No saved ads.'),
              );
            }

            return ListView.builder(
              itemCount: savedPosts.length,
              itemBuilder: (context, index) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('UserAdPosts')
                      .doc(savedPosts[index])
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return SizedBox.shrink();
                    }

                    Map<String, dynamic>? postData =
                        snapshot.data!.data() as Map<String, dynamic>?;

                    if (postData == null) {
                      return SizedBox.shrink();
                    }

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
                                    if (postData['ImageURL'] != null)
                                      Image.network(
                                        postData['ImageURL'] ?? '',
                                        width: double.infinity,
                                        height: 300,
                                        fit: BoxFit.contain,
                                      ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Item: '+
                                      postData['ItemName'] ?? '',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Price: UGX '+
                                      postData['Price'] ?? '',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Category: '+
                                      postData['Category'] ?? '',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Description: '+
                                      postData['Description'] ?? '',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors
                                                    .red, // Always red for unsave button
                                              ),
                                            ),
                                            onPressed: () {
                                              unsavePost(
                                                  context); // Call unsavePost function
                                            },
                                            child: Text(
                                              'Unsave',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Color.fromARGB(255, 4, 123, 8),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                        padding: EdgeInsets.all(15), // Adjust padding as needed
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Item: '+
                                    postData['ItemName'] ?? '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                      height:
                                          5), // Add spacing between title and description
                                  Text(
                                    'Price: UGX '+
                                    postData['Price'] ?? '',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  postData['ImageURL'] ??
                                      '', // Use the field containing the image URL
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Add more details here if needed
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
