import 'package:flutter/material.dart';

Widget buildTab(
  BuildContext context,
  String title,
  bool selected,
  VoidCallback onTap,
) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Stack(
          children: [
            // Text
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: selected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                  child: Text(title),
                ),
              ),
            ),

            // Bottom border that expands from center
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 350),
                curve: Curves.fastOutSlowIn,
                alignment: selected ? Alignment.center : Alignment.center,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.fastOutSlowIn,
                  height: 2,
                  width: selected ? 70 : 0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(1),
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.grey[900]!],
                    ),
                  ),
                ),
              ),
            ),

            // Top highlight when selected
            if (selected)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 20,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
