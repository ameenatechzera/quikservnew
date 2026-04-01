import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/features/products/domain/parameters/save_product_parameter.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';

class ProductShareHelper {
  String buildProductShareText(FetchProductDetails item) {
    return '''
🛍️ *${item.productName ?? ''}*

📂 *Category:* ${item.categoryName ?? ''}

💰 *Sale Price:* ₹${item.salesPrice ?? 0}

📦 *Stock:* 0
''';
  }

  Future<void> shareProductToWhatsApp({
    required BuildContext context,
    required FetchProductDetails item,
  }) async {
    final text = buildProductShareText(item);

    final uri = Uri.parse("whatsapp://send?text=${Uri.encodeComponent(text)}");

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      showAnimatedToast(
        context,
        message: "WhatsApp not available",
        isSuccess: false,
      );
    }
  }

  bool validate({
    required BuildContext context,
    required TextEditingController productNameController,
    required int? categoryId,
    required int? groupId,
    required int? baseUnitId,
    required int? vatId,
    required bool taxEnabled,
  }) {
    final productName = productNameController.text.trim();
    if (productName.isEmpty) {
      showAnimatedToast(
        context,
        message: "Product Name is required",
        isSuccess: false,
      );
      return false;
    }

    if (categoryId == null) {
      showAnimatedToast(
        context,
        message: "Category is required",
        isSuccess: false,
      );
      return false;
    }

    if (groupId == null) {
      showAnimatedToast(
        context,
        message: "Geoup is required",
        isSuccess: false,
      );
      return false;
    }

    if (baseUnitId == null) {
      showAnimatedToast(context, message: "Unit is required", isSuccess: false);
      return false;
    }

    if (taxEnabled && (vatId == null)) {
      showAnimatedToast(context, message: "Vat is required", isSuccess: false);
      return false;
    }

    return true;
  }

  Future<void> onSavePressed({
    required BuildContext context,
    required TextEditingController productNameController,
    required TextEditingController productNameSecondController,
    required TextEditingController barcodeController,
    required TextEditingController purchaseRateController,
    required TextEditingController conversionRateController,
    required TextEditingController salesRateController,
    required TextEditingController mrpController,
    required int? categoryId,
    required int? groupId,
    required int? baseUnitId,
    required int? vatId,
    required bool taxEnabled,
    required bool isActive,
    required bool isEdit,
    required FetchProductDetails? product,
  }) async {
    if (!validate(
      context: context,
      productNameController: productNameController,
      categoryId: categoryId,
      groupId: groupId,
      baseUnitId: baseUnitId,
      vatId: vatId,
      taxEnabled: taxEnabled,
    )) {
      return;
    }
    final productName = productNameController.text.trim();
    final productSecondName = productNameSecondController.text.trim();

    final purchaseRate =
        double.tryParse(purchaseRateController.text.trim()) ?? 0;

    final conversionRate =
        double.tryParse(conversionRateController.text.trim()) ?? 1;

    final salesRate = double.tryParse(salesRateController.text.trim()) ?? 0;
    final mrp = double.tryParse(mrpController.text.trim()) ?? 0;

    final List<ConversionDetail> conversionDetails = [
      ConversionDetail(
        unitId: baseUnitId!,
        barcode: barcodeController.text.trim(),
        conversionRate: conversionRate,
        mrp: mrp,
        salesPrice: salesRate,
        branchId: 1,
      ),
    ];

    final request = ProductSaveRequest(
      productName: productName,
      productNameFL: productSecondName,
      baseUnitId: baseUnitId,
      groupId: groupId!,
      categoryId: categoryId!,
      vatId: taxEnabled ? (vatId ?? 0) : 0,
      purchaseRate: purchaseRate,
      isActive: isActive,
      branchId: 1,
      descriptionStatus: 0,
      createdUser: 0,
      conversionDetails: conversionDetails,
    );
    final cubit = context.read<ProductCubit>();

    if (isEdit) {
      cubit.updateProduct(int.parse(product!.productCode!), request);
    } else {
      cubit.saveProduct(request);
    }
    // context.read<ProductCubit>().saveProduct(request);
  }
}
