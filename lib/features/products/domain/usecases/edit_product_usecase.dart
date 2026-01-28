import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/products/domain/parameters/save_product_parameter.dart';
import 'package:quikservnew/features/products/domain/repositories/product_repository.dart';

class EditProductUseCase {
  final ProductsRepository _productsRepository;

  EditProductUseCase(this._productsRepository);

  ResultFuture<MasterResponseModel> call(
    int productId,
    ProductSaveRequest request,
  ) async {
    return _productsRepository.updateProduct(productId, request);
  }
}
