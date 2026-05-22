import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/search_categories_screen.dart';
import '../../features/home/search_results_screen.dart';
import '../../features/home/book_details_screen.dart';
import '../../features/order/order_screen.dart';
import '../../features/order/physical_book_details_screen.dart';
import '../../features/order/cart_checkout_screen.dart';
import '../../features/order/order_confirmation_screen.dart';
import '../../features/requests/requests_screen.dart';
import '../../features/requests/new_request_screen.dart';
import '../../features/requests/request_details_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/library/reader_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/order_history_screen.dart';
import '../../features/profile/account_settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(navigationShell: shell),
      branches: [
        // Home branch
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'search',
                builder: (_, __) => const SearchCategoriesScreen(),
                routes: [
                  GoRoute(
                    path: 'results',
                    builder: (_, state) => SearchResultsScreen(
                      query: state.uri.queryParameters['q'] ?? '',
                      category: state.uri.queryParameters['cat'],
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'book/:id',
                pageBuilder: (_, state) => _slide(
                  BookDetailsScreen(id: state.pathParameters['id']!),
                ),
              ),
            ],
          ),
        ]),
        // Order branch
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/order',
            builder: (_, __) => const OrderScreen(),
            routes: [
              GoRoute(
                path: 'book/:id',
                pageBuilder: (_, state) => _slide(
                  PhysicalBookDetailsScreen(
                      id: state.pathParameters['id']!),
                ),
              ),
              GoRoute(
                path: 'cart',
                pageBuilder: (_, __) =>
                    _slide(const CartCheckoutScreen()),
              ),
              GoRoute(
                path: 'confirmation/:id',
                pageBuilder: (_, state) => _slide(
                  OrderConfirmationScreen(
                      orderId: state.pathParameters['id']!),
                ),
              ),
            ],
          ),
        ]),
        // Requests branch
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/requests',
            builder: (_, __) => const RequestsScreen(),
            routes: [
              GoRoute(
                path: 'new',
                pageBuilder: (_, state) => _slide(
                  NewRequestScreen(
                      prefillTitle:
                          state.uri.queryParameters['title']),
                ),
              ),
              GoRoute(
                path: ':id',
                pageBuilder: (_, state) => _slide(
                  RequestDetailsScreen(
                      id: state.pathParameters['id']!),
                ),
              ),
            ],
          ),
        ]),
        // Library branch
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/library',
            builder: (_, __) => const LibraryScreen(),
            routes: [
              GoRoute(
                path: 'read/:id',
                pageBuilder: (_, state) => _slide(
                  ReaderScreen(id: state.pathParameters['id']!),
                ),
              ),
            ],
          ),
        ]),
        // Profile branch
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'orders',
                pageBuilder: (_, __) =>
                    _slide(const OrderHistoryScreen()),
              ),
              GoRoute(
                path: 'settings',
                pageBuilder: (_, __) =>
                    _slide(const AccountSettingsScreen()),
              ),
            ],
          ),
        ]),
      ],
    ),
  ],
);

CustomTransitionPage<void> _slide(Widget child) =>
    CustomTransitionPage<void>(
      child: child,
      transitionsBuilder: (_, animation, __, c) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
            parent: animation, curve: Curves.easeOutCubic)),
        child: c,
      ),
      transitionDuration: const Duration(milliseconds: 280),
    );
