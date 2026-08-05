import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/cart/cart_page.dart';
import '../pages/favorites/favorites_page.dart';
import '../pages/home/home_page.dart';
import '../pages/home/product_detail_page.dart';
import '../pages/profile/profile_page.dart';
import 'app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
          ) {
        return AppShell(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) {
                return const HomePage();
              },
              routes: [
                GoRoute(
                  path: 'product/:productId',
                  name: 'productDetail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final productId = int.parse(
                      state.pathParameters['productId']!,
                    );

                    return ProductDetailPage(
                      productId: productId,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              name: 'favorites',
              builder: (context, state) {
                return const FavoritesPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              name: 'cart',
              builder: (context, state) {
                return const CartPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) {
                return const ProfilePage();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);