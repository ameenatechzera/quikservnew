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
              // HOME (selected)
              GestureDetector(
                onTap: () {
                  onTabChanged(0); // Switch to Sales tab
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: currentTabIndex == 0
                        ? Colors.black
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: currentTabIndex == 0
                            ? Colors.white
                            : Colors.black,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Home",
                        style: TextStyle(
                          color: currentTabIndex == 0
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // CENTER ICON
              InkWell(
                onTap: () {
                  onTabChanged(1); // Switch to Dashboard tab
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: currentTabIndex == 1
                        ? Colors.black
                        : Colors.transparent,
                    border: Border.all(
                      color: currentTabIndex == 1 ? Colors.black : Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.pause_rounded,
                    color: currentTabIndex == 1 ? Colors.white : Colors.black,
                    size: 20,
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  onTabChanged(2); // Switch to Settings tab
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: currentTabIndex == 2
                        ? Colors.black
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: currentTabIndex == 2 ? Colors.white : Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
