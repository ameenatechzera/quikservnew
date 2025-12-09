class FetchUnitResponseEntity {
  final int? status;
  final bool? error;
  final String? message;
  final List<FetchUnitDetailsEntity>? details;

  FetchUnitResponseEntity({
    this.status,
    this.error,
    this.message,
    this.details,
  });
}

class FetchUnitDetailsEntity {
  final int? unitId;
  final String? unitName;
  final int? branchId;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedTime;
  final String? modifiedUser;

  FetchUnitDetailsEntity({
    this.unitId,
    this.unitName,
    this.branchId,
    this.createdDate,
    this.createdUser,
    this.modifiedTime,
    this.modifiedUser,
  });
}
