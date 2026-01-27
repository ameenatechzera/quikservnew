import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountGroups/data/models/accountGroupModel.dart';
import 'package:quikservnew/features/accountGroups/domain/entities/accountGroupResponse.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/delete_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/save_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/update_accountgroup_request.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

abstract class AccountGroupRepository {
  ResultFuture<AccountGroupResponse> fetchAccountGroups();

  ResultFuture<MasterResponseModel> saveAccountGroup(
    SaveAccountGroupRequest params,
  );

  ResultFuture<MasterResponseModel> deleteAccountGroup(
    DeleteAccountGroupRequest request,
  );

  ResultFuture<MasterResponseModel> updateAccountGroup(
      UpdateAccountGroupRequest request,
  );
}
