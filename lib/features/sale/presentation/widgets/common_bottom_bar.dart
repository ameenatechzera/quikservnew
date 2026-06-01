import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    /// Tablet check
    final bool isTablet = screenWidth > 600;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 50 : 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE38A),
            borderRadius: BorderRadius.circular(isTablet ? 50 : 40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // HOME
              _buildTab(
                context: context,
                iconPath: 'assets/icons/homeicon.svg',
                label: "Home",
                index: 0,
              ),

              // DASHBOARD
              _buildTab(
                context: context,
                iconPath: 'assets/icons/dashboardicon.svg',
                label: "Dashboard",
                index: 1,
              ),

              // SETTINGS
              _buildTab(
                context: context,
                iconPath: 'assets/icons/Clip path group.svg',
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
    required BuildContext context,
    required String iconPath,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentTabIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;

    /// Tablet check
    final bool isTablet = screenWidth > 600;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: isSelected
            ? EdgeInsets.symmetric(horizontal: isTablet ? 50 : 14, vertical: 9)
            : EdgeInsets.all(isTablet ? 14 : 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          border: Border.all(color: Colors.black, width: isTablet ? 2.5 : 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 25,
              height: 25,
              color: isSelected ? Colors.white : Colors.black, // optional
            ),

            if (isSelected) ...[
              SizedBox(width: isTablet ? 10 : 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 18 : 14,
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
