import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/category/domain/entities/save_category_entity.dart';
import 'package:quikservnew/features/category/domain/repositories/category_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class SaveCategoryUseCase
    implements
        UseCaseWithParams<MasterResponseModel, SaveCategoryRequestModel> {
  final CategoriesRepository _categoryRepository;

  SaveCategoryUseCase(this._categoryRepository);

  @override
  ResultFuture<MasterResponseModel> call(
    SaveCategoryRequestModel params,
  ) async {
    return _categoryRepository.saveCategory(params);
  }
}
