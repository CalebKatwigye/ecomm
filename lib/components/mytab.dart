import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  final String imagePath;
  final String textDescription;
  final VoidCallback onTap;

  const MyTab(
      {super.key,
      required this.imagePath,
      required this.textDescription,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color.fromARGB(51, 134, 131, 131),
                    borderRadius: BorderRadius.circular(12)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover, // Adjust the fit as per your requirement
                    width: 50, // Set a specific width to control the size
                    height: 50, // Set a specific height to control the size
                  ),
                ),
              ),
            ),
            // child: Image.asset(imagePath),

            // SizedBox(height: 5,),
            Text(
              textDescription,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ));
  }
}
