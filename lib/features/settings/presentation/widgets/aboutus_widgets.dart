import 'package:flutter/material.dart';

Widget infoCard(Widget child) {
  return Card(
    color: Colors.white, // ✅ white background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(
        color: Colors.grey, // ✅ black border
        width: 1,
      ),
    ),
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: child,
  );
}

Widget infoTile({
  IconData? icon,
  String? assetIcon,
  required String title,
  required VoidCallback onTap,
  //Color iconColor = Colors.black,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: assetIcon != null
        ? Image.asset(
            assetIcon,
            width: 22,
            height: 22,
            //color: iconColor,
          )
        : Icon(
            icon,
            //color: iconColor,
          ),
    title: Text(title, style: const TextStyle(fontSize: 15)),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}
