import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/category/data/models/fetch_category_model.dart';
import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';
import 'package:quikservnew/features/category/domain/repositories/category_local_repository.dart';
import 'package:quikservnew/features/category/domain/usecases/fetch_categories_usecase.dart';
import 'package:quikservnew/features/category/domain/usecases/local_fetch_categories_usecase.dart';

part 'category_state.dart';

class CategoriesCubit extends Cubit<CategoryState> {
  final FetchCategoriesUseCase _fetchCategoriesUseCase;
  final CategoryLocalRepository _categoryLocalRepository;
  final GetLocalCategoriesUseCase _getLocalCategoriesUseCase;
  CategoriesCubit({
    required FetchCategoriesUseCase fetchCategoriesUseCase,
    required CategoryLocalRepository categoryLocalRepository,
    required GetLocalCategoriesUseCase getLocalCategoriesUseCase,
  }) : _fetchCategoriesUseCase = fetchCategoriesUseCase,
       _categoryLocalRepository = categoryLocalRepository,
       _getLocalCategoriesUseCase = getLocalCategoriesUseCase,
       super(CategoryInitial());
  // --------------------- API Fetch ---------------------
  Future<void> fetchCategories() async {
    emit(CategoryLoading());

    final response = await _fetchCategoriesUseCase();

    response.fold((failure) => emit(CategoryError(error: failure.message)), (
      categoryResponse,
    ) async {
      // ✅ Extract list
      final categoriesList = categoryResponse.categories ?? [];

      // ✅ Save to local DB
      await _categoryLocalRepository.saveCategories(categoriesList);

      // ✅ Emit loaded state
      emit(CategoryLoaded(categories: categoryResponse));
    });
  }

  // 🚀 Load categories from LOCAL DB (offline)
  // --------------------- LOCAL Fetch ---------------------
  Future<void> loadCategoriesFromLocal() async {
    emit(CategoryLoading());

    try {
      final localCats = await _getLocalCategoriesUseCase();

      if (localCats.isEmpty) {
        emit(CategoryEmpty());
      } else {
        emit(CategoryLoadedFromLocal(categories: localCats));
      }
    } catch (e) {
      emit(CategoryError(error: e.toString()));
    }
  }
}
