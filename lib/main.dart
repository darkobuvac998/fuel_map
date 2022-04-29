import 'package:flutter/material.dart';
import 'package:fuel_map/providers/fuels.dart';
import './screens/gas_station_detail_screen.dart';
import './providers/gas_stations.dart';
import './screens/gas_stations_screen.dart';
import 'package:provider/provider.dart';

import 'providers/consumptions.dart';
import 'screens/consumption_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => GasStations(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Fuels(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Consumptions(),
        )
      ],
      child: MaterialApp(
        title: 'FuelMap',
        theme: ThemeData(
          canvasColor: const Color(0xfff6f7f1),
          primaryColor: const Color(0xfffdba25),
          cardColor: const Color(0xfffdba25),
          fontFamily: 'Lato',
          scaffoldBackgroundColor: const Color(0xfffefeff),
          primaryIconTheme: const IconThemeData(
            color: Color(0xffe6341c),
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: const TextStyle(
                  color: Color(0xffffe79f),
                ),
                bodyText2: const TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                headline6: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5b595a),
                ),
                headline5: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5a5a5c),
                ),
              ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xffe6341c),
            primary: const Color(0xfffdba25),
          ),
        ),
        home: GasStationsScreen(),
        routes: {
          GasStationsScreen.routeName: (ctx) => GasStationsScreen(),
          GasStationDetailScreen.routeName: (ctx) =>
              const GasStationDetailScreen(),
          ConsumptionScreen.routeName: (ctx) => const ConsumptionScreen(),
        },
      ),
    );
  }
}
