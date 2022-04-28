import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/shared_data.dart';

class GasStation with ChangeNotifier {
  final String id;
  final String title;
  final String logoUrl;
  final int officesNumber;
  Color backgroundColor;
  bool isFavorite;

  GasStation(
      {required this.id,
      required this.title,
      required this.logoUrl,
      required this.officesNumber,
      this.backgroundColor = Colors.amberAccent,
      this.isFavorite = false});

  Future<void> updateFavoriteStatus() async {
    var url = Uri.parse(Urls.gasStations);

    bool? oldStatus = isFavorite;
    isFavorite = !isFavorite;

    var data = toMap();
    final response = await http.put(url, body: json.encode(data));

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      throw Exception('Could not update the favorite status');
    }

    oldStatus = null;

    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'logoUrl': logoUrl});
    result.addAll({'officesNumber': officesNumber});
    result.addAll({'isFavorite': isFavorite});

    return result;
  }

  factory GasStation.fromMap(Map<String, dynamic> map) {
    return GasStation(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      officesNumber: map['officesNumber']?.toInt() ?? 0,
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory GasStation.fromJson(String source) =>
      GasStation.fromMap(json.decode(source));
}
