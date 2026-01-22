
import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/cashierlist_result.dart';
import 'package:quikservnew/features/masters/domain/repositories/user_creation_repository.dart';

class FetchCashierListUseCase implements UseCaseWithoutParams<CashierListResponse> {
  final UserCreationRepository _userCreationRepository;

  FetchCashierListUseCase(this._userCreationRepository);

  @override
  ResultFuture<CashierListResponse> call() async => _userCreationRepository.fetchCashierList();
}