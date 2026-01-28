// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CategoryDao? _categoryDaoInstance;

  ProductDao? _productDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tbl_category` (`categoryId` INTEGER, `categoryName` TEXT, `categoryImage` TEXT, `branchId` INTEGER, `createdDate` TEXT, `createdUser` TEXT, `modifiedDate` TEXT, `modifiedUser` TEXT, PRIMARY KEY (`categoryId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tbl_products` (`productCode` TEXT, `productName` TEXT, `productNameFL` TEXT, `baseUnitId` INTEGER, `groupId` INTEGER, `categoryId` INTEGER, `vatId` INTEGER, `purchaseRate` TEXT, `productImage` TEXT, `isActive` INTEGER, `branchId` INTEGER, `descriptionStatus` INTEGER, `createdDate` TEXT, `createdUser` TEXT, `modifiedDate` TEXT, `modifiedUser` TEXT, `barcode` TEXT, `mrp` TEXT, `salesPrice` TEXT, `conversionRate` TEXT, `unitId` INTEGER, `unitName` TEXT, `group_id` INTEGER NOT NULL, `groupName` TEXT NOT NULL, `categoryId2` INTEGER, `categoryName` TEXT, `vatName` TEXT, `vatPercentage` INTEGER, `productImageByte` TEXT, `qty` INTEGER, `cartStatus` INTEGER, `cartQty` INTEGER, `vegStatus` INTEGER, `originalPrice` TEXT, PRIMARY KEY (`productCode`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _fetchCategoryDetailsEntityInsertionAdapter = InsertionAdapter(
            database,
            'tbl_category',
            (FetchCategoryDetailsEntity item) => <String, Object?>{
                  'categoryId': item.categoryId,
                  'categoryName': item.categoryName,
                  'categoryImage': item.categoryImage,
                  'branchId': item.branchId,
                  'createdDate': item.createdDate,
                  'createdUser': item.createdUser,
                  'modifiedDate': item.modifiedDate,
                  'modifiedUser': item.modifiedUser
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FetchCategoryDetailsEntity>
      _fetchCategoryDetailsEntityInsertionAdapter;

  @override
  Future<List<FetchCategoryDetailsEntity>> getAllCategories() async {
    return _queryAdapter.queryList('SELECT * FROM tbl_category',
        mapper: (Map<String, Object?> row) => FetchCategoryDetailsEntity(
            categoryId: row['categoryId'] as int?,
            categoryName: row['categoryName'] as String?,
            categoryImage: row['categoryImage'] as String?,
            branchId: row['branchId'] as int?,
            createdDate: row['createdDate'] as String?,
            createdUser: row['createdUser'] as String?,
            modifiedDate: row['modifiedDate'] as String?,
            modifiedUser: row['modifiedUser'] as String?));
  }

  @override
  Future<void> clearCategories() async {
    await _queryAdapter.queryNoReturn('DELETE FROM tbl_category');
  }

  @override
  Future<void> insertCategories(
      List<FetchCategoryDetailsEntity> categories) async {
    await _fetchCategoryDetailsEntityInsertionAdapter.insertList(
        categories, OnConflictStrategy.replace);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _fetchProductDetailsInsertionAdapter = InsertionAdapter(
            database,
            'tbl_products',
            (FetchProductDetails item) => <String, Object?>{
                  'productCode': item.productCode,
                  'productName': item.productName,
                  'productNameFL': item.productNameFL,
                  'baseUnitId': item.baseUnitId,
                  'groupId': item.groupId,
                  'categoryId': item.categoryId,
                  'vatId': item.vatId,
                  'purchaseRate': item.purchaseRate,
                  'productImage': item.productImage,
                  'isActive': item.isActive,
                  'branchId': item.branchId,
                  'descriptionStatus': item.descriptionStatus,
                  'createdDate': item.createdDate,
                  'createdUser': item.createdUser,
                  'modifiedDate': item.modifiedDate,
                  'modifiedUser': item.modifiedUser,
                  'barcode': item.barcode,
                  'mrp': item.mrp,
                  'salesPrice': item.salesPrice,
                  'conversionRate': item.conversionRate,
                  'unitId': item.unitId,
                  'unitName': item.unitName,
                  'group_id': item.group_id,
                  'groupName': item.groupName,
                  'categoryId2': item.categoryId2,
                  'categoryName': item.categoryName,
                  'vatName': item.vatName,
                  'vatPercentage': item.vatPercentage,
                  'productImageByte': item.productImageByte,
                  'qty': item.qty,
                  'cartStatus': item.cartStatus == null
                      ? null
                      : (item.cartStatus! ? 1 : 0),
                  'cartQty': item.cartQty,
                  'vegStatus':
                      item.vegStatus == null ? null : (item.vegStatus! ? 1 : 0),
                  'originalPrice': item.originalPrice
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FetchProductDetails>
      _fetchProductDetailsInsertionAdapter;

  @override
  Future<List<FetchProductDetails>> getAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM tbl_products',
        mapper: (Map<String, Object?> row) => FetchProductDetails(
            productCode: row['productCode'] as String?,
            productName: row['productName'] as String?,
            productNameFL: row['productNameFL'] as String?,
            baseUnitId: row['baseUnitId'] as int?,
            groupId: row['groupId'] as int?,
            group_id: row['group_id'] as int,
            groupName: row['groupName'] as String,
            categoryId: row['categoryId'] as int?,
            vatId: row['vatId'] as int?,
            purchaseRate: row['purchaseRate'] as String?,
            productImage: row['productImage'] as String?,
            isActive: row['isActive'] as int?,
            branchId: row['branchId'] as int?,
            descriptionStatus: row['descriptionStatus'] as int?,
            createdDate: row['createdDate'] as String?,
            createdUser: row['createdUser'] as String?,
            modifiedDate: row['modifiedDate'] as String?,
            modifiedUser: row['modifiedUser'] as String?,
            barcode: row['barcode'] as String?,
            mrp: row['mrp'] as String?,
            salesPrice: row['salesPrice'] as String?,
            conversionRate: row['conversionRate'] as String?,
            unitId: row['unitId'] as int?,
            unitName: row['unitName'] as String?,
            categoryId2: row['categoryId2'] as int?,
            categoryName: row['categoryName'] as String?,
            vatName: row['vatName'] as String?,
            vatPercentage: row['vatPercentage'] as int?,
            productImageByte: row['productImageByte'] as String?,
            qty: row['qty'] as int?,
            cartStatus: row['cartStatus'] == null
                ? null
                : (row['cartStatus'] as int) != 0,
            cartQty: row['cartQty'] as int?,
            vegStatus: row['vegStatus'] == null
                ? null
                : (row['vegStatus'] as int) != 0,
            originalPrice: row['originalPrice'] as String?));
  }

  @override
  Future<void> clearProducts() async {
    await _queryAdapter.queryNoReturn('DELETE FROM tbl_products');
  }

  @override
  Future<List<FetchProductDetails>> getProductsByCategory(
      int categoryId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tbl_products WHERE categoryId = ?1',
        mapper: (Map<String, Object?> row) => FetchProductDetails(
            productCode: row['productCode'] as String?,
            productName: row['productName'] as String?,
            productNameFL: row['productNameFL'] as String?,
            baseUnitId: row['baseUnitId'] as int?,
            groupId: row['groupId'] as int?,
            group_id: row['group_id'] as int,
            groupName: row['groupName'] as String,
            categoryId: row['categoryId'] as int?,
            vatId: row['vatId'] as int?,
            purchaseRate: row['purchaseRate'] as String?,
            productImage: row['productImage'] as String?,
            isActive: row['isActive'] as int?,
            branchId: row['branchId'] as int?,
            descriptionStatus: row['descriptionStatus'] as int?,
            createdDate: row['createdDate'] as String?,
            createdUser: row['createdUser'] as String?,
            modifiedDate: row['modifiedDate'] as String?,
            modifiedUser: row['modifiedUser'] as String?,
            barcode: row['barcode'] as String?,
            mrp: row['mrp'] as String?,
            salesPrice: row['salesPrice'] as String?,
            conversionRate: row['conversionRate'] as String?,
            unitId: row['unitId'] as int?,
            unitName: row['unitName'] as String?,
            categoryId2: row['categoryId2'] as int?,
            categoryName: row['categoryName'] as String?,
            vatName: row['vatName'] as String?,
            vatPercentage: row['vatPercentage'] as int?,
            productImageByte: row['productImageByte'] as String?,
            qty: row['qty'] as int?,
            cartStatus: row['cartStatus'] == null
                ? null
                : (row['cartStatus'] as int) != 0,
            cartQty: row['cartQty'] as int?,
            vegStatus: row['vegStatus'] == null
                ? null
                : (row['vegStatus'] as int) != 0,
            originalPrice: row['originalPrice'] as String?),
        arguments: [categoryId]);
  }

  @override
  Future<List<FetchProductDetails>> getProductsByGroup(int groupId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tbl_products WHERE groupId = ?1',
        mapper: (Map<String, Object?> row) => FetchProductDetails(
            productCode: row['productCode'] as String?,
            productName: row['productName'] as String?,
            productNameFL: row['productNameFL'] as String?,
            baseUnitId: row['baseUnitId'] as int?,
            groupId: row['groupId'] as int?,
            group_id: row['group_id'] as int,
            groupName: row['groupName'] as String,
            categoryId: row['categoryId'] as int?,
            vatId: row['vatId'] as int?,
            purchaseRate: row['purchaseRate'] as String?,
            productImage: row['productImage'] as String?,
            isActive: row['isActive'] as int?,
            branchId: row['branchId'] as int?,
            descriptionStatus: row['descriptionStatus'] as int?,
            createdDate: row['createdDate'] as String?,
            createdUser: row['createdUser'] as String?,
            modifiedDate: row['modifiedDate'] as String?,
            modifiedUser: row['modifiedUser'] as String?,
            barcode: row['barcode'] as String?,
            mrp: row['mrp'] as String?,
            salesPrice: row['salesPrice'] as String?,
            conversionRate: row['conversionRate'] as String?,
            unitId: row['unitId'] as int?,
            unitName: row['unitName'] as String?,
            categoryId2: row['categoryId2'] as int?,
            categoryName: row['categoryName'] as String?,
            vatName: row['vatName'] as String?,
            vatPercentage: row['vatPercentage'] as int?,
            productImageByte: row['productImageByte'] as String?,
            qty: row['qty'] as int?,
            cartStatus: row['cartStatus'] == null
                ? null
                : (row['cartStatus'] as int) != 0,
            cartQty: row['cartQty'] as int?,
            vegStatus: row['vegStatus'] == null
                ? null
                : (row['vegStatus'] as int) != 0,
            originalPrice: row['originalPrice'] as String?),
        arguments: [groupId]);
  }

  @override
  Future<void> insertProducts(List<FetchProductDetails> products) async {
    await _fetchProductDetailsInsertionAdapter.insertList(
        products, OnConflictStrategy.replace);
  }
}
