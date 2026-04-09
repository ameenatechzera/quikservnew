import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/settings/presentation/widgets/print_settings_widget.dart';

class BillPreviewWidget extends StatelessWidget {
  const BillPreviewWidget({
    super.key,
    required this.logoWidth,
    required this.logoHeight,
  });

  final double logoWidth;
  final double logoHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Text(
                  '19:09:07',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Column(
            children: [
              dashedLine(),
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
              dashedLine(),
            ],
          ),
          const SizedBox(height: 8),

          billRow(
            no: '1',
            item: 'Mutton Bun\nBiriyani',
            qty: '1',
            rate: '2000',
            total: '20300',
          ),
          const SizedBox(height: 15),
          billRow(
            no: '2',
            item: 'Mutton Bun\nBiriyani',
            qty: '1',
            rate: '2000',
            total: '20300',
          ),
          const SizedBox(height: 15),
          billRow(
            no: '3',
            item: 'Mutton Bun\nBiriyani',
            qty: '1',
            rate: '2000',
            total: '20300',
          ),
          const SizedBox(height: 15),

          dashedLine(),
          const SizedBox(height: 6),

          Row(
            children: const [
              Expanded(
                child: Text(
                  'Card 32',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                'NET Total:9949.00',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),

          dashedLine(),
          SizedBox(height: 16),
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
    );
  }
}
