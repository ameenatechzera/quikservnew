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

class CategoryLoadedFromLocal extends CategoryState {
  final List<FetchCategoryDetailsEntity> categories;
  CategoryLoadedFromLocal({required this.categories});
}

class CategoryEmpty extends CategoryState {}

final class CategoryError extends CategoryState {
  final String error;

  const CategoryError({required this.error});
}
