import 'package:quikservnew/features/vat/domain/entities/fetch_vat_entity.dart';

class FetchVatResponseModel extends FetchVatResponse {
  FetchVatResponseModel({
    super.status,
    super.error,
    super.message,
    List<FetchVatDetailsModel>? super.vatDetails,
  });

  factory FetchVatResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchVatResponseModel(
      status: json['status'],
      error: json['error'],
      message: json['message'],
      vatDetails:
          json['vat_details'] != null
              ? List<FetchVatDetailsModel>.from(
                json['vat_details'].map(
                  (x) => FetchVatDetailsModel.fromJson(x),
                ),
              )
              : [],
    );
  }
}

class FetchVatDetailsModel extends FetchVatDetails {
  FetchVatDetailsModel({
    super.vatId,
    super.vatName,
    super.vatPercentage,
    super.branchId,
    super.createdDate,
    super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
  });

  factory FetchVatDetailsModel.fromJson(Map<String, dynamic> json) {
    return FetchVatDetailsModel(
      vatId: json['vat_id'],
      vatName: json['vatname'],
      vatPercentage: json['vatpercentage'],
      branchId: json['branchid'],
      createdDate: json['createddate'],
      createdUser: json['createduser'],
      modifiedDate: json['modifieddate'],
      modifiedUser: json['modifieduser'],
    );
  }
}
