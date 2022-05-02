import 'package:flutter/material.dart';
import '../widgets/gas_station_location_item.dart';
import '../providers/gas_station_locations.dart';
import 'package:provider/provider.dart';

import '../widgets/no_data_found.dart';

class GasStationLocationsScreen extends StatelessWidget {
  final String stationId;
  const GasStationLocationsScreen({required this.stationId, Key? key})
      : super(key: key);

  Future<void> _refreshData(BuildContext ctx, String stationId) async {
    return Future.delayed(Duration.zero, () async {
      return await Provider.of<GasStationLocations>(ctx, listen: false)
          .fetchData(stationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refreshData(context, stationId),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          return Consumer<GasStationLocations>(
            builder: (ctx, locations, _) => locations.items.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (contx, index) => GasStationLocationItem(
                      location: locations.items[index],
                    ),
                    itemCount: locations.items.length,
                  )
                : const NoDataFound(),
          );
        }
      },
    );
  }
}
