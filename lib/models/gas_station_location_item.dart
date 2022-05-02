import 'dart:convert';

class GasStationLocationItemModel {
  final String id;
  final String city;
  final String address;
  final String gasStationId;

  GasStationLocationItemModel({
    required this.id,
    required this.city,
    required this.address,
    required this.gasStationId,
  });

  GasStationLocationItemModel copyWith({
    String? id,
    String? city,
    String? address,
    String? gasStationId,
  }) {
    return GasStationLocationItemModel(
      id: id ?? this.id,
      city: city ?? this.city,
      address: address ?? this.address,
      gasStationId: gasStationId ?? this.gasStationId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'city': city});
    result.addAll({'address': address});
    result.addAll({'gasStationId': gasStationId});

    return result;
  }

  factory GasStationLocationItemModel.fromMap(Map<String, dynamic> map) {
    return GasStationLocationItemModel(
      id: map['id'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      gasStationId: map['gasStationId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GasStationLocationItemModel.fromJson(String source) =>
      GasStationLocationItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GasStationLocationItemModel(id: $id, city: $city, address: $address, gasStationId: $gasStationId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GasStationLocationItemModel &&
        other.id == id &&
        other.city == city &&
        other.address == address &&
        other.gasStationId == gasStationId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        city.hashCode ^
        address.hashCode ^
        gasStationId.hashCode;
  }
}
