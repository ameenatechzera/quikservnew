import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/settings/presentation/widgets/bill_preview_widget.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class BillPreviewScreen extends StatefulWidget {
  const BillPreviewScreen({super.key});

  @override
  State<BillPreviewScreen> createState() => _BillPreviewScreenState();
}

class _BillPreviewScreenState extends State<BillPreviewScreen> {
  double logoWidth = 80;
  double logoHeight = 80;
  int companyFontSize = 18;

  @override
  void initState() {
    super.initState();
    _loadPreviewSettings();
  }

  Future<void> _loadPreviewSettings() async {
    final fetchedLogoWidth = await SharedPreferenceHelper().fetchLogoWidth();
    final fetchedLogoHeight = await SharedPreferenceHelper().fetchLogoHeight();
    final fetchedFontSize = await SharedPreferenceHelper()
        .fetchCompanyNameFontSize();

    setState(() {
      logoWidth = fetchedLogoWidth ?? 80;
      logoHeight = fetchedLogoHeight ?? 80;
      companyFontSize = int.tryParse(fetchedFontSize ?? '') ?? 18;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.theme,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 18,
          ),
        ),
        titleSpacing: 0,
        title: const Text(
          'Bill Preview',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
        child: BillPreviewWidget(logoWidth: logoWidth, logoHeight: logoHeight),
      ),
    );
  }
}
