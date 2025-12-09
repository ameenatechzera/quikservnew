import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/sale/presentation/screens/home_select_screen.dart';
import 'package:quikservnew/features/sale/presentation/widgets/tabs.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
                  ),

                  // Subcategory Row
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
                        const SizedBox(width: 8),
                        const Text("All (12)"),
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

                  // Categories (Vertical) and GridView (Horizontal)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vertical Categories List on Left
                      SizedBox(
                        width: 120, // Fixed width for categories
                        height:
                            MediaQuery.of(context).size.height -
                            200, // Adjust height as needed
                        child: BlocBuilder<CategoriesCubit, CategoryState>(
                          builder: (context, state) {
                            if (state is CategoryLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is CategoryLoaded) {
                              final categories =
                                  state.categories.categories ?? [];
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            category.categoryName ?? "",
                                            style: const TextStyle(
                                              color:
                                                  Colors
                                                      .black, // change if needed
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (state is CategoryError) {
                              return Center(child: Text(state.error));
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),

                      // GridView on Right
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocConsumer<ProductCubit, ProductsState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              if (state is ProductLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is ProductSuccess) {
                                final products = state.products;

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: products.productDetails!.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.7,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                      ),
                                  itemBuilder: (context, index) {
                                    final product =
                                        products.productDetails![index];

                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            width: double.infinity,
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
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child:
                                                        product.productImage !=
                                                                null
                                                            ? Image.network(
                                                              product
                                                                  .productImage!,
                                                              fit: BoxFit.cover,
                                                              width:
                                                                  double
                                                                      .infinity,
                                                              height: 130,
                                                            )
                                                            : Image.asset(
                                                              "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                                              fit: BoxFit.cover,
                                                              width:
                                                                  double
                                                                      .infinity,
                                                              height: 120,
                                                            ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        product.productName ??
                                                            "Product",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        product.groupName,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Add button
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 90,
                                            left: 10,
                                            right: 10,
                                          ),
                                          child: Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFEAB307),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
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

                                        // Price tag
                                        Positioned(
                                          right: 5,
                                          top: 5,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
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
                                );
                              } else if (state is ProductFailure) {
                                return Center(child: Text(state.error));
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 100),
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
                  color: const Color(0xFFFFE38A),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // HOME (selected)
                    GestureDetector(
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
                    ),

                    // CENTER ICON
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

    final center = Offset(size.width * 0.45, size.height * 0.45);
    final radius = size.width * 0.44;

    canvas.drawCircle(center, radius, paint);

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
