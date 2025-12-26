import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';

abstract class CategoryLocalRepository {
  Future<void> saveCategories(List<FetchCategoryDetailsEntity> categories);
  Future<List<FetchCategoryDetailsEntity>> getCategories();
  Future<void> clearCategories();
}
