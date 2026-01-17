class MasterResponseModel {
  final int status;
  final bool error;
  final String message;

  MasterResponseModel({
    required this.status,
    required this.error,
    required this.message,
  });

  factory MasterResponseModel.fromJson(Map<String, dynamic> json) {
    return MasterResponseModel(
      status: json['status'] as int,
      error: json['error'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'error': error, 'message': message};
  }
}
