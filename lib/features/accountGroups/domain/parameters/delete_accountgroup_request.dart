class DeleteAccountGroupRequest {
  final String accGroupId;

  DeleteAccountGroupRequest({required this.accGroupId});

  Map<String, dynamic> toJson() {
    return {'accGroupId': accGroupId};
  }
}
