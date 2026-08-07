import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/sort_option.dart';
import '../../../providers/filter/filter_provider.dart';
import '../../widgets/product_card.dart';
import '../../../providers/product/product_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController =
  TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshProducts() async {
    await ref.refresh(productsProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchProvider);
    final selectedCategory = ref.watch(categoryProvider);
    final selectedSort = ref.watch(sortProvider);

    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(filteredProductsProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProducts,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _HomeHeader(
                    searchController: _searchController,
                    searchQuery: searchQuery,
                    onSearchChanged: (value) {
                      ref.read(searchProvider.notifier).setSearch(value);
                    },
                    onClearSearch: () {
                      _searchController.clear();
                      ref.read(searchProvider.notifier).clear();
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: categoriesAsync.when(
                  loading: () => const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                  data: (categories) {
                    return SizedBox(
                      height: 46,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = category == selectedCategory;

                          return GestureDetector(
                            onTap: () {
                              ref.read(categoryProvider.notifier).setCategory(category);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.outlineVariant,
                                ),
                                boxShadow: isSelected
                                    ? [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _formatCategory(category),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Text(
                        'Découvrir',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      _SortButton(selectedSort: selectedSort),
                    ],
                  ),
                ),
              ),

              productsAsync.when(
                loading: () {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_off_outlined,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Impossible de charger les produits.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: _refreshProducts,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                data: (products) {
                  if (products.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'Aucun produit trouvé.',
                        ),
                      ),
                    );
                  }

                  return SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount =
                      constraints.crossAxisExtent >= 700
                          ? 4
                          : 2;

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          16,
                          20,
                          24,
                        ),
                        sliver: SliverGrid(
                          delegate:
                          SliverChildBuilderDelegate(
                                (context, index) {
                              final product = products[index];

                              return ProductCard(
                                product: product,
                                onTap: () {
                                  context.pushNamed(
                                    'productDetail',
                                    pathParameters: {
                                      'productId':
                                      product.id.toString(),
                                    },
                                  );
                                },
                              );
                            },
                            childCount: products.length,
                          ),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                            crossAxisCount == 2 ? 0.68 : 0.72,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCategory(String category) {
    if (category == 'All') {
      return 'Tous';
    }

    final formatted = category.replaceAll('-', ' ');

    return formatted[0].toUpperCase() +
        formatted.substring(1);
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bienvenue',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Trouvez les articles qui vous correspondent',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Rechercher un article...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: searchQuery.isEmpty
                ? null
                : IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: onClearSearch,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
              image: NetworkImage(
                'https://img.freepik.com/free-photo/arrangement-black-friday-shopping-carts-with-copy-space_23-2148667047.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.1),
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Nouvelle Collection',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Découvrez les tendances de la saison',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _SortButton extends ConsumerWidget {
  const _SortButton({required this.selectedSort});

  final SortOption selectedSort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<SortOption>(
      initialValue: selectedSort,
      onSelected: (option) {
        ref.read(sortProvider.notifier).setSort(option);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: SortOption.none,
          child: Text('Pertinence'),
        ),
        const PopupMenuItem(
          value: SortOption.priceAsc,
          child: Text('Prix croissant'),
        ),
        const PopupMenuItem(
          value: SortOption.priceDesc,
          child: Text('Prix décroissant'),
        ),
        const PopupMenuItem(
          value: SortOption.ratingDesc,
          child: Text('Meilleures notes'),
        ),
        const PopupMenuItem(
          value: SortOption.nameAsc,
          child: Text('Nom A → Z'),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.tune_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Trier',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
