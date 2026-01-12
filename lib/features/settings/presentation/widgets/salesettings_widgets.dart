import 'package:flutter/material.dart';

/// STATES (ValueNotifiers)
final ValueNotifier<int> cursorFocus = ValueNotifier<int>(
  1,
); // 0 = Rate, 1 = Quantity
final ValueNotifier<int> itemTapBehavior = ValueNotifier<int>(
  1,
); // 0 = Dialog, 1 = Increase Qty
final ValueNotifier<int> paymentOption = ValueNotifier<int>(0); //
Widget cursorFocusSection() {
  return ValueListenableBuilder<int>(
    valueListenable: cursorFocus,
    builder: (_, value, __) {
      return settingsCard(
        title: "Cursor Focus",
        children: [
          radioTile(
            label: "RATE",
            value: 0,
            groupValue: value,
            onChanged: (v) => cursorFocus.value = v,
          ),
          radioTile(
            label: "QUANTITY",
            value: 1,
            groupValue: value,
            onChanged: (v) => cursorFocus.value = v,
          ),
        ],
      );
    },
  );
}

Widget itemTapBehaviorSection() {
  return ValueListenableBuilder<int>(
    valueListenable: itemTapBehavior,
    builder: (_, value, __) {
      return settingsCard(
        title: "Item Tap Behavior",
        children: [
          radioTile(
            label: "OPEN DIALOG",
            value: 0,
            groupValue: value,
            onChanged: (v) => itemTapBehavior.value = v,
          ),
          radioTile(
            label: "INCREASE QUANTITY",
            value: 1,
            groupValue: value,
            onChanged: (v) => itemTapBehavior.value = v,
          ),
        ],
      );
    },
  );
}

Widget paymentOptionsSection() {
  return ValueListenableBuilder<int>(
    valueListenable: paymentOption,
    builder: (_, value, __) {
      return settingsCard(
        title: "Payment Options",
        children: [
          radioTile(
            label: "CASH",
            value: 0,
            groupValue: value,
            onChanged: (v) => paymentOption.value = v,
          ),
          radioTile(
            label: "CARD",
            value: 1,
            groupValue: value,
            onChanged: (v) => paymentOption.value = v,
          ),
        ],
      );
    },
  );
}

// ================= COMMON UI =================

Widget settingsCard({required String title, required List<Widget> children}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    ),
  );
}

Widget radioTile({
  required String label,
  required int value,
  required int groupValue,
  required ValueChanged<int> onChanged,
}) {
  final bool isSelected = value == groupValue;

  return InkWell(
    onTap: () => onChanged(value),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? Colors.orange : Colors.black45,
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    ),
  );
}

Widget actionButton({
  required String label,
  required Color color,
  required Color textColor,
  required VoidCallback onTap,
}) {
  return SizedBox(
    height: 46,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: color == Colors.orange ? 3 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
