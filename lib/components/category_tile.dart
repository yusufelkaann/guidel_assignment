import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTile({super.key, 
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

 @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent, // Background color only when selected
          border: Border.all(
            color: Colors.transparent, // Border color 
            width: 2, // Border width
          ),
          borderRadius: BorderRadius.circular(12), // Optional: rounded corners
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black, // Text color change when selected
          ),
        ),
      ),
    );
  }
}