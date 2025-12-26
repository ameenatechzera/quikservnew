// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';
// // import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';

// // Widget buildCategoryList(
// //   List<FetchCategoryDetailsEntity> categories,
// //   BuildContext context,
// // ) {
// //   // Temporary list with 'All' as first item
// //   final List<FetchCategoryDetailsEntity> displayCategories = [
// //     FetchCategoryDetailsEntity(
// //       categoryId: 0, // dummy ID for 'All'
// //       categoryName: 'All',
// //       categoryImage: null,
// //       branchId: null,
// //       createdDate: null,
// //       createdUser: null,
// //       modifiedDate: null,
// //       modifiedUser: null,
// //     ),
// //     ...categories,
// //   ];

// //   return ListView.builder(
// //     itemCount: displayCategories.length,
// //     itemBuilder: (context, index) {
// //       final category = displayCategories[index];

// //       return Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //         child: GestureDetector(
// //           onTap: () {
// //             final productCubit = context.read<ProductCubit>();

// //             if (category.categoryId == 0) {
// //               // 'All' tapped → fetch all products
// //               productCubit.loadProductsFromLocal();
// //             } else {
// //               // Specific category tapped → fetch products by category
// //               productCubit.loadProductsByCategory(category.categoryId!);
// //             }
// //           },
// //           child: Center(
// //             child: Column(
// //               children: [
// //                 Text(
// //                   category.categoryName ?? "",
// //                   style: const TextStyle(
// //                     color: Colors.black,
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 30),
// //               ],
// //             ),
// //           ),
// //         ),
// //       );
// //     },
// //   );
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';
// import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';

// class CategoryListWidget extends StatelessWidget {
//   final List<FetchCategoryDetailsEntity> categories;

//   // ValueNotifier to track selected category ID
//   final ValueNotifier<int> selectedCategoryId = ValueNotifier<int>(0);

//   CategoryListWidget({super.key, required this.categories});

//   @override
//   Widget build(BuildContext context) {
//     // Temporary list with 'All' as first item
//     final List<FetchCategoryDetailsEntity> displayCategories = [
//       FetchCategoryDetailsEntity(
//         categoryId: 0, // dummy ID for 'All'
//         categoryName: 'All',
//         categoryImage: null,
//         branchId: null,
//         createdDate: null,
//         createdUser: null,
//         modifiedDate: null,
//         modifiedUser: null,
//       ),
//       ...categories,
//     ];

//     return ValueListenableBuilder<int>(
//       valueListenable: selectedCategoryId,
//       builder: (context, selectedId, _) {
//         return ListView.builder(
//           itemCount: displayCategories.length,
//           itemBuilder: (context, index) {
//             final category = displayCategories[index];
//             final bool isSelected = category.categoryId == selectedId;

//             return GestureDetector(
//               onTap: () {
//                 final productCubit = context.read<ProductCubit>();

//                 // Update the selected category
//                 selectedCategoryId.value = category.categoryId!;

//                 // Fetch products based on selection
//                 if (category.categoryId == 0) {
//                   productCubit.loadProductsFromLocal();
//                 } else {
//                   productCubit.loadProductsByCategory(category.categoryId!);
//                 }
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.black : Colors.transparent,
//                   borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(15),
//                     bottomRight: Radius.circular(15),
//                   ),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 child: Center(
//                   child: Text(
//                     category.categoryName ?? "",
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                       fontSize: 16,
//                       fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';

class CategoryListWidget extends StatelessWidget {
  final List<FetchCategoryDetailsEntity> categories;

  /// ✅ Shared notifiers from MenuScreen
  final ValueNotifier<int> selectedCategoryId;
  final ValueNotifier<String> selectedCategoryName;

  CategoryListWidget({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.selectedCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    final List<FetchCategoryDetailsEntity> displayCategories = [
      FetchCategoryDetailsEntity(
        categoryId: 0,
        categoryName: 'All',
        categoryImage: null,
        branchId: null,
        createdDate: null,
        createdUser: null,
        modifiedDate: null,
        modifiedUser: null,
      ),
      ...categories,
    ];

    return ValueListenableBuilder<int>(
      valueListenable: selectedCategoryId,
      builder: (context, selectedId, _) {
        return ListView.builder(
          itemCount: displayCategories.length,
          itemBuilder: (context, index) {
            final category = displayCategories[index];
            final bool isSelected = category.categoryId == selectedId;

            return GestureDetector(
              onTap: () {
                final productCubit = context.read<ProductCubit>();

                selectedCategoryId.value = category.categoryId!;
                selectedCategoryName.value = category.categoryName ?? "All";

                if (category.categoryId == 0) {
                  productCubit.loadProductsFromLocal();
                } else {
                  productCubit.loadProductsByCategory(category.categoryId!);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: Text(
                    category.categoryName ?? "",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
