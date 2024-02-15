import 'package:flutter/material.dart';

class MyProfileTab extends StatelessWidget {
  final String textDescription;
  final String image;
  final VoidCallback onTap;
  const MyProfileTab({
    Key? key,
    required this.textDescription,
    required this.onTap, required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:16.0, right: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(63, 4, 123, 8),
                  width: 2,
                ),
                color: Color.fromARGB(51, 134, 131, 131),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        textDescription,
                        style: TextStyle(color: Color.fromARGB(255, 4, 123, 8), fontSize: 20),
                      ),
                    ],
                  ),
                  ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover, // Adjust the fit as per your requirement
                    width: 130, // Set a specific width to control the size
                    height: 130, // Set a specific height to control the size
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
