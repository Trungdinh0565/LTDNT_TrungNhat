import 'meal_entity.dart';

abstract class MealRepository {
  Future<List<MealEntity>> search(String keyword);

  Future<MealEntity?> getDetail(String id);
}