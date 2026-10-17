import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/meal_entity.dart';
import '../domain/meal_repository.dart';
import 'meal_model.dart';

class MealRepositoryImpl implements MealRepository {
  final http.Client client;

  MealRepositoryImpl({required this.client});

  @override
  Future<List<MealEntity>> search(String id) async {
    final res = await client.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$id'),
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
}