import 'package:get_it/get_it.dart';
import 'package:quikservnew/core/database/app_database.dart';
import 'package:quikservnew/features/accountledger/data/datasources/account_ledger_remote_datasource.dart';
import 'package:quikservnew/features/accountledger/data/repositories/account_ledger_repositoryImpl.dart';
import 'package:quikservnew/features/accountledger/domain/repositories/account_ledger_repository.dart';
import 'package:quikservnew/features/accountledger/domain/usecases/delete_accountledger_usecase.dart';
import 'package:quikservnew/features/accountledger/domain/usecases/fetchAccountLedgersUseCase.dart';
import 'package:quikservnew/features/accountledger/domain/usecases/fetch_bankaccountledger_usecase.dart';
import 'package:quikservnew/features/accountledger/domain/usecases/save_account_ledger_usecase.dart';
import 'package:quikservnew/features/accountledger/domain/usecases/update_ledger_usecase.dart';
import 'package:quikservnew/features/accountledger/presentation/bloc/accountledger_cubit.dart';
import 'package:quikservnew/features/accountGroups/data/datasources/accountGroup_remote_datasources.dart';
import 'package:quikservnew/features/accountGroups/data/repositories/account_group_repository_impl.dart';
import 'package:quikservnew/features/accountGroups/domain/repositories/account_group_repository.dart';
import 'package:quikservnew/features/accountGroups/domain/usecases/deleteAccountGroupUseCase.dart';
import 'package:quikservnew/features/accountGroups/domain/usecases/fetchAccountGroupsUseCase.dart';
import 'package:quikservnew/features/accountGroups/domain/usecases/saveAccountGroupUseCase.dart';
import 'package:quikservnew/features/accountGroups/domain/usecases/updateAccountGroupUseCase.dart';
import 'package:quikservnew/features/accountGroups/presentation/bloc/account_group_cubit.dart';
import 'package:quikservnew/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:quikservnew/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:quikservnew/features/authentication/domain/repositories/auth_repository.dart';
import 'package:quikservnew/features/authentication/domain/usecases/change_password_usecase.dart';
import 'package:quikservnew/features/authentication/domain/usecases/login_usecase.dart';
import 'package:quikservnew/features/authentication/domain/usecases/register_server_usecase.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/logincubit/login_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';

import 'package:quikservnew/features/category/data/datasources/categories_remote_data_source.dart';
import 'package:quikservnew/features/category/data/repositories/categories_repository_impl.dart';
import 'package:quikservnew/features/category/data/repositories/category_local_repository_impl.dart';
import 'package:quikservnew/features/category/domain/repositories/category_local_repository.dart';
import 'package:quikservnew/features/category/domain/repositories/category_repository.dart';
import 'package:quikservnew/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:quikservnew/features/category/domain/usecases/edit_category_usecase.dart';

import 'package:quikservnew/features/category/domain/usecases/fetch_categories_usecase.dart';
import 'package:quikservnew/features/category/domain/usecases/local_fetch_categories_usecase.dart';
import 'package:quikservnew/features/category/domain/usecases/save_category_usecase.dart';

import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/dailyclosingReport/data/datasources/dailyCloseReport_remote_datasource.dart';
import 'package:quikservnew/features/dailyclosingReport/data/repositories/dailyCloseReport_repository_impl.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/repositories/dailyClosingReportRepository.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/usecases/fetchDailyClosingReportUseCase.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/usecases/fetchItemWiseDetailsUseCase.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/bloc/dayclose_report_cubit.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/bloc/item_bloc/item_cubit.dart';
import 'package:quikservnew/features/groups/data/datasources/group_remote_data_source.dart';
import 'package:quikservnew/features/groups/data/repositories/group_repository_impl.dart';
import 'package:quikservnew/features/groups/domain/repositories/group_repository.dart';
import 'package:quikservnew/features/groups/domain/usecases/add_product_groups_usecase.dart';
import 'package:quikservnew/features/groups/domain/usecases/delete_productgroupfromserver_usecase.dart';

