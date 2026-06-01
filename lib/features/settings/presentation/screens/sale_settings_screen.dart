import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/settings/presentation/widgets/salesettings_widgets.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class SaleSettingsScreen extends StatefulWidget {
  const SaleSettingsScreen({super.key});

  @override
  State<SaleSettingsScreen> createState() => _SaleSettingsScreenState();
}

class _SaleSettingsScreenState extends State<SaleSettingsScreen> {
  int selectedItemTapBehavior = 1;
  int selectedPaymentOption = 0;
  int collectCustomerData = 0;
  bool _collectCustomerData = false;
  final SharedPreferenceHelper helper = SharedPreferenceHelper();

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    selectedItemTapBehavior = await helper.getItemTapBehavior();
    selectedPaymentOption = await helper.getPaymentOption();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF3F6),
        appBar: const CommonAppBar(title: "Sale Settings"),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  itemTapBehaviorSection(
                    selectedValue: selectedItemTapBehavior,
                    onChanged: (value) {
                      setState(() {
                        selectedItemTapBehavior = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  paymentOptionsSection(
                    selectedValue: selectedPaymentOption,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentOption = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Collect Customer Details ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _collectCustomerData
                                ? const Color(0xFF1565C0)
                                : const Color(0xFF546E7A),
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _collectCustomerData,
                          onChanged: (val) => setState(() => _collectCustomerData = val),
                          activeColor: const Color(0xFF1565C0),
                        ),


                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// BOTTOM ACTIONS
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: actionButton(
                      label: "CANCEL",
                      color: Colors.grey.shade300,
                      textColor: Colors.black87,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: actionButton(
                      label: "SAVE",
                      color: AppColors.primary,
                      textColor: AppColors.black,
                      onTap: () async {
                        if(_collectCustomerData){
                          collectCustomerData = 1;
                        }
                        await helper.saveItemTapBehavior(selectedItemTapBehavior);
                        await helper.savePaymentOption(selectedPaymentOption);
                        await helper.saveCustomerDetailsOnSale(collectCustomerData);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
