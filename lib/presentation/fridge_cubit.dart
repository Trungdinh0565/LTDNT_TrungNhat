
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/meal_entity.dart';
import '../domain/meal_usecase/search.dart';

enum FridgeStatus {
  initial,
  loading,
  success,
  empty,
  error,
}

class FridgeState {
  final FridgeStatus status;
  final List<MealEntity> meals;
  final String? message;

  const FridgeState({
    this.status = FridgeStatus.initial,
    this.meals = const [],
    this.message,
  });
}

class FridgeCubit extends Cubit<FridgeState> {
  final SearchMeals _searchMeals;

  String _lastQuery = '';

  FridgeCubit(this._searchMeals)
      : super(const FridgeState());

  Future<void> search(String query) async {
    _lastQuery = query.trim();

    if (_lastQuery.isEmpty) {
      emit(const FridgeState(
        status: FridgeStatus.empty,
        message: 'Hãy nhập tên món ăn.',
      ));
      return;
    }

    emit(const FridgeState(
      status: FridgeStatus.loading,
    ));

    try {
      final meals = await _searchMeals(_lastQuery);

      if (isClosed) return;

      emit(FridgeState(
        status: meals.isEmpty
            ? FridgeStatus.empty
            : FridgeStatus.success,
        meals: meals,
        message: meals.isEmpty
            ? 'Không tìm thấy món ăn phù hợp.'
            : null,
      ));
    } catch (e) {
      if (isClosed) return;

      emit(FridgeState(
        status: FridgeStatus.error,
        message: 'Không thể tìm món: $e',
      ));
    }
  }

  Future<void> retry() => search(_lastQuery);
}
