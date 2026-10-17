import '../meal_entity.dart';
import '../meal_repository.dart';

class GetFavorite {
      final MealRepository repository;

      GetFavorite(this.repository);

      Future<List<MealEntity>> call() {
        return repository.getFavorites();
      }

}

