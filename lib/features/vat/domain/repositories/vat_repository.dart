import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/vat/data/models/fetch_vat_model.dart';

abstract class VatRepository {
  ResultFuture<FetchVatResponseModel> fetchVat();
}
