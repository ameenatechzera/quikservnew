import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/sale/domain/entities/sale_save_response_entity.dart';

class SalesResponseModel extends Equatable {
  final int? status;
  final bool? error;
  final String? message;
  final SalesDetailsModel? details;

  const SalesResponseModel({
    this.status,
    this.error,
    this.message,
    this.details,
  });

  factory SalesResponseModel.fromJson(Map<String, dynamic> json) {
    return SalesResponseModel(
      status: json['status'] as int?,
      error: json['error'] as bool?,
      message: json['message'] as String?,
      details:
          json['details'] != null
              ? SalesDetailsModel.fromJson(json['details'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'message': message,
      'details': details?.toJson(),
    };
  }

  SalesResponseEntity toEntity() {
    return SalesResponseEntity(
      status: status,
      error: error,
      message: message,
      details: details?.toEntity(),
    );
  }

  @override
  List<Object?> get props => [status, error, message, details];
}

class SalesDetailsModel extends Equatable {
  final int? salesMasterId;
  final String? invoiceNo;
  final String? currentDate;

  const SalesDetailsModel({this.salesMasterId, this.invoiceNo , this.currentDate});

  factory SalesDetailsModel.fromJson(Map<String, dynamic> json) {
    return SalesDetailsModel(
      salesMasterId: json['SalesMasterId'] as int?,
      invoiceNo: json['InvoiceNo'] as String?,
      currentDate: json['currentDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'SalesMasterId': salesMasterId, 'InvoiceNo': invoiceNo , 'currentDate': currentDate};
  }

  SalesDetailsEntity toEntity() {
    return SalesDetailsEntity(
      salesMasterId: salesMasterId,
      invoiceNo: invoiceNo,
        currentDate: currentDate
    );
  }

  @override
  List<Object?> get props => [salesMasterId, invoiceNo,currentDate];
}
