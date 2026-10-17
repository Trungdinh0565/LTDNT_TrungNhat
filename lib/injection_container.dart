import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'data/meal_repository_impl.dart';
import 'domain/meal_repository.dart';
import 'domain/meal_usecase/getfavorite.dart';
import 'domain/meal_usecase/savefavorite.dart';
import 'domain/meal_usecase/search.dart';
import 'presentation/fridge_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(client: sl<http.Client>(), prefs: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<SearchMeals>(() => SearchMeals(sl<MealRepository>()));
  sl.registerLazySingleton<GetFavorite>(() => GetFavorite(sl<MealRepository>()));
  sl.registerLazySingleton<SaveFavorite>(() => SaveFavorite(sl<MealRepository>()));
  sl.registerFactory<FridgeCubit>(
    () => FridgeCubit(sl<SearchMeals>(), sl<GetFavorite>(), sl<SaveFavorite>()),
  );
}
