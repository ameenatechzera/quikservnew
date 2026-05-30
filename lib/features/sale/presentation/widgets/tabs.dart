// import 'package:flutter/material.dart';

// Widget buildTab(
//   BuildContext context,
//   String title,
//   bool selected,
//   VoidCallback onTap,
// ) {
//   return Expanded(
//     child: GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 48,
//         margin: const EdgeInsets.symmetric(horizontal: 2),
//         child: Stack(
//           children: [
//             // Text
//             Center(
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: selected ? Colors.black : Colors.transparent,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: AnimatedDefaultTextStyle(
//                   duration: const Duration(milliseconds: 200),
//                   style: TextStyle(
//                     color: selected ? Colors.white : Colors.black87,
//                     fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
//                     fontSize: 14,
//                   ),
//                   child: Text(title),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
import 'package:flutter/material.dart';

Widget buildTab(
  BuildContext context,
  String title,
  bool selected,
  VoidCallback onTap,
) {
  final screenWidth = MediaQuery.of(context).size.width;
  final bool isTablet = screenWidth > 600;

  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: isTablet ? 65 : 48,
        margin: EdgeInsets.symmetric(horizontal: isTablet ? 4 : 2),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 50 : 16,
              vertical: isTablet ? 10 : 5,
            ),
            decoration: BoxDecoration(
              color: selected ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                fontSize: isTablet ? 18 : 14,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
