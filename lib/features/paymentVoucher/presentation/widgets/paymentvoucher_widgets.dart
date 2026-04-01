import 'package:flutter/material.dart';

class PaymentModeBottomSheet {
  static void show({
    required BuildContext context,
    required List<String> options,
    required String? selectedOption,
    required TextEditingController paymentModeController,
    required Function(String value) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((option) {
                  final isSelected = selectedOption == option;
                  return AbsorbPointer(
                    absorbing: isSelected,
                    child: CheckboxListTile(
                      title: Text(option),
                      value: isSelected,
                      onChanged: (bool? selected) {
                        if (selected == true) {
                          setState(() {
                            paymentModeController.text = option;
                          });
                          onSelected(option);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}

class AmountColumn extends StatelessWidget {
  const AmountColumn({
    super.key,
    required TextEditingController amountController,
    required FocusNode amountFocusNode,
  }) : _amountController = amountController,
       _amountFocusNode = amountFocusNode;

  final TextEditingController _amountController;
  final FocusNode _amountFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            right: 4.0,
            top: 2.0,
            bottom: 2.0,
          ),
          child: SizedBox(
            height: 80,
            width: double.infinity,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: TextFormField(
                          controller: _amountController,
                          focusNode: _amountFocusNode,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NotesColumn extends StatelessWidget {
  const NotesColumn({super.key, required TextEditingController notesController})
    : _notesController = notesController;

  final TextEditingController _notesController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            right: 4.0,
            top: 2.0,
            bottom: 2.0,
          ),
          child: SizedBox(
            height: 80,
            width: double.infinity,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: TextFormField(
                          controller: _notesController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            labelText: 'Notes(Optional)',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            contentPadding: EdgeInsets.only(bottom: 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
