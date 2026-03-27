import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
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
        child: Container(
          width: 300,
          margin: const EdgeInsets.symmetric(vertical: 14),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xffF7F7F7),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: const Color(0xffDDDDDD)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Logo preview based on saved width and height
              Container(
                width: logoWidth,
                height: logoHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.theme,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54),
                ),
                child: const Text(
                  "Logo",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Quikserv',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'Token NO 398',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              const Text(
                'Invoice',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '090828',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Start : Supplier',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Date : 18-10-2026',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '19:09:07',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Column(
                children: [
                  _dashedLine(),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(
                          'Item',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Qty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Rate',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          'Total',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _dashedLine(),
                ],
              ),
              const SizedBox(height: 8),

              _billRow(
                no: '1',
                item: 'Mutton Bun\nBiriyani',
                qty: '1',
                rate: '2000',
                total: '20300',
              ),
              const SizedBox(height: 15),
              _billRow(
                no: '2',
                item: 'Mutton Bun\nBiriyani',
                qty: '1',
                rate: '2000',
                total: '20300',
              ),
              const SizedBox(height: 15),
              _billRow(
                no: '3',
                item: 'Mutton Bun\nBiriyani',
                qty: '1',
                rate: '2000',
                total: '20300',
              ),
              const SizedBox(height: 15),

              _dashedLine(),
              const SizedBox(height: 6),

              Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Card 32',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    'NET Total:9949.00',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              _dashedLine(),
              const SizedBox(height: 16),
              const Text(
                'Scan & Pay',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              Container(
                height: 70,
                width: 70,
                padding: const EdgeInsets.all(4),
                color: Colors.white,
                child: Image.network(
                  'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=SamplePayment',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 18),
              const Text(
                'Thank You For Choosing Chicking\nRestaurant\nWe Truly Appreciate Your Visit.\nHave A Great Day!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.5,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const dashWidth = 4.0;
        const dashSpace = 3.0;
        final dashCount = (width / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1.2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black54),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _billRow({
    required String no,
    required String item,
    required String qty,
    required String rate,
    required String total,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            no,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 9,
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            qty,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            rate,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            total,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
