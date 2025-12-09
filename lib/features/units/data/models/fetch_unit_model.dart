import 'package:quikservnew/features/units/domain/entities/fetch_unit_entity.dart';

class FetchUnitResponseModel extends FetchUnitResponseEntity {
  FetchUnitResponseModel({
    super.status,
    super.error,
    super.message,
    List<FetchUnitDetailsModel>? super.details,
  });

  factory FetchUnitResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchUnitResponseModel(
      status: json['status'],
      error: json['error'],
      message: json['message'],
      details:
          json['details'] != null
              ? List<FetchUnitDetailsModel>.from(
                json['details'].map((x) => FetchUnitDetailsModel.fromJson(x)),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "error": error,
      "message": message,
      "details":
          details?.map((x) => (x as FetchUnitDetailsModel).toJson()).toList(),
    };
  }
}

class FetchUnitDetailsModel extends FetchUnitDetailsEntity {
  FetchUnitDetailsModel({
    super.unitId,
    super.unitName,
    super.branchId,
    super.createdDate,
    super.createdUser,
    super.modifiedTime,
    super.modifiedUser,
  });

  factory FetchUnitDetailsModel.fromJson(Map<String, dynamic> json) {
    return FetchUnitDetailsModel(
      unitId: json['unit_id'],
      unitName: json['unit_name'],
      branchId: json['branchId'],
      createdDate: json['CreatedDate'],
      createdUser: json['CreatedUser'],
      modifiedTime: json['modified_time'],
      modifiedUser: json['modified_user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "unit_id": unitId,
      "unit_name": unitName,
      "branchId": branchId,
      "CreatedDate": createdDate,
      "CreatedUser": createdUser,
      "modified_time": modifiedTime,
      "modified_user": modifiedUser,
    };
  }
}
