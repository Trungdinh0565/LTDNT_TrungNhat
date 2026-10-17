import '../domain/meal_entity.dart';

class MealModel extends MealEntity {
  MealModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.instructions,
    required super.from,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
        id: json['idMeal'] ?? '',
        name: json['strMeal'] ?? '',
        imageUrl: json['strMealThumb'] ?? '',
        instructions: json['strInstructions'] ?? '',
        from: json['strArea'] ?? '',
      );
}