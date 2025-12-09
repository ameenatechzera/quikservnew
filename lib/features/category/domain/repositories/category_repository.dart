import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/category/data/models/fetch_category_model.dart';

abstract class CategoriesRepository {
  ResultFuture<FetchCategoryResponseModel> fetchCategories();
}
