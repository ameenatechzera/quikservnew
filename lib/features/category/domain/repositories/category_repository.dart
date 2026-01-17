import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/category/data/models/fetch_category_model.dart';
import 'package:quikservnew/features/category/domain/entities/save_category_entity.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

abstract class CategoriesRepository {
  ResultFuture<FetchCategoryResponseModel> fetchCategories();
  ResultFuture<MasterResponseModel> saveCategory(
    SaveCategoryRequestModel request,
  );
}
