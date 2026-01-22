import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_snackbar.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/masters/domain/entities/cashierlist_result.dart';
import 'package:quikservnew/features/masters/domain/entities/supplierlist_result.dart';
import 'package:quikservnew/features/masters/presentation/bloc/user_creation_cubit.dart';
import 'package:quikservnew/features/masters/presentation/screens/user_creation_screen.dart';
import 'package:quikservnew/features/masters/presentation/widgets/user_widgets.dart';

class UsersListScreen extends StatelessWidget {
   UsersListScreen({super.key});
  final List<SupplierList> supplierList =[];
   final List<CashierList> cashierList =[];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCreationCubit>().fetchUserTypes();
    });
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3F6),
      appBar: CommonAppBar(
        title: "Users List",

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: UserCreationScreen(),
              );
            },
          ),
        ],
      ),
        body: BlocConsumer<UserCreationCubit, UserCreationState>(
          listener: (context, state) {
            if (state is FetchCashierListLoaded) {
              context.read<UserCreationCubit>().fetchSupplierList();
              cashierList
                ..clear()
                ..addAll(state.cashierList);
            }

            if (state is FetchSupplierListLoaded) {
              supplierList
                ..clear()
                ..addAll(state.supplierList);
            }

            if (state is FetchUserTypesLoaded) {
              context.read<UserCreationCubit>().fetchCashierList();
            }
          },
          builder: (context, state) {
            final bool isLoading =
                state is FetchCashierListInitial ||
                    state is FetchSupplierListInitial ||
                    state is FetchUserTypesInitial;

            return Stack(
              children: [
                // 🔹 MAIN CONTENT
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ---------- SUPPLIERS ----------
                    sectionTitle("Suppliers"),
                    const SizedBox(height: 8),

                    ListView.builder(
                      itemCount: supplierList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return userTile(
                          name: supplierList[index].name,
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // ---------- CASHIERS ----------
                    sectionTitle("Cashiers"),
                    const SizedBox(height: 8),

                    ListView.builder(
                      itemCount: cashierList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return userTile(
                          name: cashierList[index].name,
                        );
                      },
                    ),
                  ],
                ),

                // 🔹 LOADER OVERLAY
                if (isLoading)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black26, // optional dim background
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        )


    );
  }

}
