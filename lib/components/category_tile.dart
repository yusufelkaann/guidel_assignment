import 'package:flutter/material.dart';
import 'package:guidel_assignment/styles/custom_colors.dart';
import 'package:guidel_assignment/styles/custom_sizes.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: CustomSizes.mediumPadding, vertical: CustomSizes.smallPadding),
        margin: const EdgeInsets.only(right: CustomSizes.margin),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.secondaryColor : CustomColors.tertiary, // Background color only when selected
          border: Border.all(
            color: CustomColors.tertiary, // Border color 
            width: 2, // Border width
          ),
          borderRadius: BorderRadius.circular(CustomSizes.smallradius), // Optional: rounded corners
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? CustomColors.primaryColor : CustomColors.secondaryColor, // Text color change when selected
          ),
        ),
      ),
    );
  }
}