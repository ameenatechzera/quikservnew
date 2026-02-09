import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.pink.shade600,
                  borderRadius: BorderRadius.circular(20)),
              child: const Row(
                children: [
                  Icon(Icons.home, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text("home",
                      style: TextStyle(color: Colors.white, fontSize: 14))
                ],
              ),
            ),
            const Icon(Icons.school_outlined, color: Colors.grey),
            const Icon(Icons.settings_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
