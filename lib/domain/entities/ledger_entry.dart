enum EntryType { income, expense }

class LedgerEntry {
  const LedgerEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.amount,
    required this.date,
    this.note = '',
  });

  final String id;
  final String title;
  final String category;
  final EntryType type;
  final double amount;
  final DateTime date;
  final String note;

  bool get isIncome => type == EntryType.income;

  LedgerEntry copyWith({
    String? id,
    String? title,
    String? category,
    EntryType? type,
    double? amount,
    DateTime? date,
    String? note,
  }) {
    return LedgerEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'type': type.name,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory LedgerEntry.fromJson(Map<String, Object?> json) {
    return LedgerEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      type: EntryType.values.byName(json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String? ?? '',
    );
  }
}
