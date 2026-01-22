import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/user_types_result.dart';
import 'package:quikservnew/features/masters/domain/repositories/user_creation_repository.dart';

class FetchUserTypesUseCase implements UseCaseWithoutParams<UserTypesResult> {
  final UserCreationRepository _userCreationRepository;

  FetchUserTypesUseCase(this._userCreationRepository);

  @override
  ResultFuture<UserTypesResult> call() async => _userCreationRepository.fetchUserTypes();
}