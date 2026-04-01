class SaveUserParameters {
  final String username;
  final String password;
  final int usertype;
  final int isactive;
  final String name;
  final List<int> branchIds;
  final String createdUser;

  SaveUserParameters({
    required this.username,
    required this.password,
    required this.usertype,
    required this.isactive,
    required this.name,
    required this.branchIds,
    required this.createdUser,
  });

  /// Convert model to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'username': username, // API expects "group_name"
      'password': password,
      'user_type': usertype,
      'isactive': isactive,
      'name': name,
      'branchIds': branchIds,
      'CreatedUser': createdUser,
    };
  }
}