import 'package:quikservnew/features/groups/domain/usecases/fetch_groups_usecase.dart';
import 'package:quikservnew/features/groups/domain/usecases/update_productgroups_usecase.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';
import 'package:quikservnew/features/itemwiseReport/data/datasources/itemwiseReport_remote_datasource.dart';
import 'package:quikservnew/features/itemwiseReport/data/repositories/itemwiseReport_repository_impl.dart';
import 'package:quikservnew/features/itemwiseReport/domain/repositories/ItemWiseReportRepository.dart';
import 'package:quikservnew/features/itemwiseReport/domain/usecases/fetchItemwiseReportUseCase.dart';
import 'package:quikservnew/features/itemwiseReport/presentation/bloc/item_wise_report_cubit.dart';
import 'package:quikservnew/features/masters/data/datasources/userCreationRemoteDataSource.dart';
import 'package:quikservnew/features/masters/data/repositories/user_creation_repository_impl.dart';
import 'package:quikservnew/features/masters/domain/repositories/user_creation_repository.dart';
import 'package:quikservnew/features/masters/domain/usecase/fetch_cashierlist_usecase.dart';
import 'package:quikservnew/features/masters/domain/usecase/fetch_supplierlist_usecase.dart';
import 'package:quikservnew/features/masters/domain/usecase/fetch_usertypes_usecase.dart';
import 'package:quikservnew/features/masters/domain/usecase/save_usertypes_usecase.dart';
import 'package:quikservnew/features/masters/presentation/bloc/user_creation_cubit.dart';
import 'package:quikservnew/features/paymentVoucher/data/datasources/payment_remote_data_source.dart';
import 'package:quikservnew/features/paymentVoucher/data/repositories/paymentRepositories_impl.dart';
import 'package:quikservnew/features/paymentVoucher/domain/repositories/payment_repository.dart';
import 'package:quikservnew/features/paymentVoucher/domain/usecases/savePaymentVoucherUseCase.dart';
import 'package:quikservnew/features/paymentVoucher/presentation/bloc/payment_cubit.dart';
import 'package:quikservnew/features/products/data/datasources/product_remote_data_source.dart';
import 'package:quikservnew/features/products/data/repositories/product_repositories_local_impl.dart';
import 'package:quikservnew/features/products/data/repositories/products_repository_impl.dart';
import 'package:quikservnew/features/products/domain/repositories/product_local_repository.dart';
import 'package:quikservnew/features/products/domain/repositories/product_repository.dart';
import 'package:quikservnew/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:quikservnew/features/products/domain/usecases/edit_product_usecase.dart';
import 'package:quikservnew/features/products/domain/usecases/fetch_product_usecase.dart';
import 'package:quikservnew/features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'package:quikservnew/features/products/domain/usecases/getproducts_bygroup.dart';
import 'package:quikservnew/features/products/domain/usecases/save_product_usecase.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/sale/data/datasources/sales_remote_datasource.dart';
import 'package:quikservnew/features/sale/data/repositories/sale_repository_impl.dart';
import 'package:quikservnew/features/sale/domain/repositories/sale_repository.dart';
import 'package:quikservnew/features/sale/domain/usecases/save_sale_toserver_usecase.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';
import 'package:quikservnew/features/salesReport/data/datasources/salesReport_remote_datasource.dart';
import 'package:quikservnew/features/salesReport/data/repositories/salesReport_repository_impl.dart';
import 'package:quikservnew/features/salesReport/domain/repositories/salesReport_repository.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/salesDetailsByMasterIdUseCase.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/salesReportDeleteByMasterIdUseCase.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/salesReportFromServerUseCase.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/sales_masterreport_bydate_usecase.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:quikservnew/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetchCurrenSalesTokenUseCase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_settings_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/save_accountsettings_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/updatesalesTokenUseCase.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/features/units/data/datasources/units_remote_datasource.dart';
import 'package:quikservnew/features/units/data/repositories/units_repository_impl.dart';
import 'package:quikservnew/features/units/domain/repositories/units_repository.dart';
import 'package:quikservnew/features/units/domain/usecases/delete_unit_fromserver_usecase.dart';
import 'package:quikservnew/features/units/domain/usecases/fetch_unitsfromserver_usecase.dart';
import 'package:quikservnew/features/units/domain/usecases/save_unit_toserver_usecase.dart';
import 'package:quikservnew/features/units/domain/usecases/update_unit_usecase.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';
import 'package:quikservnew/features/vat/data/datasources/vat_remote_data_source.dart';
import 'package:quikservnew/features/vat/data/repositories/vat_repository_impl.dart';
import 'package:quikservnew/features/vat/domain/repositories/vat_repository.dart';
import 'package:quikservnew/features/vat/domain/usecases/add_vat_usecase.dart';
import 'package:quikservnew/features/vat/domain/usecases/delete_vat_usecase.dart';
import 'package:quikservnew/features/vat/domain/usecases/fetch_vat_usecase.dart';
import 'package:quikservnew/features/vat/domain/usecases/update_vat_usecase.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';
import 'package:quikservnew/main.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // ------------------- AUTH -------------------
    //  Cubit
    sl.registerFactory(
      () => RegisterCubit(
        registerServerUseCase: sl(),
        changePasswordUseCase: sl(),
      ),
    );
    sl.registerFactory(() => LoginCubit(loginServerUseCase: sl()));
    // usecase
    sl.registerLazySingleton(() => RegisterServerUseCase(sl()));
    sl.registerLazySingleton(() => LoginServerUseCase(sl()));
    sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(),
    );

    // repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- UNITS -------------------
    // Cubit
    sl.registerFactory(
      () => UnitCubit(
        fetchUnitsUseCase: sl(),
        saveUnitUseCase: sl(),
        deleteUnitUseCase: sl(),
        editUnitUseCase: sl(),
      ),
    );

    // UseCase
    sl.registerLazySingleton(() => FetchUnitsUseCase(sl()));
    sl.registerLazySingleton(() => SaveUnitUseCase(sl()));
    sl.registerLazySingleton(() => DeleteUnitUseCase(sl()));
    sl.registerLazySingleton(() => EditUnitUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<UnitsRemoteDataSource>(
      () => UnitsRemoteDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<UnitsRepository>(
      () => UnitsRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- VAT -------------------
    // Cubit
    sl.registerFactory(
      () => VatCubit(
        fetchVatUseCase: sl(),
        addVatUseCase: sl(),
        deleteVatUseCase: sl(),
        editVatUseCase: sl(),
      ),
    );
    // UseCase
    sl.registerLazySingleton(() => FetchVatUseCase(sl()));
    sl.registerLazySingleton(() => AddVatUseCase(sl()));
    sl.registerLazySingleton(() => DeleteVatUseCase(sl()));
    sl.registerLazySingleton(() => EditVatUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<VatRemoteDataSource>(
      () => VatRemoteDataSourceImpl(),
    );
    // Repository
    sl.registerLazySingleton<VatRepository>(
      () => VatRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- GROUPS -------------------
    // Cubit
    sl.registerFactory(
      () => GroupsCubit(
        fetchGroupsUseCase: sl(),
        addProductGroupUseCase: sl(),
        deleteProductGroupUseCase: sl(),
        editProductGroupUseCase: sl(),
      ),
    );
    // UseCase
    sl.registerLazySingleton(() => FetchGroupsUseCase(sl()));
    sl.registerLazySingleton(() => AddProductGroupUseCase(sl()));
    sl.registerLazySingleton(() => DeleteProductGroupUseCase(sl()));
    sl.registerLazySingleton(() => EditProductGroupUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<GroupsRemoteDataSource>(
      () => GroupsRemoteDataSourceImpl(),
    );
    // Repository
    sl.registerLazySingleton<GroupsRepository>(
      () => GroupsRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- PRODUCTS -------------------
    // Cubit
    sl.registerFactory(
      () => ProductCubit(
        fetchProductsUseCase: sl(),
        productLocalRepository: sl(),
        getProductsByCategoryUseCase: sl(),
        saveProductUseCase: sl(),
        deleteProductUseCase: sl(),
        editProductUseCase: sl(),
        getProductsByGroupUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(() => SaveProductUseCase(sl()));
    sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
    sl.registerLazySingleton(() => EditProductUseCase(sl()));
    sl.registerLazySingleton(() => GetProductsByGroupUseCase(sl()));

    // ------------------- Sales Report -------------------

    // Cubit
    sl.registerFactory(
      () => SalesReportCubit(
        salesReportFromServerUseCase: sl(),
        salesDetailsByMasterIdUseCase: sl(),
        salesReportMasterByDateUseCase: sl(),
        deleteSalesFromServerUseCase: sl(),
      ),
    );
    // UseCase
    sl.registerLazySingleton(() => SalesReportFromServerUseCase(sl()));
    sl.registerLazySingleton(() => SalesDetailsByMasterIdUseCase(sl()));
    sl.registerLazySingleton(() => SalesReportMasterByDateUseCase(sl()));
    sl.registerLazySingleton(() => DeleteSalesFromServerUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<SalesReportRemoteDataSource>(
      () => SalesReportRemoteDataSourceImpl(),
    );
    // Repository
    sl.registerLazySingleton<SalesReportRepository>(
      () => SalesReportRepositoryImpl(remoteDataSource: sl()),
    );

    // UseCase
    sl.registerLazySingleton(() => FetchProductsUseCase(sl()));
    sl.registerLazySingleton(() => GetProductsByCategoryUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<ProductLocalRepository>(
      () => ProductLocalRepositoryImpl(sl()), // <-- Inject Floor DAO here
    );
    // Repository
    sl.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- SETTINGS -------------------
    // Cubit
    sl.registerFactory(
      () => SettingsCubit(
        fetchSettingsUseCase: sl(),
        fetchCurrentSalesTokenUseCase: sl(),
        updateSalesTokenUseCase: sl(),
        saveAccountSettingsUseCase: sl(),
      ),
    );
    // UseCase
    sl.registerLazySingleton(() => FetchSettingsUseCase(sl()));
    sl.registerLazySingleton(() => FetchCurrentSalesTokenUseCase(sl()));
    sl.registerLazySingleton(() => UpdateSalesTokenUseCase(sl()));
    sl.registerLazySingleton(() => SaveAccountSettingsUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<SettingsRemoteDataSource>(
      () => SettingsRemoteDataSourceImpl(),
    );
    // Repository
    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- CATEGORIES -------------------
    // Floor Database
    sl.registerLazySingleton<AppDatabase>(() => appDb);

    // Cubit
    sl.registerFactory(
      () => CategoriesCubit(
        fetchCategoriesUseCase: sl(),
        categoryLocalRepository: sl(),

        getLocalCategoriesUseCase: sl(),
        saveCategoryUseCase: sl(),
        deleteCategoryUseCase: sl(),
        editCategoryUseCase: sl(),
      ),
    );
    // UseCase
    sl.registerLazySingleton(() => FetchCategoriesUseCase(sl()));
    sl.registerLazySingleton(() => SaveCategoryUseCase(sl()));
    sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));
    sl.registerLazySingleton(() => EditCategoryUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<CategoriesRemoteDataSource>(
      () => CategoriesRemoteDataSourceImpl(),
    );
    // Repository
    sl.registerLazySingleton<CategoriesRepository>(
      () => CategoriesRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<CategoryLocalRepository>(
      () => CategoryLocalRepositoryImpl(sl()),
    );
    sl.registerLazySingleton(() => GetLocalCategoriesUseCase(sl()));
    // ------------------- SALES -------------------
    sl.registerFactory(
      () => SaleCubit(
        saveSaleUseCase: sl(),
        salesRepository: sl(),
        salesDetailsByMasterIdUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(() => SaveSaleUseCase(sl()));
    sl.registerLazySingleton<SalesRemoteDataSource>(
      () => SalesRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<SalesRepository>(
      () => SalesRepositoryImpl(remoteDataSource: sl()),
    );

    // -------------- Item Cubit in day close report -----------------

    sl.registerFactory(
          () => ItemCubit(
              fetchItemWiseDetailsUseCase:sl()
      ),
    );


    // ------------------- CreateUSer Cubit -------------------
    sl.registerFactory(
      () => UserCreationCubit(
        fetchUserTypesUseCase: sl(),
        saveUserTypesUseCase: sl(),
        fetchSupplierListUseCase: sl(),
        fetchCashierListUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(() => FetchUserTypesUseCase(sl()));
    sl.registerLazySingleton(() => SaveUserUseCase(sl()));
    sl.registerLazySingleton(() => FetchSupplierListUseCase(sl()));
    sl.registerLazySingleton(() => FetchCashierListUseCase(sl()));

    sl.registerLazySingleton<UserCreationRemoteDataSource>(
      () => UserCreationRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<UserCreationRepository>(
      () => UserCreationRepositoryImpl(remoteDataSource: sl()),
    );
    // ------------------- ACCOUNT LEDGER -------------------

    // Cubit
    sl.registerFactory(
      () => AccountledgerCubit(
        fetchAccountLedgerUseCase: sl(),
        deleteAccountLedgerUseCase: sl(),
        saveAccountLedgerUseCase: sl(),
        updateAccountLedgerUseCase: sl(),
        fetchBankAccountLedgerUseCase: sl(),
      ),
    );

    // UseCase
    sl.registerLazySingleton(() => FetchAccountLedgerUseCase(sl()));
    sl.registerLazySingleton(() => DeleteAccountLedgerUseCase(sl()));
    sl.registerLazySingleton(() => SaveAccountLedgerUseCase(sl()));
    sl.registerLazySingleton(() => UpdateAccountLedgerUseCase(sl()));
    sl.registerLazySingleton(() => FetchBankAccountLedgerUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<AccountLedgerRemoteDataSource>(
      () => AccountLedgerRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<AccountLedgerRepository>(
      () => AccountLedgerRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- Item Report Cubit -------------------
    sl.registerFactory(
      () => ItemWiseReportCubit(fetchItemWiseReportUseCase: sl()),
    );
    sl.registerLazySingleton(() => FetchItemWiseReportUseCase(sl()));

    sl.registerLazySingleton<ItemWiseReportRemoteDataSource>(
      () => ItemWiseReportRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<ItemWiseReportRepository>(
      () => ItemWiseReportRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- Daily close Report Cubit -------------------
    sl.registerFactory(
      () => DaycloseReportCubit(
        fetchDailyClosingReportUseCase: sl(),
       // fetchItemWiseDetailsUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(() => FetchDailyClosingReportUseCase(sl()));
    sl.registerLazySingleton(() => FetchItemWiseDetailsUseCase(sl()));

    sl.registerLazySingleton<DailyClosingReportRemoteDataSource>(
      () => DailyClosingReportRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<DailyClosingReportRepository>(
      () => DailyclosereportRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- Account group Cubit -------------------
    sl.registerFactory(
      () => AccountGroupCubit(
        fetchAccountGroupsUseCase: sl(),
        saveAccountGroupUseCase: sl(),
        deleteAccountGroupUseCase: sl(),
        updateAccountGroupUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(() => FetchAccountGroupsUseCase(sl()));
    sl.registerLazySingleton(() => SaveAccountGroupUseCase(sl()));
    sl.registerLazySingleton(() => DeleteAccountGroupUseCase(sl()));
    sl.registerLazySingleton(() => UpdateAccountGroupUseCase(sl()));

    sl.registerLazySingleton<AccountGroupsRemoteDataSource>(
      () => AccountGroupsRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<AccountGroupRepository>(
      () => AccountGroupRepositoryImpl(remoteDataSource: sl()),
    );
    // ------------------- PAYMENT VOUCHER -------------------

    // Cubit
    sl.registerFactory(() => PaymentCubit(savePaymentVoucherUseCase: sl()));

    // UseCase
    sl.registerLazySingleton(() => SavePaymentVoucherUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<PaymentRemoteDataSource>(
      () => PaymentRemoteDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<PaymentRepository>(
      () => PaymentRepositoryImpl(remoteDataSource: sl()),
    );
  }
}
