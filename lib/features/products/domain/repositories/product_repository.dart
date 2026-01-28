import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/products/data/models/fetch_product_model.dart';
import 'package:quikservnew/features/products/domain/parameters/save_product_parameter.dart';

abstract class ProductsRepository {
  ResultFuture<FetchProductResponseModel> fetchProducts();
  ResultFuture<MasterResponseModel> saveProduct(ProductSaveRequest request);
  ResultFuture<MasterResponseModel> deleteProductFromServer(int productCode);
  ResultFuture<MasterResponseModel> updateProduct(
    int productCode,
    ProductSaveRequest request,
  );
}
