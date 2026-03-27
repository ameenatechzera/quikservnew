import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_snackbar.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/accountGroups/domain/entities/account_group_response.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/delete_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/presentation/bloc/account_group_cubit.dart';
import 'package:quikservnew/features/accountGroups/presentation/helper/account_group_helper.dart';

import 'edit_account_group_screen.dart';

class AccountGroupListingScreen extends StatelessWidget {
  AccountGroupListingScreen({super.key});

  final _groupIdController = TextEditingController();
  final List<AccountGroups> list1 = [];

  @override
  Widget build(BuildContext context) {
    context.read<AccountGroupCubit>().fetchAccountGroups();
    return Scaffold(
      appBar: CommonAppBar(
        title: "Account Group",

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: const AccountGroupEntryScreen(),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AccountGroupCubit, AccountGroupState>(
        listener: (context, state) {
          if (state is AccountGroupsLoaded) {
            list1.clear();
            list1.addAll(state.accountGroups);
          }
          if (state is DeleteAccountGroupCompleted) {
            context.read<AccountGroupCubit>().fetchAccountGroups();
          }
          if (state is DeleteAccountGroupsError) {
            showAppSnackBar(context, "Deletion failed..!");
          }
        },
        builder: (context, state) {
          if (state is AccountGroupInitial ||
              state is DeleteAccountGroupInitial) {
            return Center(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('GroupList Loading.....'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is AccountGroupsLoaded) {
            return Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: list1.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 60,
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        tileColor: Colors.white,
                        contentPadding: EdgeInsets.zero,

                        title: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            list1[index].accountGroupName.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AccountGroupEntryScreen(
                                        groupId: list1[index].groupId
                                            .toString(),
                                        groupName: list1[index].accountGroupName
                                            .toString(),
                                        groupUnder: list1[index].groupUnder
                                            .toString(),
                                      );
                                    },
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                _groupIdController.text = list1[index].groupId
                                    .toString();
                                bool? confirmed = await showConfirmationDialog(
                                  context,
                                );
                                if (confirmed == true) {
                                  context
                                      .read<AccountGroupCubit>()
                                      .deleteAccountGroups(
                                        DeleteAccountGroupRequest(
                                          accGroupId: _groupIdController.text
                                              .toString(),
                                        ),
                                      );
                                }
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container(color: Colors.white, height: 50);
        },
      ),
    );
  }
}
