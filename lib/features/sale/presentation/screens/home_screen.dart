import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/sale/presentation/screens/home_select_screen.dart';
import 'package:quikservnew/features/sale/presentation/screens/menu_screen.dart';
import 'package:quikservnew/features/sale/presentation/widgets/product_dialog.dart';
import 'package:quikservnew/features/sale/presentation/widgets/tabs.dart';
import 'package:quikservnew/features/sale/presentation/widgets/top_price_container_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MenuScreen(),
                                ),
                              );
                            },
                            child: const Center(
                              child: Icon(
                                Icons.menu,
                                color: AppColors.white,
                                //size: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text("All (12)"),
                        const Spacer(),
                        IconButton(
                          icon: CustomSearchIcon(
                            size: 22,
                            color: AppColors.black,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.red,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search Items",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomSearchIcon(size: 22, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  BlocBuilder<ProductCubit, ProductsState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ProductSuccess) {
                        final products = state.products; // List<ProductModel>

                        if (products.productDetails!.isEmpty) {
                          return const Center(
                            child: Text("No products available"),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: products.productDetails!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                            itemBuilder: (context, index) {
                              final product = products.productDetails![index];
                              return Stack(
                                children: [
                                  // Main card
                                  GestureDetector(
                                    onLongPress:
                                        () => showProductDialog(context),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        color: Color.fromARGB(
                                          255,
                                          232,
                                          229,
                                          229,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),

                                                child: SizedBox(
                                                  height: 120,
                                                  child:
                                                      product
                                                              .productImage!
                                                              .isNotEmpty
                                                          ? Image.network(
                                                            product
                                                                .productImage!,
                                                            fit: BoxFit.cover,
                                                          )
                                                          : Image.asset(
                                                            "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                                            fit: BoxFit.cover,
                                                          ),
                                                ),
                                              ),
                                            ),
                                            // Product Name
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    product
                                                        .productName!, // Replace with your product name
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  productGroupBagde(
                                                    product.groupName,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Add button bottom
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   right: 5,
                                  //   top: 130,
                                  //   child: productGroupBagde(),
                                  // ),
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
                                              return HomeCart();
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        height: 30,
                                        width: 120,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                  TopPriceContainer(price: product.salesPrice),
                                ],
                              );
                            },
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ), // Add space at bottom for the fixed navigation
                  //  SizedBox(height: 100),
                ],
              ),
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
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.home_outlined,
                            color: AppColors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Home",
                            style: TextStyle(
                              color: AppColors.white,
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
                        border: Border.all(color: AppColors.black, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.pause_rounded,
                        color: AppColors.black,
                        size: 20,
                      ),
                    ),

                    const Icon(
                      Icons.settings_outlined,
                      color: AppColors.black,
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

  Widget productGroupBagde(String? groupName) {
    // Extract first letter safely
    String firstLetter = "?";

    if (groupName != null && groupName.trim().isNotEmpty) {
      firstLetter = groupName.trim()[0].toUpperCase();
    }
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
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
