import '../meal_entity.dart';
import '../meal_repository.dart';

class SaveFavorite {
      final MealRepository repository;

      SaveFavorite(this.repository);

      Future<void> call(MealEntity meal) {
        
        if (meal.id.trim().isEmpty) {
          throw ArgumentError('ID mon an khong duoc rong');
        }
        if (meal.name.trim().isEmpty) {
          throw ArgumentError('Ten mon an khong duoc rong');
        }
        return repository.saveFavorite(meal);
      }
}