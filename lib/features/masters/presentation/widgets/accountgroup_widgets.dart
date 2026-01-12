import 'package:flutter/material.dart';

class AccountGroupTile extends StatelessWidget {
  final String title;

  const AccountGroupTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 0, offset: Offset(0, 1)),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20, color: Colors.black54),
              onPressed: () {
                // TODO: Edit action
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () {
                // TODO: Delete action
              },
            ),
          ],
        ),
      ),
    );
  }
}
