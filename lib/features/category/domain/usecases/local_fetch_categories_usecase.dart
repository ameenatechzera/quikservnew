import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';
import 'package:quikservnew/features/category/domain/repositories/category_local_repository.dart';

class GetLocalCategoriesUseCase {
  final CategoryLocalRepository repository;

  GetLocalCategoriesUseCase(this.repository);

  Future<List<FetchCategoryDetailsEntity>> call() async {
    return repository.getCategories();
  }
}
