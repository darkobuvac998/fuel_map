import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/gas_stations.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/gas_station_item.dart';

enum FilterOptions { favorites, all }

class GasStationsScreen extends StatefulWidget {
  static const routeName = '/gas-stations';

  const GasStationsScreen({Key? key}) : super(key: key);

  @override
  State<GasStationsScreen> createState() => _GasStationsScreenState();
}

class _GasStationsScreenState extends State<GasStationsScreen> {
  FilterOptions _filterOptions = FilterOptions.all;

  Future<void> _refreshGasStations(BuildContext ctx) {
    return Future.delayed(Duration.zero, () async {
      return await Provider.of<GasStations>(ctx, listen: false)
          .fetchGasStations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gas Stations',
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorites',
                  style: Theme.of(context).textTheme.headline6,
                ),
                value: FilterOptions.favorites,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                  style: Theme.of(context).textTheme.headline6,
                ),
                value: FilterOptions.all,
              ),
            ],
            onSelected: (FilterOptions selected) {
              setState(() {
                _filterOptions = selected;
              });
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: _refreshGasStations(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
              onRefresh: () => _refreshGasStations(context),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Consumer<GasStations>(
                  builder: (context, gasStations, _) => ListView.builder(
                    itemBuilder: (ctx, i) {
                      return ChangeNotifierProvider.value(
                        value: _filterOptions == FilterOptions.all
                            ? gasStations.items[i]
                            : gasStations.favorites[i],
                        child: GasStationItem(
                          key: ValueKey(
                            _filterOptions == FilterOptions.all
                                ? gasStations.items[i]
                                : gasStations.favorites[i],
                          ),
                        ),
                      );
                      ;
                    },
                    itemCount: _filterOptions == FilterOptions.all
                        ? gasStations.items.length
                        : gasStations.favorites.length,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
