import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/accountGroups/domain/entities/accountGroupResponse.dart';
import 'package:quikservnew/features/accountGroups/presentation/bloc/account_group_cubit.dart';

import 'edit_account_group_screen.dart';

class AccountGroupListingScreen extends StatelessWidget {
  AccountGroupListingScreen({super.key});

  final _groupNameController = TextEditingController();
  final _groupIdController = TextEditingController();
  final _buttontextController = TextEditingController();
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
            //pr.hide();
            list1.clear();
            list1.addAll(state.account_groups);
          } // 👇 Add this so list reloads after Add/Update/Delete
          // if (state is AccountGroupsLoaded
          //     // state is UpdateAccountGroupFromServerSuccess ||
          //     // state is AccountGroupDeleteFromServerSuccess
          // ) {
          //   context.read<AccountGroupCubit>().fetchAllAccountGroupsFromServer(
          //     CommonParameter(db_name: AppData.dbName!),
          //   );
          // }
        },
        builder: (context, state) {
          if (state is AccountGroupInitial) {
            return Center(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 150,
                    // ),
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('GroupList Loading.....'),
                    )
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
                    // color: Colors.white,
                    height: 60,
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15), // Rounded corners
                      ),
                      child: ListTile(
                        tileColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        // Remove default padding for ListTile
                        title: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            list1[index].accountGroupName.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  print(
                                      'Editing group: ${list1[index].groupId}');
                                  print(
                                      'Group name: ${list1[index].accountGroupName}');
                                  print(
                                      'Group under: ${list1[index].groupUnder}'); // Check this value
                                  print(
                                      'Group under type: ${list1[index].groupUnder.runtimeType}'); // Check type

                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return AccountGroupEntryScreen(
                                          groupId:
                                          list1[index].groupId.toString(),
                                          groupName:
                                          list1[index].accountGroupName.toString(),
                                          groupUnder: list1[index].groupUnderName,
                                        );
                                      }));
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () async {
                                  _groupIdController.text =
                                      list1[index].groupId.toString();
                                  bool? confirmed =
                                  await _showConfirmationDialog(
                                      context);
                                  print('confirmed $confirmed');
                                  if (confirmed == true) {
                                    // context
                                    //     .read<AccountGroupCubit>()
                                    //     .deleteAccountGroupFromServer(
                                    //     AccountGroupDeleteRequest(
                                    //         dbName: AppData.dbName!,
                                    //         groupId: int.parse(
                                    //             _groupIdController
                                    //                 .text)));
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                // separatorBuilder:
                //     (BuildContext context, int index) {
                //   return const Padding(
                //     padding: EdgeInsets.only(top: 17.0),
                //     child: Divider(),
                //   );
                // },
              ),
            );
          }
          // if (state is GroupDeleteFromServerSuccess ||
          //     state is ProductGroupToServerSuccess) {
          //   context.read<GroupCubit>().fetchAllAccountGroupsFromServer(
          //       CommonParameter(db_name: AppData.dbName!));
          // }

          return Container(
            color: Colors.white,
            height: 50,
          );
        },
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to delete?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Return false when Cancel is pressed
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Return true when Confirm is pressed
                },
              ),
            ],
          );
        });
  }
}