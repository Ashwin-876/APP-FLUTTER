class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final int prepTimeMinutes;
  final List<String> requiredIngredients;
  final List<String> instructions;
  final List<String> tags; // e.g., 'Vegan', 'Keto'

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.prepTimeMinutes,
    required this.requiredIngredients,
    this.instructions = const [],
    this.tags = const [],
  });
}
