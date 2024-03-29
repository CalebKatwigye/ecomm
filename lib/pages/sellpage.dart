import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/components/mybutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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
  String? selectedLocation;

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

  final List<String> locations = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose',
    // Add more locations as needed
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
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: CircularProgressIndicator(),
          ),
        ),
      );

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
        'uid': user.uid,
        'ad-id': formattedDate,
        'ItemName': itemNameController.text,
        'Description': descriptionController.text,
        'Price': priceController.text,
        'Location': selectedLocation,
        'Category': selectedCategory,
        'TimeStamp': Timestamp.now(),
        'ImageURL': imageUrl,
      });

      // Dismiss loading indicator
      Navigator.pop(context);

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ad Posted!'),
            content: Text(
              'Your ad has been posted! ',
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
        selectedLocation = null;
      });
    } catch (e) {
      print('Error posting ad: $e');
    }
  }

  void validateAndPostAd() {
  if (itemNameController.text.isEmpty ||
      selectedCategory == null ||
      priceController.text.isEmpty ||
      selectedLocation == null ||
      descriptionController.text.isEmpty ||
      selectedImage == null) {
    // If any field is empty or no image is selected, show Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 4, 123, 8),
        content: Text('Please fill out all fields and add an image.'),
        duration: Duration(seconds: 2),
      ),
    );
  } else {
    // All fields are filled, proceed to post the ad
    postAd();
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
                inputFormatters: [ThousandsSeparatorInputFormatter()],
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price. (Only numbers)'),
              ),
              SizedBox(height: 25),
              DropdownButtonFormField<String>(
                value: selectedLocation,
                onChanged: (newValue) {
                  setState(() {
                    selectedLocation = newValue;
                  });
                },
                items: locations.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                    labelText: 'Location'), // Location field added
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
              MyButton(onTap: validateAndPostAd, text: "Post Ad"),
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
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    double value = double.parse(newValue.text.replaceAll(',', ''));
    final formatter = NumberFormat("#,###");
    String newText = formatter.format(value);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}