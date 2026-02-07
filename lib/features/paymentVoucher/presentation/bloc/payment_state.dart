part of 'payment_cubit.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

class SavePaymentFailure extends PaymentState {
  final String message;

   SavePaymentFailure(this.message);
}
class SavePaymentSuccess extends PaymentState {
  final MasterResponseModel response;

  SavePaymentSuccess({required this.response});
}