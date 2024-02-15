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

  void unsavePost(BuildContext context, String postId) async {
    try {
      // Remove the postId from the 'savedPosts' array in Firestore
      await FirebaseFirestore.instance
          .collection('Ecomm Users')
          .doc(user.uid)
          .update({
        'savedPosts': FieldValue.arrayRemove([postId])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post unsaved successfully!'),
        ),
      );

      // Reload the saved page to reflect changes
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error unsaving post: $error')),
      );
    }
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[400],
                                ),
                                padding: EdgeInsets.all(20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Container(
                                          width:
                                              40, // Adjust the width of the line as per your preference
                                          height: 4.0,
                                          color: Colors.grey,
                                          margin: EdgeInsets.symmetric(
                                              vertical:
                                                  10), // Adjust the margin as per your preference
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      if (postData['ImageURL'] != null)
                                        Image.network(
                                          postData['ImageURL'] ?? '',
                                          width: double.infinity,
                                          height: 300,
                                          fit: BoxFit.contain,
                                        ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Price: UGX ' + postData['Price'] ?? '',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 4, 123, 8)),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Item: ' + postData['ItemName'] ?? '',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Category: ' + postData['Category'] ??
                                            '',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Location: ' + postData['Location'] ?? '',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Description: ' +
                                                postData['Description'] ??
                                            '',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 30),
                                      Divider(
                                        color: Colors.grey[700],
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Adjust the value as per your requirement
                                                    side: BorderSide(
                                                        color: Colors
                                                            .white), // Outline color as white
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  Color.fromARGB(255, 179, 13,
                                                      1), // Always red for unsave button
                                                ),
                                              ),
                                              onPressed: () {
                                                unsavePost(
                                                    context, savedPosts[index]);
                                                Navigator.of(context)
                                                    .pop(); // Call unsavePost function
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
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Adjust the value as per your requirement
                                                    side: BorderSide(
                                                        color: Colors
                                                            .white), // Outline color as white
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  Color.fromARGB(
                                                      255, 4, 123, 8),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Message Vendor',
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
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(51, 134, 131, 131),
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
                                    'Price: UGX ' + postData['Price'] ?? '',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 4, 123, 8)),
                                  ),
                                  Text(
                                    'Item: ' + postData['ItemName'] ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 16),
                                  ),
                                  SizedBox(
                                      height:
                                          15), 
                                   Text(
                                    'Location: ' + postData['Location'] ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 16),
                                  ),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 70,
                                color: Colors.grey,
                                margin: EdgeInsets.symmetric(vertical: 10),
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
