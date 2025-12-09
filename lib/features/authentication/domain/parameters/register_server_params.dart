class RegisterServerRequest {
  final int slno;

  RegisterServerRequest({required this.slno});

  Map<String, dynamic> toJson() => {"slno": slno};
}
