part of 'item_cubit.dart';

@immutable
sealed class ItemState {}

final class ItemInitial extends ItemState {}
final class ItemWiseDetailInitial extends ItemState {}

class ItemDetailFailure extends ItemState {
  final String error;

  ItemDetailFailure(this.error);
}
class ItemDetailLoaded extends ItemState {
  final List<SummaryReport> itemWisReport;

  ItemDetailLoaded({required this.itemWisReport});

}
