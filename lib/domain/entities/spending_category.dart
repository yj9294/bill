import 'ledger_entry.dart';

class SpendingCategory {
  const SpendingCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.monthlyLimit,
    this.type = EntryType.expense,
  });

  final String name;
  final String icon;
  final int color;
  final double monthlyLimit;
  final EntryType type;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'icon': icon,
      'color': color,
      'monthlyLimit': monthlyLimit,
      'type': type.name,
    };
  }

  factory SpendingCategory.fromJson(Map<String, Object?> json) {
    final typeName = json['type'] as String?;
    return SpendingCategory(
      name: json['name'] as String,
      icon: _canonicalizeIcon(
        json['icon'] as String,
        categoryName: json['name'] as String,
      ),
      color: json['color'] as int,
      monthlyLimit: (json['monthlyLimit'] as num).toDouble(),
      type: EntryType.values.firstWhere(
        (value) => value.name == typeName,
        orElse: () => (json['name'] as String) == 'Salary'
            ? EntryType.income
            : EntryType.expense,
      ),
    );
  }

  static String _canonicalizeIcon(String raw, {String? categoryName}) {
    final knownKey = switch (raw) {
      'food' => 'food',
      'transport' => 'transport',
      'shopping' => 'shopping',
      'bills' => 'bills',
      'health' => 'health',
      'salary' => 'salary',
      'coffee' => 'coffee',
      'home' => 'home',
      'gift' => 'gift',
      'work' => 'work',
      'wallet' => 'wallet',
      'fun' => 'fun',
      _ => null,
    };
    if (knownKey != null) {
      return knownKey;
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
      'coffee' => 'coffee',
      'home' => 'home',
      'gift' => 'gift',
      'work' => 'work',
      'wallet' => 'wallet',
      'fun' => 'fun',
      _ => 'wallet',
    };
  }
}
