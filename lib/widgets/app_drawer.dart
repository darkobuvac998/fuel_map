import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../screens/consumption_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1,
      // backgroundColor: const Color(0xffeece6a),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              // padding: EdgeInsets.zero,
              child: Text(
                '',
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/app_drawer_header_background.jpeg'),
                  fit: BoxFit.cover,
                ),
                color: Color(0xfff7b429),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.local_gas_station,
                    size: 24,
                  ),
                  title: Text(
                    'Gas Stations',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                const Divider(),
                // // ListTile(
                // //   leading: const Icon(Icons.car_repair, size: 24),
                // //   title: Text(
                // //     'Cars',
                // //     style: Theme.of(context).textTheme.headline4,
                // //   ),
                // //   onTap: () {},
                // // ),
                // // const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.money_outlined,
                    size: 24,
                  ),
                  title: Text(
                    'Consumptions',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ConsumptionScreen.routeName);
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              size: 24,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.headline4,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
