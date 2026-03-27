import 'package:quikservnew/core/database/app_database.dart';
import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';
import 'package:quikservnew/features/category/domain/repositories/category_local_repository.dart';

class CategoryLocalRepositoryImpl implements CategoryLocalRepository {
  final AppDatabase database;

  CategoryLocalRepositoryImpl(this.database);

  @override
  Future<void> saveCategories(
    List<FetchCategoryDetailsEntity> categories,
  ) async {
    await database.categoryDao.clearCategories();
    await database.categoryDao.insertCategories(categories);
  }

  @override
  Future<List<FetchCategoryDetailsEntity>> getCategories() async {
    final data = await database.categoryDao.getAllCategories();
    return data;
  }

  @override
  Future<void> clearCategories() async {
    await database.categoryDao.clearCategories();
  }
}
