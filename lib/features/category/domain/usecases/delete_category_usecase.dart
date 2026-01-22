import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/category/domain/repositories/category_repository.dart';

class DeleteCategoryUseCase
    implements UseCaseWithParams<MasterResponseModel, int> {
  final CategoriesRepository _categoryRepository;

  DeleteCategoryUseCase(this._categoryRepository);

  @override
  ResultFuture<MasterResponseModel> call(int categoryId) async {
    return _categoryRepository.deleteCategory(categoryId);
  }
}
