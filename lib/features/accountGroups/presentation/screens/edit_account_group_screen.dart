import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/accountGroups/domain/entities/accountGroupResponse.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/save_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/update_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/presentation/bloc/account_group_cubit.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class AccountGroupEntryScreen extends StatefulWidget {
  final String? groupId; // Null for add, has value for edit
  final String? groupName;
  final String? groupUnder;
  final String? pageFrom;

  const AccountGroupEntryScreen(
      {super.key,
        this.groupId,
        this.groupName,
        this.groupUnder,
        this.pageFrom});

  @override
  State<AccountGroupEntryScreen> createState() => _AccGroupEntryScreenState();
}

class _AccGroupEntryScreenState extends State<AccountGroupEntryScreen> {
  final _groupNameController = TextEditingController();
  final _groupUnderController = TextEditingController();
  final _groupIdController = TextEditingController();
  final _buttontextController = TextEditingController();
  final List<AccountGroups> list1 = [];
  String? selectedGroupId;
  String st_DbName = '', st_CompanyName = '', st_username = '', st_title ='';

  @override
  void initState() {
    // TODO: implement initState
    getCompanyDetails();
    // Check if we're in edit mode (groupId is provided)
    final isEditing = widget.groupId != null;
     st_title = isEditing ? 'Edit Group' : 'Add Group';
   // context.read<AppbarCubit>().groupEntryPageSelected(title: title);
    if (widget.groupId != null) {
      _groupIdController.text = widget.groupId!;
      _groupNameController.text = widget.groupName ?? '';
      print('GroupId ${widget.groupId!}');
      print('groupName ${widget.groupName!}');
      _groupUnderController.text = widget.groupUnder ?? '';
      selectedGroupId = widget.groupUnder;
      print('groupUnder ${widget.groupUnder!}');
      _buttontextController.text =
      'Update'; // Set selectedGroupId from widget.groupUnder
      if (widget.groupUnder != null && widget.groupUnder!.isNotEmpty) {
        selectedGroupId = widget.groupUnder;
        print(
            'Initial selectedGroupId set to: $selectedGroupId from widget.groupUnder: ${widget.groupUnder}');
      }
    } else {
      _buttontextController.text = 'Add';
    }
    //_buttontextController.text = 'Add';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: TechzeraColors.white,
        appBar: CommonAppBar(
        title:st_title,
        ),
      body:Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 GROUP NAME FIELD
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _groupNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: 'Group',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 3.0, horizontal: 1.0),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),

              /// 🔹 GROUP DROPDOWN
              BlocBuilder<AccountGroupCubit, AccountGroupState>(
                builder: (context, state) {
                  if (state is AccountGroupsLoaded) {

                    AccountGroups? selectedGroup;
                    if (selectedGroupId != null) {
                      try {
                        selectedGroup = state.account_groups.firstWhere(
                              (g) => g.groupId.toString() == selectedGroupId,
                        );
                      } catch (_) {
                        selectedGroup = null;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<AccountGroups>(
                        value: selectedGroup,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 1.0),
                        ),
                        isExpanded: true,
                        hint: const Text('Select under which Account Group'),
                        items: state.account_groups.map((group) {
                          return DropdownMenuItem<AccountGroups>(
                            value: group,
                            child: Text(group.accountGroupName),
                          );
                        }).toList(),
                        onChanged: (group) {
                          if (group != null) {
                            setState(() {
                              selectedGroupId = group.groupId.toString();
                            });
                          }
                        },
                      ),
                    );
                  }
                  else if (state is AccountGroupsError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Failed to load groups: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  else {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),

              /// 🔹 SAVE BUTTON
              BlocConsumer<AccountGroupCubit, AccountGroupState>(
                listener: (context, state) {
                  if (state is SaveAccountGroupCompleted || state is UpdateAccountGroupCompleted) {
                    Navigator.pop(context);
                    context.read<AccountGroupCubit>().fetchAccountGroups(
                    );
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appThemeOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          if (_groupNameController.text.trim().isEmpty) {
                            Fluttertoast.showToast(msg: "Please fill group name");
                            return;
                          }

                          if (selectedGroupId == null) {
                            Fluttertoast.showToast(msg: "Please select account group");
                            return;
                          }
                          if(st_title =='Edit Group'){
                            context.read<AccountGroupCubit>().updateAccountGroups(
                                UpdateAccountGroupRequest(AccountGroupCode: '', accountGroupName: _groupNameController.text.toString(),
                                    groupUnder: selectedGroupId!, narration: '', LedgerNextNo: '', branchId: '', ModifiedUser: st_username.toString().trim(), acc_groupId: _groupIdController.text.toString()
                                ),
                            );
                                    }
                          else{
                            context.read<AccountGroupCubit>().saveAccountGroups(
                              SaveAccountGroupRequest(AccountGroupCode: '', accountGroupName: _groupNameController.text.toString(),
                                  groupUnder: selectedGroupId!, narration: '', LedgerNextNo: '', branchId: '', CreatedUser: st_username.toString().trim()

                              ),
                            );
                          }




                        },
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: Text(
                          _buttontextController.text,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      )

    );
  }

  Future<void> getCompanyDetails() async {
    final sharedPrefHelper = SharedPreferenceHelper();
    st_DbName = (await sharedPrefHelper.getDatabaseName())!;
    //st_DbName = (await sharedPrefHelper.get())!;

    // await SharedPrefrence().getUserName().then((value) async {
    //   print('st_username $value');
    //   st_username = value.toString();
    // });
    // await SharedPrefrence().getCompanyName().then((value) async {
    //   print('st_CompanyName $value');
    //   st_CompanyName = value.toString();
    // });

    context.read<AccountGroupCubit>().fetchAccountGroups(
        );
  }
}
