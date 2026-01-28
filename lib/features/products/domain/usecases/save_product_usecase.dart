import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/products/domain/parameters/save_product_parameter.dart';
import 'package:quikservnew/features/products/domain/repositories/product_repository.dart';

class SaveProductUseCase
    implements UseCaseWithParams<MasterResponseModel, ProductSaveRequest> {
  final ProductsRepository _productsRepository;

  SaveProductUseCase(this._productsRepository);

  @override
  ResultFuture<MasterResponseModel> call(ProductSaveRequest params) async {
    return _productsRepository.saveProduct(params);
  }
}
