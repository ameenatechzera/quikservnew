import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/category/data/models/fetch_category_model.dart';
import 'package:quikservnew/features/category/domain/repositories/category_repository.dart';

class FetchCategoriesUseCase
    implements UseCaseWithoutParams<FetchCategoryResponseModel> {
  final CategoriesRepository _categoriesRepository;

  FetchCategoriesUseCase(this._categoriesRepository);

  @override
  ResultFuture<FetchCategoryResponseModel> call() async {
    return _categoriesRepository.fetchCategories();
  }
}
