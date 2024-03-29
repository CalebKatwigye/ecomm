import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/components/adcard.dart';
import 'package:ecomm/pages/homepage.dart';

import 'package:flutter/material.dart';

class GadgetsPage extends StatefulWidget {
  const GadgetsPage({super.key});

  @override
  State<GadgetsPage> createState() => _GadgetsPageState();
}

class _GadgetsPageState extends State<GadgetsPage> {
  final String selectedCategory = 'Gadgets'; // Specify the desired category

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );}, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
        backgroundColor: Color.fromARGB(255, 4, 123, 8),
        centerTitle: true,
        title: Text(
          "Gadgets",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("UserAdPosts")
              .where('Category', isEqualTo: selectedCategory) // Filter by category
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data!.docs[index];
                  final imageUrl = post['ImageURL'];

                  return MyAdPost(
                    formattedDate:snapshot.data!.docs[index].id,
                    email: post['UserEmail'],
                    name: post['ItemName'],
                    price: post['Price'],
                    category: post['Category'],
                    description: post['Description'],
                    imageUrl: imageUrl,location: post['Location'],receiverUserID: post['uid'],
                    
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
