class MealEntity{
      final String id;
      final String name;
      final String imageUrl;
      final String instructions;
      final String from;
      final bool isFavorite;

      MealEntity({ required this.id,
                   required this.name,
                   required this.imageUrl,
                   required this.instructions,
                   required this.from,
                   this.isFavorite = false,
      });
}

