import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/components/adcard.dart';
import 'package:ecomm/pages/homepage.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  // Stream to listen for ad updates (if applicable)
  Stream<QuerySnapshot> adsStream = FirebaseFirestore.instance
      .collection('UserAdPosts')
      .snapshots();

  @override
  void initState() {
    super.initState();
    // Implement logic to listen to ad updates and update the stream if needed
  }

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
          "Search",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                hintText: 'Search by item name, category, or description',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: adsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading ads'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final ads = snapshot.data!.docs; // List of ad documents

                // Filter ads based on search term
                final filteredAds = ads.where((ad) {
                  final name = ad['ItemName'].toLowerCase();
                  final category = ad['Category'].toLowerCase();
                  final description = ad['Description'].toLowerCase();
                  return name.contains(_searchTerm.toLowerCase()) ||
                      category.contains(_searchTerm.toLowerCase()) ||
                      description.contains(_searchTerm.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredAds.length,
                  itemBuilder: (context, index) {
                    final adData = filteredAds[index];
                    // Extract and pass ad data to your ad display widget
                    return MyAdPost(
                      formattedDate:snapshot.data!.docs[index].id,
                    email: adData['UserEmail'],
                    name: adData['ItemName'],
                    price: adData['Price'],
                    category: adData['Category'],
                    description: adData['Description'],
                    imageUrl: adData['ImageURL'],location: adData['Location'],receiverUserID: adData['uid'],
                     
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}