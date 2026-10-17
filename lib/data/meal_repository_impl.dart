
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/meal_entity.dart';
import '../domain/meal_repository.dart';
import 'meal_model.dart';

class MealRepositoryImpl implements MealRepository {
  final http.Client client;
  final SharedPreferences prefs;

  MealRepositoryImpl({required this.client, required this.prefs});

  @override
  Future<List<MealEntity>> search(String name) async {
    final res = await client.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$name'),
    );

    if (res.statusCode != 200) {
      throw Exception('Loi ket noi');
    }

    final json = jsonDecode(res.body);
    if (json['meals'] != null) {
      return (json['meals'] as List).map((e) => MealModel.fromJson(e)).toList();
    }

    return [];
  }

  @override
  Future<MealEntity?> getDetail(String id) async {
    final res = await client.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );

    if (res.statusCode != 200) {
      throw Exception('Loi ket noi');
    }

    final json = jsonDecode(res.body);
    if (json['meals'] != null && (json['meals'] as List).isNotEmpty) {
      return MealModel.fromJson(json['meals'][0]);
    }
    
    return null;
  }

  @override
  Future<List<MealEntity>> getFavorites() async {
    final str = prefs.getString('FAV_MEALS');
    if (str != null) {
      final List list = jsonDecode(str);
      return list.map((e) => MealModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> saveFavorite(MealEntity meal) async {
    final save = await getFavorites() as List<MealModel>;
    final idx = save.indexWhere((e) => e.id == meal.id);

    if (idx == -1) {
      final model = MealModel(
        id: meal.id,
        name: meal.name,
        imageUrl: meal.imageUrl,
        instructions: meal.instructions,
        from: meal.from,
        isFavorite: true,
      );
      save.add(model);
      await prefs.setString(
        'FAV_MEALS',
        jsonEncode(save.map((e) => e.toJson()).toList()),
      );
    }
  }

  @override
  Future<void> removeFavorite(String id) async {
    final save = await getFavorites() as List<MealModel>;
    save.removeWhere((e) => e.id == id);

    await prefs.setString(
      'FAV_MEALS',
      jsonEncode(save.map((e) => e.toJson()).toList()),
    );
  }
}
