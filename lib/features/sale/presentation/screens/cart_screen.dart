import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart'), backgroundColor: Colors.white),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // ---------- MAIN CONTENT ----------
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CART ITEMS LIST (UI only)
                        Column(
                          children: List.generate(4, (index) {
                            return _CartItemRow(index: index + 1);
                          }),
                        ),
                        const SizedBox(height: 16),

                        // ---------- SUMMARY CARD ----------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4D7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _summaryRow('Sub Total :', '₹ 1345.00'),
                              const SizedBox(height: 4),
                              _summaryRow('Discount :', '₹ 0.00'),
                              const SizedBox(height: 4),
                              _summaryRow('Tax :', '₹ 13.00'),
                              const Divider(height: 16),
                              _summaryRow('Total :', '₹ 1358.00', isBold: true),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ---------- PAYMENT TITLE ----------
                        const Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ---------- PAYMENT OPTIONS ----------
                        Row(
                          children: const [
                            Expanded(
                              child: _PaymentOption(
                                title: 'Cash',
                                subtitle: '₹ 100.00',
                                selected: true,
                                icon: Icons.money,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _PaymentOption(
                                title: 'Card',
                                subtitle: '',
                                selected: false,
                                icon: Icons.credit_card,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _PaymentOption(
                                title: 'Multi',
                                subtitle: '',
                                selected: false,
                                icon: Icons.dashboard_customize_outlined,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ---------- CONFIRM BUTTON ----------
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEAB307),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Confirm Sale',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // summary line helper
  static Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// =============== CART ITEM ROW (UI only) ===============

class _CartItemRow extends StatelessWidget {
  final int index;

  const _CartItemRow({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index.isOdd ? Colors.white : const Color(0xFFF6F6F6),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$index.', style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 20),

          // Item text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Brost 4 Pcs',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  '2 x 199',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Qty box
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300, width: 1.4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.remove, size: 16),
                SizedBox(width: 10),
                Text(
                  '02',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 10),
                Icon(Icons.add, size: 16),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Price
          const Text(
            '₹ 398.00',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),

          const SizedBox(width: 8),

          // Delete
          const Icon(Icons.close, color: Colors.red, size: 20),
        ],
      ),
    );
  }
}

// =============== PAYMENT OPTION TILE (UI only) ===============

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final IconData icon;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = selected ? Colors.black : Colors.white;
    final Color border = selected ? Colors.black : Colors.grey.shade300;
    final Color textColor = selected ? Colors.white : Colors.black;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: selected ? Colors.white : Colors.black87),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: selected ? Colors.white70 : Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
