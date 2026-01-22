import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/category/domain/parameters/edit_category_parameter.dart';
import 'package:quikservnew/features/category/domain/repositories/category_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class EditCategoryUseCase {
  final CategoriesRepository _categoriesRepository;

  EditCategoryUseCase(this._categoriesRepository);

  ResultFuture<MasterResponseModel> call(
    int categoryId,
    EditCategoryRequestModel request,
  ) async {
    return _categoriesRepository.editCategory(categoryId, request);
  }
}
