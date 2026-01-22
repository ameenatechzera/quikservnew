import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/cashierlist_result.dart';
import 'package:quikservnew/features/masters/domain/entities/supplierlist_result.dart';
import 'package:quikservnew/features/masters/domain/repositories/user_creation_repository.dart';

class FetchSupplierListUseCase implements UseCaseWithoutParams<SupplierListResponse> {
  final UserCreationRepository _userCreationRepository;

  FetchSupplierListUseCase(this._userCreationRepository);

  @override
  ResultFuture<SupplierListResponse> call() async => _userCreationRepository.fetchSupplierList();
}