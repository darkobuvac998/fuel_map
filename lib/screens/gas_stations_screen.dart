import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/gas_stations.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/gas_station_item.dart';

enum FilterOptions { favorites, all }

class GasStationsScreen extends StatelessWidget {
  static const routeName = '/gas-stations';

  GasStationsScreen({Key? key}) : super(key: key);

  Future<void> _refreshGasStations(BuildContext ctx) {
    return Future.delayed(Duration.zero, () async {
      return await Provider.of<GasStations>(ctx, listen: false)
          .fetchGasStations();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final gasStations = Provider.of<GasStations>(context).items;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gas Stations',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
            ),
          ),
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
            onSelected: (FilterOptions selected) {},
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
                        value: gasStations.items[i],
                        child: GasStationItem(
                          key: ValueKey(
                            gasStations.items[i].id,
                          ),
                        ),
                      );
                      ;
                    },
                    itemCount: gasStations.items.length,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
