import 'package:quikservnew/features/groups/domain/entities/fetch_group_entity.dart';

class FetchGroupResponseModel extends FetchGroupResponse {
  FetchGroupResponseModel({
    super.status,
    super.error,
    super.message,
    List<FetchGroupDetailsModel>? super.groupDetails,
  });

  factory FetchGroupResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchGroupResponseModel(
      status: json['status'],
      error: json['error'],
      message: json['message'],
      groupDetails:
          json['group_details'] != null
              ? List<FetchGroupDetailsModel>.from(
                json['group_details'].map(
                  (x) => FetchGroupDetailsModel.fromJson(x),
                ),
              )
              : [],
    );
  }
}

class FetchGroupDetailsModel extends FetchGroupDetails {
  FetchGroupDetailsModel({
    super.groupId,
    super.groupName,
    super.createdDate,
    super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
    super.branchId,
  });

  factory FetchGroupDetailsModel.fromJson(Map<String, dynamic> json) {
    return FetchGroupDetailsModel(
      groupId: json['group_id'],
      groupName: json['group_name'],
      createdDate: json['CreatedDate'],
      createdUser: json['CreatedUser'],
      modifiedDate: json['modified_time'],
      modifiedUser: json['modified_user'],
      branchId: json['branchId'],
    );
  }
}
