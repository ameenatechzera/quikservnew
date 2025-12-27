import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/database/app_database.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/logincubit/login_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/screens/splash_screen.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';
import 'package:quikservnew/services/service_locator.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

late final AppDatabase appDb;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appDb = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  await ServiceLocator.init();
  final sharedPrefHelper = SharedPreferenceHelper();

  // set the default URL if not already set
  final currentBaseUrl = await sharedPrefHelper.getBaseUrl();
  if (currentBaseUrl == null) {
    await sharedPrefHelper.setBaseUrl(
      'https://techzera.in/quikSERV_Api/public/api',
    );
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Color(0xFFffeeb7), // 👈 background color
    //     statusBarIconBrightness: Brightness.dark, // Android icons
    //     statusBarBrightness: Brightness.dark, // iOS icons
    //   ),
    // );
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterCubit>(create: (_) => sl<RegisterCubit>()),
        BlocProvider<LoginCubit>(create: (_) => sl<LoginCubit>()),
        BlocProvider<UnitCubit>(create: (_) => sl<UnitCubit>()),
        BlocProvider<VatCubit>(create: (_) => sl<VatCubit>()),
        BlocProvider<GroupsCubit>(create: (_) => sl<GroupsCubit>()),
        BlocProvider<ProductCubit>(create: (_) => sl<ProductCubit>()),
        BlocProvider<SettingsCubit>(create: (_) => sl<SettingsCubit>()),
        BlocProvider<CategoriesCubit>(create: (_) => sl<CategoriesCubit>()),
        BlocProvider<SaleCubit>(create: (_) => sl<SaleCubit>()),
        BlocProvider<SalesReportCubit>(create: (_) => sl<SalesReportCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
