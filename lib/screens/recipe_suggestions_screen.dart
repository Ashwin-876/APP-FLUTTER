import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/recipe_provider.dart';
import '../models/recipe.dart';

class RecipeSuggestionsScreen extends StatefulWidget {
  const RecipeSuggestionsScreen({super.key});

  @override
  State<RecipeSuggestionsScreen> createState() =>
      _RecipeSuggestionsScreenState();
}

class _RecipeSuggestionsScreenState extends State<RecipeSuggestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header & Search
            Container(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recipes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.2),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDCBMGKiyi4K10PElyYV1n0AYeD-ZReVUZuNV8UKtIDbDj6LE43XCaJOVXx8mY5vsQpX4LFAcLMjQXvGkOrVslrfpxA9oBnw3c0ue2p7xopPx1RJwjAm22i9GEwu7x-7lRth3KLxAL9mTKE-DUYjU81MxVpe5a5QsyiQDYVeCAgrgu4P9oulzWjA_bEwtJOPhSHPGN2m1TM9a-P8rslq9yyWFK3a-6v8fRPstNW0I1BP0ZtcBg0J1Imy_GjFubg_n3P5xakSuO99nii',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              context.read<RecipeProvider>().setSearchQuery(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search for fresh recipes...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.tune, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dietary Filters
                  Consumer<RecipeProvider>(
                    builder: (context, recipeProvider, child) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('Vegan', recipeProvider),
                            _buildFilterChip('Gluten-free', recipeProvider),
                            _buildFilterChip('Keto', recipeProvider),
                            _buildFilterChip('High-protein', recipeProvider),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Scalable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Featured Carousel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Featured Weekly',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 240,
                      child: Consumer<RecipeProvider>(
                        builder: (context, recipeProvider, child) {
                          final allRecipes = recipeProvider.recipes;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: allRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = allRecipes[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index == allRecipes.length - 1
                                      ? 0
                                      : 16.0,
                                ),
                                child: _buildFeaturedCard(
                                  context,
                                  recipe,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // AI Ingredients Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'With Your Ingredients',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                              ),
                            ),
                            child: Consumer2<InventoryProvider, RecipeProvider>(
                              builder: (context, inventory, recipeProvider, child) {
                                // Get all recipes and calculate their match percentage
                                final recipesWithMatch = recipeProvider.recipes
                                    .map((recipe) {
                                      final matchPct = recipeProvider
                                          .calculateMatchPercentage(
                                            recipe,
                                            inventory,
                                          );
                                      // Find missing items
                                      final pantryNames = inventory.items
                                          .map((e) => e.name.toLowerCase())
                                          .toList();
                                      final missing = recipe.requiredIngredients
                                          .where(
                                            (req) => !pantryNames.any(
                                              (p) =>
                                                  p.contains(req.toLowerCase()),
                                            ),
                                          )
                                          .toList();
                                      return {
                                        'recipe': recipe,
                                        'matchPct': matchPct,
                                        'missing': missing,
                                      };
                                    })
                                    .toList();

                                // Sort by highest match first
                                recipesWithMatch.sort(
                                  (a, b) => (b['matchPct'] as double).compareTo(
                                    a['matchPct'] as double,
                                  ),
                                );

                                // Take top 3 for UI
                                final topMatches = recipesWithMatch
                                    .take(3)
                                    .toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Based on the ${inventory.items.length} items in your pantry:',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...topMatches.map((match) {
                                      final recipe = match['recipe'] as Recipe;
                                      final missing =
                                          match['missing'] as List<String>;
                                      final missingText = missing.isEmpty
                                          ? 'Missing: 0 ingredients'
                                          : 'Missing: ${missing.length} ingredient(s) (${missing.take(2).join(", ")}${missing.length > 2 ? "..." : ""})';

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16.0,
                                        ),
                                        child: _buildAIItem(
                                          context,
                                          recipe,
                                          missingText,
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Categories Grid
                    const Text(
                      'Browse Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2,
                      children: [
                        _buildCategoryGridItem(
                          'Breakfast',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDNtT7ORiCsSL-pOmzm7jV0VtfXG4uvfUHNvkMma2Sv2Y9sTsBKJHe7j9Yy4ENm3mS6TsUwnByxlsRyn-tGgz-Zv4DOJ4IfXeigMarp0ctpDRPPq3Se2bGKyWo_xhATl-sbQK21HMd8ULbjdBTOqKM6Ass4DO-xW0fyk5veZvmIhixRr-xVMtaayXuC2RwFsfO7nOk67Tv2Mni_TFS48v6g4KUgDHVxAWFr-D22EpqvsVOA5sKsWRZfor2OTmWumarUacvLSfW8zYWg',
                        ),
                        _buildCategoryGridItem(
                          'Lunch',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDxUND3d8PCQpAk9lA0TNu8nzZlkRX32YawJ1fptyDS7PCni4KYbXW7rkR96ar2PiGKSz9Vd4uS19VWincserJoLpk6tz6KWLXhX8rqJTJ5ZyPTYRWilrxaMORcgAakEvtaepYrJNTBoAgQ2eFMS0Qhq-Hh484Z3w9xPj0abhStDziquPG_dBEkDPmWDdULJB7dyNTm-KY6LG3K0p8L6P5TcPZrQkJ_QweuOV2U2-EY-ZAK_9jPZ6uev5OPj8GsgdfE9UEjhpj0UzGj',
                        ),
                        _buildCategoryGridItem(
                          'Dinner',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDcJXekZEz0zrEqPM-29qFd7NnaHk0ESSJBNyv_l0qtfqnslIw1P_6QlhSt2eC4Yu6ihciI3Ldjaf8wQ5C6-Ib1k979V6Xww0v9z4IEZyugR-eD6SiIovrp3RrrBMXeBANvBeD0XW7xuZUQ6vJ1ZanhjMaPe8CkyPYyFmomwAr9WY1LsP9Vl0fE2CWTvKilbZxv3-DlqruyuNniqpciv2qjPE5OlVMfrBNDgtjv4ts4KPbTMy9EGgf43TGHgHmkKuOfK8R4eLHS1lFx',
                        ),
                        _buildCategoryGridItem(
                          'Snacks',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAC7fGmvYxQVmiMYtjppvx54xhCHY0JuEID5AxMB2QP4_QZOCv1YX207fcnOhOA_9AWmkFIMwx7STuV_PXWf3ZVol7FFqgHyEIT57A-wvC5P87xXH5tp14cL5ETrb8TJJ9PUUTWI3uJh4Y43ekjBCJiHfjEt8PoHk0cRwHW7eNev5diZZi4P6wyB7BaWRx6EZX3388NvV_djB3axBerlRltNgRPRWPLKVsdSRfHLugKnm5Ql-f3PdmOuNljwjCnmms2b9X_QiRxHvLf',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Favorites Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Favorites',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'View All',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildFavoriteItem(
                            'Pasta Primavera',
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDpRbFlLJBlmKrZa2hEl1OlxzWHzonoC4kXl1D59mkJ7E0TVRgNFX_X9IHXDmyqYV9OPgXYOaJgekE2qNiq2R92g2UY0Lxxo1L9zaKhRlSTHgYuWM7O1zVxUHvOXIVG_Jv_9md3J5h5I6jVJ55nomeg0NAEMXnyDcqtgTVythX0y9bsoNw8bCSnx_d1sjKIrt13ZQ-BOibDO_365D9G1yhOH76A9ov5BlFGM7QIRrEH0oaHNFbM1fHvfnhYviJHqeXxFDCm3ZeX_Qci',
                          ),
                          const SizedBox(width: 16),
                          _buildFavoriteItem(
                            'Classic Hotcakes',
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuC_cV1IZrVaArbUOyqMFAxAe46iY29LztsXMYiUU8a5dc5mRuOz5lxX_JlxRpo3R_v3rNGrSQi3AJs3evzRPdRQALHmA26EQ4RRIlgXaAllNb9iX00W_PkwxIkrfvVBxfUf4aJazakZK055EJ1nCTn4keHop1zOiRmqKA05uulNI5nxNbTwS_46JykGwCSTkmCTsZI5X91zblHiLHtDyKhkBXv0D3_SUGk7mi452pZpNj4YlWzwtqCbpCQ86g8y2WDuAdzJGD5K6rNW',
                          ),
                          const SizedBox(width: 16),
                          _buildFavoriteItem(
                            'Berry Greek Bowl',
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAbUNtNm_BOP5kSLvUTu5x89Pc7zpBgLlzZ4C-SVWEYOsPiYLdpE2_hQ7rF0oi7Bk7lLkQ-l-HnAWyFbsTIx8ZoLs_V9QJ8GKhlEK4GWuowGcohBc5KCTv5gXvqMwNGHzZVKF4nki9tJl2MbTEmPTHXcO_0-_1GiofeCjoRhWvzYGdCWpc4b7iC1q1nekS2-thOaS1WRwLjFo9NdWixl2Aj6nCtPuF43HC7nqBlMfb85-o03oUaqiAkfmFQgEAMOpHfBZJeJroL731X',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, RecipeProvider provider) {
    final isSelected = provider.selectedFilters.contains(label);
    
    return GestureDetector(
      onTap: () {
        provider.toggleFilter(label);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Theme.of(context).primaryColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ]
          ],
        ),
      ),
    );
  }
  Widget _buildFeaturedCard(
    BuildContext context,
    Recipe recipe,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          '/recipe_detail',
          arguments: recipe,
        );
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(recipe.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    recipe.tags.isNotEmpty ? recipe.tags.first.toUpperCase() : 'FEATURED',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.prepTimeMinutes} min',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recipe.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  '4.8 (new)', // Mock rating
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildAIItem(
    BuildContext context,
    Recipe recipe,
    String missing,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          '/recipe_detail',
          arguments: recipe,
        );
      },
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(recipe.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  missing,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      (recipe.tags.isNotEmpty ? recipe.tags.first : 'Beginner').toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${recipe.prepTimeMinutes} MIN',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/recipe_detail',
                arguments: recipe,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGridItem(String title, String imageUrl) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print('Recipes: Clicked Category - $title');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.4),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildFavoriteItem(String title, String imageUrl) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print('Recipes: Clicked Favorite - $title');
      },
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.red, size: 18),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      ),
    );
  }
}
