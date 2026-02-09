class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;
  final int userId;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.userId,
  });

  /// Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'userid': userId,
    };
  }
}
