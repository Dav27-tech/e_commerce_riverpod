import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          indicatorColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_rounded),
              selectedIcon: Icon(Icons.home_rounded, color: Theme.of(context).colorScheme.primary),
              label: 'Accueil',
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_rounded),
              selectedIcon: Icon(Icons.favorite_rounded, color: Theme.of(context).colorScheme.primary),
              label: 'Favoris',
            ),
            NavigationDestination(
              icon: const Icon(Icons.shopping_bag_rounded),
              selectedIcon: Icon(Icons.shopping_bag_rounded, color: Theme.of(context).colorScheme.primary),
              label: 'Panier',
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: Theme.of(context).colorScheme.primary),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}