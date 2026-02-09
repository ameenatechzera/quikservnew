class AccLedgerResponseModel {
  final int status;
  final bool error;
  final String message;

  AccLedgerResponseModel({
    required this.status,
    required this.error,
    required this.message,
  });

  factory AccLedgerResponseModel.fromJson(Map<String, dynamic> json) {
    return AccLedgerResponseModel(
      status: json['status'] ,
      error: json['error'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'error': error, 'message': message};
  }
}
