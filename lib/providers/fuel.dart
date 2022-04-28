import 'dart:convert';

import 'package:flutter/material.dart';

class Fuel with ChangeNotifier{
  final String id;
  final String name;
  final String gasStationId;
  final double price;
  bool selected = false;

  Fuel(
      {required this.id,
      required this.name,
      required this.gasStationId,
      required this.price});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'gasStationId': gasStationId});
    result.addAll({'price': price});

    return result;
  }

  factory Fuel.fromMap(Map<String, dynamic> map) {
    return Fuel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      gasStationId: map['gasStationId'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Fuel.fromJson(String source) => Fuel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Fuel(id: $id, name: $name, gasStationId: $gasStationId, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Fuel &&
        other.id == id &&
        other.name == name &&
        other.gasStationId == gasStationId &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ gasStationId.hashCode ^ price.hashCode;
  }

  onSelect(){
    selected = !selected;
    notifyListeners();
  }
}
