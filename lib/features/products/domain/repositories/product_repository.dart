import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/products/data/models/fetch_product_model.dart';

abstract class ProductsRepository {
  ResultFuture<FetchProductResponseModel> fetchProducts();
}
