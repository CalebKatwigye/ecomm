import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/pages/categoriespages.dart/cars.dart';
import 'package:ecomm/pages/categoriespages.dart/fashion.dart';
import 'package:ecomm/pages/categoriespages.dart/furniture.dart';
import 'package:ecomm/pages/categoriespages.dart/gadgets.dart';
import 'package:ecomm/pages/categoriespages.dart/groceries.dart';
import 'package:ecomm/pages/categoriespages.dart/houses.dart';
import 'package:ecomm/pages/categoriespages.dart/kids.dart';
import 'package:ecomm/pages/categoriespages.dart/laptops.dart';
import 'package:ecomm/pages/categoriespages.dart/pets.dart';
import 'package:ecomm/pages/categoriespages.dart/trending.dart';

import 'package:ecomm/pages/searchresultspage.dart';

import 'package:flutter/material.dart';
import 'package:ecomm/components/adcard.dart';
import 'package:ecomm/components/mytab.dart';

class HomerPage extends StatefulWidget {
  const HomerPage({Key? key}) : super(key: key);

  @override
  State<HomerPage> createState() => _HomerPageState();
}

class _HomerPageState extends State<HomerPage> {
  String? selectedCategory;

  final List<String> categories = [
    'Cars',
    'Furniture',
    'Fashion',
    'Groceries',
    'Houses',
    'Laptops',
    'Pets',
    'Gadgets',
    'Kids',
  ];

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
              icon: Icon(Icons.search),
              color: Colors.white,
            ),
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 4, 123, 8),
        centerTitle: true,
        title: Text(
          "Go to Search",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 200, //
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 4, 123, 8),
                                      width: 2,
                                    ),
                                    color: Color.fromARGB(51, 134, 131, 131),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        "lib/assets/money.png",
                                        fit: BoxFit.cover,
                                        width: 130,
                                        height: 100,
                                      ),
                                    ),
                                    Text(
                                      "How to sell",
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    GestureDetector(
                        onTap: () {
                          //         Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ChatListPage(),
                          //   ),
                          // );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 6, 77, 200),
                                      width: 2,
                                    ),
                                    color: Color.fromARGB(51, 134, 131, 131),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        "lib/assets/game.png",
                                        fit: BoxFit.cover,
                                        width: 130,
                                        height: 100,
                                      ),
                                    ),
                                    Text(
                                      "Play game",
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 181, 3, 204),
                                      width: 2,
                                    ),
                                    color: Color.fromARGB(51, 134, 131, 131),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        "lib/assets/buy.png",
                                        fit: BoxFit.cover,
                                        width: 130,
                                        height: 100,
                                      ),
                                    ),
                                    Text(
                                      "How to buy",
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 4,
            children: [
              MyTab(
                imagePath: "lib/assets/fire.png",
                textDescription: "Trending",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TrendingPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/car.png",
                textDescription: "Cars",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CarsPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/chair.png",
                textDescription: "Furniture",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FurniturePage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/dress.png",
                textDescription: "Fashion",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FashionPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/food.png",
                textDescription: "Groceries",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GroceriesPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/house.png",
                textDescription: "Houses",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HousesPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/laptop.png",
                textDescription: "Laptops",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LaptopsPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/pets.png",
                textDescription: "Pets",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PetsPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/phone.png",
                textDescription: "Gadgets",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GadgetsPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/toys.png",
                textDescription: "Kids",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KidsPage()),
                  );
                },
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.all(20.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Trending",
                style: TextStyle(fontSize: 23),
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("UserAdPosts")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = snapshot.data!.docs[index];
                      final imageUrl =
                          post['ImageURL']; // Access the 'ImageURL' field

                      return MyAdPost(
                        email: post['UserEmail'],
                        name: post['ItemName'],
                        price: post['Price'],
                        category: post['Category'],
                        description: post['Description'],
                        imageUrl:
                            imageUrl, // Pass the imageUrl to MyAdPost widget
                        formattedDate: snapshot.data!.docs[index].id,
                        location: post['Location'], receiverUserID: post['uid'],
                      );
                    },
                    childCount: snapshot.data!.docs.length,
                  ),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }
              return SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          SliverPadding(padding: EdgeInsets.all(8))
        ],
      ),
    );
  }
}
