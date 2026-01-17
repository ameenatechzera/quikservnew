import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/vat/data/models/fetch_vat_model.dart';
import 'package:quikservnew/features/vat/domain/entities/add_vat_entity.dart';
import 'package:quikservnew/features/vat/domain/parameters/update_vat_parameter.dart';

abstract class VatRepository {
  ResultFuture<FetchVatResponseModel> fetchVat();
  ResultFuture<MasterResponseModel> addVat(AddVatRequestModel request);
  ResultFuture<MasterResponseModel> deleteVat(int vatId);
  ResultFuture<MasterResponseModel> updateVatFromServer(
    int vatId,
    EditVatRequestModel request,
  );
}
