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
  const CategoryLoadedFromLocal({required this.categories});
}

class CategoryEmpty extends CategoryState {}

final class CategoryError extends CategoryState {
  final String error;

  const CategoryError({required this.error});
}
// ---------------- SAVE STATES ----------------

final class CategoryAddLoading extends CategoryState {}

final class CategoryAddSuccess extends CategoryState {
  final MasterResponseModel response;

  const CategoryAddSuccess({required this.response});
}

final class CategoryAddError extends CategoryState {
  final String error;

  const CategoryAddError({required this.error});
}

// Delete states
class CategoryDeleteLoading extends CategoryState {}

class CategoryDeleteSuccess extends CategoryState {
  final MasterResponseModel response;

  const CategoryDeleteSuccess({required this.response});
}

class CategoryDeleteError extends CategoryState {
  final String error;

  const CategoryDeleteError({required this.error});
}

class CategoryEditLoading extends CategoryState {}

class CategoryEditSuccess extends CategoryState {
  final MasterResponseModel response;

  const CategoryEditSuccess({required this.response});
}

class CategoryEditError extends CategoryState {
  final String error;

  const CategoryEditError({required this.error});
}
