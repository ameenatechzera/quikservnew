import 'package:flutter/material.dart';

class CommomBottomBar extends StatelessWidget {
  final int currentTabIndex;
  final Function(int) onTabChanged;
  const CommomBottomBar({
    super.key,
    required this.currentTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.0, // 🔑 LOCK font scaling
      ),
      child: Positioned(
        left: 30,
        right: 30,
        bottom: 0,
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE38A),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // HOME
              _buildTab(icon: Icons.home_outlined, label: "Home", index: 0),

              // DASHBOARD
              _buildTab(
                icon: Icons.pause_rounded,
                label: "Dashboard",
                index: 1,
              ),

              // SETTINGS
              _buildTab(
                icon: Icons.settings_outlined,
                label: "Settings",
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentTabIndex == index;

    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
            : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 20,
            ),
            if (isSelected) ...[
              //  const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
