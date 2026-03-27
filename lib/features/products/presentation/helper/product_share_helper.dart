import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';

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
