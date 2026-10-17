
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/meal_repository_impl.dart';
import 'domain/meal_repository.dart';
import 'domain/meal_usecase/search.dart';
import 'presentation/fridge_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Dang ky HTTP Client
  sl.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  // Dang ky Repository
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(
      client: sl<http.Client>(),
    ),
  );

  // Dang ky Search UseCase
  sl.registerLazySingleton<SearchMeals>(
    () => SearchMeals(sl<MealRepository>()),
  );

  // Dang ky FridgeCubit
  sl.registerFactory<FridgeCubit>(
    () => FridgeCubit(sl<SearchMeals>()),
  );
}
