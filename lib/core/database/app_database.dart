import 'dart:async';
import 'package:floor/floor.dart';
import 'package:quikservnew/core/database/daos/product_dao.dart';
import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/category_dao.dart';

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [FetchCategoryDetailsEntity, FetchProductDetails],
)
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;
  ProductDao get productDao;
}
