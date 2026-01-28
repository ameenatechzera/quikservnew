import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/products/domain/repositories/product_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class DeleteProductUseCase
    implements UseCaseWithParams<MasterResponseModel, int> {
  final ProductsRepository _productRepository;

  DeleteProductUseCase(this._productRepository);

  @override
  ResultFuture<MasterResponseModel> call(int productId) async {
    return _productRepository.deleteProductFromServer(productId);
  }
}
