import 'package:flutter/material.dart';
import 'package:fuel_map/providers/fuel.dart';
import 'package:fuel_map/providers/fuels.dart';
import 'package:fuel_map/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../providers/gas_stations.dart';
import '../widgets/sort_prices_popupmenubutton.dart';
import 'fuel_list_screen.dart';
import '../screens/gas_station_locations_screen.dart';

enum SortByPrices {
  ascending,
  descending,
}

class GasStationDetailScreen extends StatefulWidget {
  const GasStationDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/gas-station-detail';

  @override
  State<GasStationDetailScreen> createState() => _GasStationDetailScreenState();
}

class _GasStationDetailScreenState extends State<GasStationDetailScreen> {
  List<Widget> _screens = [];

  int _selectedScreen = 0;
  bool _isInit = true;
  SortByPrices _sortBy = SortByPrices.ascending;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final gasStationId = ModalRoute.of(context)?.settings.arguments as String;
      _screens = [
        FuelListScreen(
          gasStationId: gasStationId,
        ),
        GasStationLocationsScreen(stationId: gasStationId),
      ];
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  void _changeSorting() {
    if (_sortBy == SortByPrices.ascending) {
      setState(() {
        _sortBy = SortByPrices.descending;
        Provider.of<Fuels>(context, listen: false).sortItems(_sortBy);
      });
    } else {
      setState(() {
        _sortBy = SortByPrices.ascending;
        Provider.of<Fuels>(context, listen: false).sortItems(_sortBy);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gasStationId = ModalRoute.of(context)?.settings.arguments as String;
    final gasStation =
        Provider.of<GasStations>(context, listen: false).findById(gasStationId);
    return Scaffold(
      appBar: CustomAppBar(
        title: gasStation.title,
        actions: [
          if (_selectedScreen == 0)
            SortByPricesPopupMenuButton(
              sortby: _sortBy,
              changeSorting: () => _changeSorting(),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
        ),
        child: _screens[_selectedScreen],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xfff8be32),
              Color(0xffea5e29),
            ],
          ),
        ),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          currentIndex: _selectedScreen,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.water_drop),
              label: 'Pricess',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Stations',
            ),
          ],
          onTap: _selectScreen,
        ),
      ),
    );
  }
}
