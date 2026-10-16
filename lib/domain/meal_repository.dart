import 'meal_entity.dart';

abstract class MealRepository {

  Future<List<MealEntity>> searchMeals (String keyword);

  Future<MealEntity?> getDetail (String id);

  Future<List<MealEntity>> getFavorites ();

  Future<void> saveFavorite (MealEntity meal);

  Future<void> removeFavorite (String id);
}