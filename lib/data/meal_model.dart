import '../domain/meal_entity.dart';

class MealModel extends MealEntity {
  MealModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.instructions,
    required super.from,
    super.isFavorite,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
        id: json['idMeal'] ?? '',
        name: json['strMeal'] ?? '',
        imageUrl: json['strMealThumb'] ?? '',
        instructions: json['strInstructions'] ?? '',
        from: json['strArea'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'idMeal': id,
        'strMeal': name,
        'strMealThumb': imageUrl,
        'strInstructions': instructions,
        'strArea': from,
      };
}