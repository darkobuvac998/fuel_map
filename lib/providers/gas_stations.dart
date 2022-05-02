import 'package:flutter/material.dart';
import 'package:fuel_map/providers/gas_station.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/shared_data.dart' show Urls;

class GasStations with ChangeNotifier {
  List<GasStation> _items = [];

  List<GasStation> get items {
    return [..._items];
  }

  List<GasStation> get favorites {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  String? authToken;
  String? userId;

  GasStations(this._items, {this.authToken, this.userId});

  Future<void> fetchGasStations() async {
    var url = Uri.parse('${Urls.gasStations}?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;

      if (extractedData == null) {
        return;
      }
      final List<GasStation> loadedItems = [];

      var urlFavorites =
          Uri.parse('${Urls.userFavorites}/$userId.json?auth=$authToken');

      final favorites = await http.get(urlFavorites);
      final favoriteData = json.decode(favorites.body);

      extractedData.forEach((id, data) {
        var temp = data as Map<String, dynamic>;
        temp['isFavorite'] = favoriteData[id];
        temp.addAll({'id': id});
        loadedItems.add(GasStation.fromMap(temp));
      });

      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addGasStation() async {
    var url = Uri.parse(Urls.gasStations);
    try {
      var data = _items[1].toMap()..remove('id');

      final response = await http.post(url, body: json.encode(data));

      print(json.decode(response.body));

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  GasStation findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
