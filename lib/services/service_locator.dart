import 'package:get_it/get_it.dart';
import 'package:quikservnew/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:quikservnew/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:quikservnew/features/authentication/domain/repositories/auth_repository.dart';
import 'package:quikservnew/features/authentication/domain/usecases/login_usecase.dart';
import 'package:quikservnew/features/authentication/domain/usecases/register_server_usecase.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/logincubit/login_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/category/data/datasources/categories_remote_data_source.dart';
import 'package:quikservnew/features/category/data/repositories/categories_repository_impl.dart';
import 'package:quikservnew/features/category/domain/repositories/category_repository.dart';
import 'package:quikservnew/features/category/domain/usecases/fetch_categories_usecase.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/groups/data/datasources/group_remote_data_source.dart';
import 'package:quikservnew/features/groups/data/repositories/group_repository_impl.dart';
import 'package:quikservnew/features/groups/domain/repositories/group_repository.dart';
import 'package:quikservnew/features/groups/domain/usecases/fetch_groups_usecase.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';
import 'package:quikservnew/features/products/data/datasources/product_remote_data_source.dart';
import 'package:quikservnew/features/products/data/repositories/products_repository_impl.dart';
import 'package:quikservnew/features/products/domain/repositories/product_repository.dart';
import 'package:quikservnew/features/products/domain/usecases/fetch_product_usecase.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:quikservnew/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_settings_usecase.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/features/units/data/datasources/units_remote_datasource.dart';
import 'package:quikservnew/features/units/data/repositories/units_repository_impl.dart';
import 'package:quikservnew/features/units/domain/repositories/units_repository.dart';
import 'package:quikservnew/features/units/domain/usecases/fetch_unitsfromserver_usecase.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';
import 'package:quikservnew/features/vat/data/datasources/vat_remote_data_source.dart';
import 'package:quikservnew/features/vat/data/repositories/vat_repository_impl.dart';
import 'package:quikservnew/features/vat/domain/repositories/vat_repository.dart';
import 'package:quikservnew/features/vat/domain/usecases/fetch_vat_usecase.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // ------------------- AUTH -------------------
    //  Cubit
    sl.registerFactory(() => RegisterCubit(registerServerUseCase: sl()));
    sl.registerFactory(() => LoginCubit(loginServerUseCase: sl()));
    // usecase
    sl.registerLazySingleton(() => RegisterServerUseCase(sl()));
    sl.registerLazySingleton(() => LoginServerUseCase(sl()));
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
    sl.registerFactory(() => UnitCubit(fetchUnitsUseCase: sl()));

    // UseCase
    sl.registerLazySingleton(() => FetchUnitsUseCase(sl()));

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
    sl.registerFactory(() => VatCubit(fetchVatUseCase: sl()));
    // UseCase
    sl.registerLazySingleton(() => FetchVatUseCase(sl()));
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
    sl.registerFactory(() => GroupsCubit(fetchGroupsUseCase: sl()));
    // UseCase
    sl.registerLazySingleton(() => FetchGroupsUseCase(sl()));
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
    sl.registerFactory(() => ProductCubit(fetchProductsUseCase: sl()));

    // UseCase
    sl.registerLazySingleton(() => FetchProductsUseCase(sl()));

    // Data Source
    sl.registerLazySingleton<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- SETTINGS -------------------
    // Cubit
    sl.registerFactory(() => SettingsCubit(fetchSettingsUseCase: sl()));
    // UseCase
    sl.registerLazySingleton(() => FetchSettingsUseCase(sl()));
    // Data Source
    sl.registerLazySingleton<SettingsRemoteDataSource>(
      () => SettingsRemoteDataSourceImpl(),
    );
    // Repository
    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(remoteDataSource: sl()),
    );

    // ------------------- CATEGORIES -------------------
    // Cubit
    sl.registerFactory(() => CategoriesCubit(fetchCategoriesUseCase: sl()));
    // UseCase
    sl.registerLazySingleton(() => FetchCategoriesUseCase(sl()));
    // Data Source
    sl.registerLazySingleton<CategoriesRemoteDataSource>(
      () => CategoriesRemoteDataSourceImpl(),
    );
    // Repository
    sl.registerLazySingleton<CategoriesRepository>(
      () => CategoriesRepositoryImpl(remoteDataSource: sl()),
    );
  }
}
