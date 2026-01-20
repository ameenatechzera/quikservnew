class SaveUserParameters {
  final String username;
  final String password;
  final int user_type;
  final int isactive;
  final String name;
  final List<int> branchIds;
  final String CreatedUser;

  SaveUserParameters({
    required this.username,
    required this.password,
    required this.user_type,
    required this.isactive,
    required this.name,
    required this.branchIds,
    required this.CreatedUser,

  });

  /// Convert model to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'username': username, // API expects "group_name"
      'password': password,
      'user_type': user_type,
      'isactive': isactive,
      'name': name,
      'branchIds': branchIds,
      'CreatedUser': CreatedUser,


    };
  }
}