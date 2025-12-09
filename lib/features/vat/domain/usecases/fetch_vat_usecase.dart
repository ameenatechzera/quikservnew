import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/vat/data/models/fetch_vat_model.dart';
import 'package:quikservnew/features/vat/domain/repositories/vat_repository.dart';

class FetchVatUseCase implements UseCaseWithoutParams<FetchVatResponseModel> {
  final VatRepository _vatRepository;

  FetchVatUseCase(this._vatRepository);

  @override
  ResultFuture<FetchVatResponseModel> call() async {
    return _vatRepository.fetchVat();
  }
}
