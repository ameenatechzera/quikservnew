import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:quikservnew/core/theme/colors.dart';

Widget switchRow(String title, ValueNotifier<bool> notifier) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title),

      ValueListenableBuilder<bool>(
        valueListenable: notifier,
        builder: (context, value, _) {
          return Switch(
            value: value,
            onChanged: (newValue) {
              notifier.value = newValue;
            },
            activeColor: Colors.black,
            activeTrackColor: AppColors.theme,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade400,
          );
        },
      ),
    ],
  );
}

Widget radioOption({
  required String title,
  required String value,
  required String groupValue,
  required VoidCallback onTap,
}) {
  final bool isSelected = value == groupValue;

  return InkWell(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFE4AD00)
                  : Colors.grey.shade600,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.black : Colors.transparent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget printerSwitchRow(
  String title,
  bool value,
  ValueChanged<bool> onChanged,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      SizedBox(
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.black,
          activeTrackColor: AppColors.theme,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade400,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    ],
  );
}

Widget textFieldBox({
  required TextEditingController controller,
  required String hint,
  Widget? suffixIcon,
}) {
  return Container(
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(6),
      color: Colors.white,
    ),
    alignment: Alignment.centerLeft,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(fontSize: 12),
    ),
  );
}

Widget dropdownBox({
  required String topLabel,
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Container(
    height: 52,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(6),
      color: Colors.white,
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: items.contains(value) ? value : null,
        isExpanded: true,
        hint: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$topLabel\n",
                style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
        items: items
            .map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
        onChanged: onChanged,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          size: 20,
          color: Colors.grey,
        ),
      ),
    ),
  );
}

Widget connectedDeviceBox(String deviceName) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.print, size: 18, color: Color(0xFFE4AD00)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            deviceName,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF444444),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget deviceListWidget({
  required List<BluetoothInfo> bluetoothDevices,
  required String printerName,
  required Function(String mac, String name) onConnect,
}) {
  return Column(
    children: [
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Available Printers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: bluetoothDevices.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('No printers found'),
                ),
              )
            : ListView.builder(
                itemCount: bluetoothDevices.length,
                itemBuilder: (context, i) {
                  final d = bluetoothDevices[i];
                  return ListTile(
                    leading: const Icon(Icons.bluetooth, color: Colors.blue),
                    title: Text(d.name),
                    subtitle: Text(d.macAdress),
                    trailing: IconButton(
                      icon: const Icon(Icons.link, color: Color(0xFFFF8A00)),
                      onPressed: () {
                        onConnect(d.macAdress, d.name);
                      },
                    ),
                  );
                },
              ),
      ),
    ],
  );
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;
  final Widget? child;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, __) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}
