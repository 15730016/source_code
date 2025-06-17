import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:active_ecommerce_cms_demo_app/features/home/screens/home_screen.dart';
import 'package:active_ecommerce_cms_demo_app/features/auth/screens/login_screen.dart';
import 'package:active_ecommerce_cms_demo_app/features/auth/screens/register_screen.dart';
import 'package:active_ecommerce_cms_demo_app/features/profile/screens/profile_screen.dart';
import 'package:active_ecommerce_cms_demo_app/features/cart/screens/cart_screen.dart';
import 'package:active_ecommerce_cms_demo_app/features/categories/screens/categories_screen.dart';
import 'package:active_ecommerce_cms_demo_app/features/flash_deal/screens/flash_deal_screen.dart';
import 'package:active_ecommerce_cms_demo_app/features/brands/screens/brands_screen.dart';
import 'package:active_ecommerce_cms_demo_app/features/refund/screens/refund_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/flash-deals',
        name: 'flash-deals',
        builder: (context, state) => const FlashDealScreen(),
      ),
      GoRoute(
        path: '/brands',
        name: 'brands',
        builder: (context, state) => const BrandsScreen(),
      ),
      GoRoute(
        path: '/refund',
        name: 'refund',
        builder: (context, state) => const RefundScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
