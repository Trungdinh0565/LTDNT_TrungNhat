import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/meal_entity.dart';
import '../domain/meal_usecase/getfavorite.dart';
import '../domain/meal_usecase/savefavorite.dart';
import '../domain/meal_usecase/search.dart';
import 'package:flutter/foundation.dart';

enum FridgeStatus { initial, loading, success, empty, error }

class FridgeState {
  final FridgeStatus status;
  final List<MealEntity> meals;
  final String? message;
  final bool showingFavorites;
  const FridgeState({
    this.status = FridgeStatus.initial,
    this.meals = const [],
    this.message,
    this.showingFavorites = false,
  });
}

class FridgeCubit extends Cubit<FridgeState> {
  final SearchMeals _searchMeals;
  final GetFavorite _getFavorite;
  final SaveFavorite _saveFavorite;
  String _lastQuery = '';
  bool _showingFavorites = false;

  FridgeCubit(this._searchMeals, this._getFavorite, this._saveFavorite)
      : super(const FridgeState());

  Future<void> search(String query) async {
    _lastQuery = query.trim();
    _showingFavorites = false;
    if (_lastQuery.isEmpty) {
      emit(const FridgeState(status: FridgeStatus.empty, message: 'Hãy nhập tên món ăn.'));
      return;
    }
    emit(const FridgeState(status: FridgeStatus.loading));
    try {
      final meals = await _searchMeals(_lastQuery);
      if (isClosed) return;
      emit(FridgeState(
        status: meals.isEmpty ? FridgeStatus.empty : FridgeStatus.success,
        meals: meals,
        message: meals.isEmpty ? 'Không tìm thấy món ăn phù hợp.' : null,
      ));
    } catch (error) {
      if (isClosed) return;
      emit(FridgeState(status: FridgeStatus.error, message: 'Không thể tìm món: $error'));
    }
  }

  Future<void> showFavorites() async {
    _showingFavorites = true;
    emit(const FridgeState(status: FridgeStatus.loading, showingFavorites: true));
    try {
      final meals = await _getFavorite();
      if (isClosed) return;
      emit(FridgeState(
        showingFavorites: true,
        status: meals.isEmpty ? FridgeStatus.empty : FridgeStatus.success,
        meals: meals,
        message: meals.isEmpty ? 'Chưa có món yêu thích.' : null,
      ));
    } catch (error) {
      if (isClosed) return;
      emit(FridgeState(status: FridgeStatus.error, showingFavorites: true, message: 'Không thể tải yêu thích: $error'));
    }
  }

  
Future<bool> saveFavorite(MealEntity meal) async {
  try {
    await _saveFavorite(meal);

    if (_showingFavorites) {
      await showFavorites();
    }

    return true;
  } catch (e, stackTrace) {
  debugPrint('LOI LUU MON YEU THICH: $e');
  debugPrint('STACK TRACE: $stackTrace');
  return false;
  }
}


  Future<void> retry() => _showingFavorites ? showFavorites() : search(_lastQuery);
}
