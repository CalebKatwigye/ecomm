import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/components/mybutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SellPage extends StatefulWidget {
  const SellPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final itemNameController = TextEditingController();
  String? selectedCategory;
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  File? selectedImage;

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
    // Add more categories as needed
  ];

  Future<void> _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  Future<void> postAd() async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      // Upload image to Firebase Storage
      String imageUrl = await uploadImageToStorage(selectedImage!);

      // Save ad details to Firestore
      await FirebaseFirestore.instance
          .collection("UserAdPosts")
          .doc(formattedDate)
          .set({
        'UserEmail': user.email,
        'ad-id': formattedDate,
        'ItemName': itemNameController.text,
        'Description': descriptionController.text,
        'Price': priceController.text,
        'Category': selectedCategory,
        'TimeStamp': Timestamp.now(),
        'ImageURL': imageUrl,
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ad Posted!'),
            content: Text(
              'Your ad has been posted! You will be notified when it is accepted.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      // Clear form fields
      itemNameController.clear();
      priceController.clear();
      descriptionController.clear();
      setState(() {
        selectedImage = null;
        selectedCategory = null;
      });
    } catch (e) {
      print('Error posting ad: $e');
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
          "Sell",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              SizedBox(height: 25),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 25),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                    labelText: 'Price. (Only numbers)'),
              ),
              SizedBox(height: 25),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _pickImageFromGallery,
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                    color: Colors.grey[200],
                    child: selectedImage != null
                        ? Image.file(selectedImage!)
                        : Icon(Icons.add_a_photo),
                  ),
                ),
              ),
              SizedBox(height: 16),
              MyButton(onTap: postAd, text: "Post Ad"),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
          FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image.');
    }
  }
}
