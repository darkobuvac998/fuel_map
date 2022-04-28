import 'dart:convert';

import '../providers/gas_station.dart';
import '../providers/fuel.dart';

class ConsumptionItem {
  final String id;
  final Fuel fuel;
  final double amount;
  final double total;
  final String date;

  ConsumptionItem(
      {required this.id,
      required this.fuel,
      required this.amount,
      required this.total,
      required this.date});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'fuel': fuel.toMap()});
    result.addAll({'amount': amount});
    result.addAll({'total': total});
    result.addAll({'date': date});

    return result;
  }

  factory ConsumptionItem.fromMap(Map<String, dynamic> map) {
    return ConsumptionItem(
      id: map['id'] ?? '',
      fuel: Fuel.fromMap(map['fuel']),
      amount: map['amount']?.toDouble() ?? 0.0,
      total: map['total']?.toDouble() ?? 0.0,
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsumptionItem.fromJson(String source) =>
      ConsumptionItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConsumptionItem(id: $id, fuel: $fuel, amount: $amount, total: $total, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConsumptionItem &&
        other.id == id &&
        other.fuel == fuel &&
        other.amount == amount &&
        other.total == total &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fuel.hashCode ^
        amount.hashCode ^
        total.hashCode ^
        date.hashCode;
  }
}
