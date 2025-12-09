part of 'category_cubit.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final FetchCategoryResponseModel categories;

  const CategoryLoaded({required this.categories});
}

final class CategoryError extends CategoryState {
  final String error;

  const CategoryError({required this.error});
}
