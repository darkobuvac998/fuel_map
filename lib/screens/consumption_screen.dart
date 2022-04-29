import 'package:flutter/material.dart';
import 'package:fuel_map/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../providers/consumptions.dart';
import '../widgets/app_drawer.dart';
import '../screens/consumption_overview_screen.dart';
import '../screens/consumption_list_screen.dart';

class ConsumptionScreen extends StatefulWidget {
  static const routeName = '/consumption';

  const ConsumptionScreen({Key? key}) : super(key: key);

  @override
  State<ConsumptionScreen> createState() => _ConsumptionScreenState();
}

class _ConsumptionScreenState extends State<ConsumptionScreen> {
  final List<Widget> _screens = const [
    ConsumptionListScreen(),
    ConsumptionOverviewScreen()
  ];
  int _selectedScreen = 0;
  bool _init = false;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Consumptions',
      ),
      drawer: const AppDrawer(),
      body: _screens[_selectedScreen],
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedScreen,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.pie_chart_rounded,
              ),
              label: 'Costs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Overview',
            )
          ],
          onTap: _selectScreen,
        ),
      ),
    );
  }
}
