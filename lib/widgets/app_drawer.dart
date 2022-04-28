import 'package:flutter/material.dart';
import 'package:fuel_map/widgets/custom_appbar.dart';
import '../screens/consumption_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1,
      backgroundColor: const Color(0xffeece6a),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Text(
              'Fuel Map',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.start,
            ),
            decoration: const BoxDecoration(
              color: Color(0xfff7b429),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.local_gas_station,
              size: 30,
            ),
            title: Text(
              'Gas Stations',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.car_repair, size: 30),
            title: Text(
              'Cars',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.money_outlined,
              size: 30,
            ),
            title: Text(
              'Consumption',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ConsumptionScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              size: 30,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
