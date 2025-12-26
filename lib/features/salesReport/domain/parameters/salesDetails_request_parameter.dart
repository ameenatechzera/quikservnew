class FetchSalesDetailsRequest {
  final String SalesMasterId;
  final String branchId;

  FetchSalesDetailsRequest({
    required this.SalesMasterId,

    required this.branchId
  });

  Map<String, dynamic> toJson() {
    return {
      "SalesMasterId": SalesMasterId,
      "branchId": branchId,

    };
  }
}
