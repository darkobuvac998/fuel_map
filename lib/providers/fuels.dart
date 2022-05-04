import 'package:flutter/material.dart';
import 'package:fuel_map/models/shared_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'fuel.dart';
import '../screens/gas_station_detail_screen.dart' show SortByPrices;

class Fuels with ChangeNotifier {
  List<Fuel> _items = [];
  SortByPrices _sortBy = SortByPrices.ascending;

  List<Fuel> get items {
    return [..._items];
  }

  String? authToken;

  Fuels(this._items, {this.authToken});

  Future<void> fetchFuelsForStation(String stationId) async {
    var url = Uri.parse(
        '${Urls.fuels}?auth=$authToken&orderBy="gasStationId"&equalTo="$stationId"');

    try {
      _items = [];
      notifyListeners();
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Fuel> loadedItems = [];

      extractedData.forEach((id, data) {
        var temp = data as Map<String, dynamic>;
        temp.addAll({'id': id});
        loadedItems.add(Fuel.fromMap(temp));
      });

      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Fuel getFuelById(String fuelId) {
    return _items.firstWhere((element) => element.id == fuelId);
  }

  void sortItems(SortByPrices sortBy) {
    if (sortBy == SortByPrices.ascending) {
      _items.sort(
        (a, b) => b.price.compareTo(a.price),
      );
      notifyListeners();
    } else {
      _items.sort(
        (a, b) => a.price.compareTo(b.price),
      );
      notifyListeners();
    }
  }

  onItemSelect(String id) {
    _items.forEach((element) {
      if (element.id != id && element.selected) {
        element.onSelect();
        return;
      }
    });
  }

  Fuel? getSelectedFuel() {
    var result = _items.indexWhere((element) => element.selected == true);
    if (result >= 0) {
      return _items.firstWhere((element) => element.selected == true);
    }
    return null;
  }
}
