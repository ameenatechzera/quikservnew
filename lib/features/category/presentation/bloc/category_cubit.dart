import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/category/data/models/fetch_category_model.dart';
import 'package:quikservnew/features/category/domain/usecases/fetch_categories_usecase.dart';

part 'category_state.dart';

class CategoriesCubit extends Cubit<CategoryState> {
  final FetchCategoriesUseCase _fetchCategoriesUseCase;

  CategoriesCubit({required FetchCategoriesUseCase fetchCategoriesUseCase})
    : _fetchCategoriesUseCase = fetchCategoriesUseCase,
      super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());

    final response = await _fetchCategoriesUseCase();

    response.fold(
      (failure) => emit(CategoryError(error: failure.message)),
      (response) => emit(CategoryLoaded(categories: response)),
    );
  }
}
