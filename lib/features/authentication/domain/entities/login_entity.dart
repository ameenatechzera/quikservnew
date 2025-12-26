class LoginResponseResult {
  final String token;
  final List<UserData> data;
  final String currentDatabaseName;

  LoginResponseResult({
    required this.token,
    required this.data,
    required this.currentDatabaseName,
  });

  factory LoginResponseResult.fromJson(Map<String, dynamic> json) {
    return LoginResponseResult(
      token: json["token"],
      data: (json["data"] as List).map((e) => UserData.fromJson(e)).toList(),
      currentDatabaseName: json["current_database_name"],
    );
  }
}

class UserData {
  final int id;
  final int userType;
  final String username;
  final String password;
  final int isActive;
  final String name;
  final List<int> branchIds;
  final String? createdDate;
  final String? modifiedDate;
  final String userTypeName;

  UserData({
    required this.id,
    required this.userType,
    required this.username,
    required this.password,
    required this.isActive,
    required this.name,
    required this.branchIds,
    this.createdDate,
    this.modifiedDate,
    required this.userTypeName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      userType: json["user_type"],
      username: json["username"],
      password: json["password"],
      isActive: json["isactive"],
      name: json["name"],
      // ✅ SAFE conversion
      branchIds:
          json["branchids"] == null
              ? []
              : (json["branchids"] is List
                  ? json["branchids"]
                      .map<int>((e) => int.parse(e.toString()))
                      .toList()
                  : [int.parse(json["branchids"].toString())]),

      createdDate: json["createddate"],
      modifiedDate: json["modifieddate"],
      userTypeName: json["usertype"],
    );
  }
}
