import 'package:flutter/material.dart';

class CategoryIconOption {
  const CategoryIconOption({
    required this.key,
    required this.label,
    required this.icon,
  });

  final String key;
  final String label;
  final IconData icon;
}

abstract final class CategoryIconCatalog {
  static const List<CategoryIconOption> options = [
    CategoryIconOption(
      key: 'food',
      label: 'Food',
      icon: Icons.restaurant_rounded,
    ),
    CategoryIconOption(
      key: 'transport',
      label: 'Transport',
      icon: Icons.directions_bus_rounded,
    ),
    CategoryIconOption(
      key: 'shopping',
      label: 'Shopping',
      icon: Icons.shopping_bag_rounded,
    ),
    CategoryIconOption(
      key: 'bills',
      label: 'Bills',
      icon: Icons.receipt_long_rounded,
    ),
    CategoryIconOption(
      key: 'health',
      label: 'Health',
      icon: Icons.favorite_rounded,
    ),
    CategoryIconOption(
      key: 'salary',
      label: 'Salary',
      icon: Icons.payments_rounded,
    ),
    CategoryIconOption(
      key: 'coffee',
      label: 'Coffee',
      icon: Icons.local_cafe_rounded,
    ),
    CategoryIconOption(key: 'home', label: 'Home', icon: Icons.home_rounded),
    CategoryIconOption(
      key: 'gift',
      label: 'Gift',
      icon: Icons.celebration_rounded,
    ),
    CategoryIconOption(key: 'work', label: 'Work', icon: Icons.work_rounded),
    CategoryIconOption(
      key: 'wallet',
      label: 'Wallet',
      icon: Icons.account_balance_wallet_rounded,
    ),
    CategoryIconOption(
      key: 'fun',
      label: 'Fun',
      icon: Icons.sports_esports_rounded,
    ),
  ];

  static IconData resolve(String key) {
    return optionFor(key)?.icon ?? Icons.category_rounded;
  }

  static CategoryIconOption? optionFor(String key) {
    for (final option in options) {
      if (option.key == key) {
        return option;
      }
    }
    return null;
  }

  static String canonicalize(String raw, {String? categoryName}) {
    if (optionFor(raw) != null) {
      return raw;
    }

    final legacyKey = switch (raw) {
      'Fo' => 'food',
      'Tr' => 'transport',
      'Sh' => 'shopping',
      'Bi' => 'bills',
      'He' => 'health',
      'Sa' => 'salary',
      _ => null,
    };
    if (legacyKey != null) {
      return legacyKey;
    }

    final normalizedName = categoryName?.trim().toLowerCase();
    return switch (normalizedName) {
      'food' => 'food',
      'transport' => 'transport',
      'shopping' => 'shopping',
      'bills' => 'bills',
      'health' => 'health',
      'salary' => 'salary',
      _ => 'wallet',
    };
  }
}
