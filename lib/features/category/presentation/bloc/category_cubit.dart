import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/category/data/models/fetch_category_model.dart';
import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';
import 'package:quikservnew/features/category/domain/entities/save_category_entity.dart';
import 'package:quikservnew/features/category/domain/repositories/category_local_repository.dart';
import 'package:quikservnew/features/category/domain/usecases/fetch_categories_usecase.dart';
import 'package:quikservnew/features/category/domain/usecases/local_fetch_categories_usecase.dart';
import 'package:quikservnew/features/category/domain/usecases/save_category_usecase.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

part 'category_state.dart';

class CategoriesCubit extends Cubit<CategoryState> {
  final FetchCategoriesUseCase _fetchCategoriesUseCase;
  final CategoryLocalRepository _categoryLocalRepository;
  final GetLocalCategoriesUseCase _getLocalCategoriesUseCase;
  final SaveCategoryUseCase _saveCategoryUseCase;
  CategoriesCubit({
    required FetchCategoriesUseCase fetchCategoriesUseCase,
    required CategoryLocalRepository categoryLocalRepository,
    required GetLocalCategoriesUseCase getLocalCategoriesUseCase,
    required SaveCategoryUseCase saveCategoryUseCase,
  }) : _fetchCategoriesUseCase = fetchCategoriesUseCase,
       _categoryLocalRepository = categoryLocalRepository,
       _getLocalCategoriesUseCase = getLocalCategoriesUseCase,
       _saveCategoryUseCase = saveCategoryUseCase,
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

  // --------------------- SAVE CATEGORY ---------------------
  Future<void> saveCategory(SaveCategoryRequestModel request) async {
    emit(CategoryAddLoading());

    final response = await _saveCategoryUseCase(request);

    response.fold((failure) => emit(CategoryAddError(error: failure.message)), (
      MasterResponseModel success,
    ) async {
      emit(CategoryAddSuccess(response: success));

      // refresh list after save
      await fetchCategories();
    });
  }
}
