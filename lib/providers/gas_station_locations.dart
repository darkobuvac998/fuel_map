import 'package:flutter/material.dart';
import 'package:fuel_map/models/shared_data.dart';
import '../models/gas_station_location_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GasStationLocations with ChangeNotifier {
  List<GasStationLocationItemModel> _items = [];

  List<GasStationLocationItemModel> get items {
    return [..._items];
  }

  String? authToken;

  GasStationLocations(
    this._items, {
    this.authToken,
  });

  Future<void> fetchData(String gasStationId) async {
    var url = Uri.parse(
        '${Urls.gasStationLocations}.json?auth=$authToken&orderBy="gasStationId"&equalTo="$gasStationId"');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      print(extractedData);
      if (extractedData == null) {
        return;
      }

      List<GasStationLocationItemModel> loadedData = [];
      extractedData.forEach((id, data) {
        var temp = data as Map<String, dynamic>;
        temp.addAll({'id': id});
        loadedData.add(GasStationLocationItemModel.fromMap(temp));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
