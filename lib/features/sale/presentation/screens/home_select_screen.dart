import 'package:flutter/material.dart';
import 'package:quikservnew/features/sale/presentation/screens/cart_screen.dart';
import 'package:quikservnew/features/sale/presentation/screens/menu_screen.dart';
import 'package:quikservnew/features/sale/presentation/widgets/product_dialog.dart';
import 'package:quikservnew/features/sale/presentation/widgets/tabs.dart';

class HomeCart extends StatelessWidget {
  const HomeCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Top Tabs
                  Container(
                    color: Color(0xFFffeeb7),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildTab(context, "Dine-In", true),
                          buildTab(context, "Takeaway", false),
                          buildTab(context, "Delivery", false),
                        ],
                      ),
                    ),
                  ), // Subcategory Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.menu, color: Colors.white),
                        ),
                        const SizedBox(width: 100),
                        const Text("Broasted"),
                        const Spacer(),
                        IconButton(
                          icon: CustomSearchIcon(size: 22, color: Colors.black),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 20,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            // Main card
                            GestureDetector(
                              onTap: () => showProductDialog(context),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  color: Color.fromARGB(255, 232, 229, 229),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),

                                          child: Image.asset(
                                            "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                            //fit: BoxFit.cover,
                                            //   width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      // Product Name
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          "Product ${index + 100000000001}", // Replace with your product name
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      // Add button bottom
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 85,
                                left: 10,
                                right: 10,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MenuScreen();
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEAB307),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 30,
                                  width: 120,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, size: 15),
                                      Text(
                                        'Add',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Price container (top-right)
                            Positioned(
                              right: 5,
                              top: 5,

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  "₹150",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ), // Add space at bottom for the fixed navigation
                  SizedBox(height: 100),
                ],
              ),
            ),
            Positioned(
              bottom: 100,
              left: 10,
              right: 10,
              child: cartBottomBar(context),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                margin: const EdgeInsets.all(26),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE38A), // background yellow
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // HOME (selected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Home",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CENTER ICON (rounded square outline)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.pause_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),

                    const Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cartBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // ITEMS COUNT
          const Text(
            "1 Items",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 12),

          Container(width: 2, height: 20, color: Colors.white54),

          const SizedBox(width: 12),

          // TOTAL PRICE
          const Text(
            "₹ 199",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          // VIEW CART TEXT
          TextButton(
            child: const Text(
              "View Cart",
              style: TextStyle(
                color: Color(0xFFEAB307),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return CartScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 8),

          // BAG ICON
          const Icon(
            Icons.shopping_bag_outlined,
            color: Color(0xFFEAB307),
            size: 22,
          ),
        ],
      ),
    );
  }

  void showProductDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: const ProductDialogContent(),
        );
      },
    );
  }
}

class CustomSearchIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CustomSearchIcon({super.key, this.size = 22, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: SearchIconPainter(color: color),
    );
  }
}

class SearchIconPainter extends CustomPainter {
  final Color color;

  SearchIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2.4
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Circle
    final center = Offset(size.width * 0.45, size.height * 0.45);
    final radius = size.width * 0.44;

    canvas.drawCircle(center, radius, paint);

    // ---- HANDLE (with gap) ----
    final double gap = 3;

    final handleStart = Offset(
      center.dx + (radius + gap) * 0.72,
      center.dy + (radius + gap) * 0.72,
    );

    final handleEnd = Offset(handleStart.dx + 6, handleStart.dy + 6);

    canvas.drawLine(handleStart, handleEnd, paint);
  }

  @override
  bool shouldRepaint(covariant SearchIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
