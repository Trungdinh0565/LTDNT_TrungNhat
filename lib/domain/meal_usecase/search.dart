import '../meal_entity.dart';
import '../meal_repository.dart';

class SearchMeals {
      final MealRepository repository;
      
      SearchMeals(this.repository);

      Future<List<MealEntity>> call(String keyword) async {
            final checkkeyword = keyword.trim();

            if (checkkeyword.isEmpty){
                return [];
            }
            if (checkkeyword.length > 80) {
                throw ArgumentError('Do dai khong hop le');
            }
            return repository.search(checkkeyword);
      }
}