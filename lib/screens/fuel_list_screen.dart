import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/new_consumption.dart';
import '../providers/fuels.dart';
import '../widgets/fuel_item.dart';

class FuelListScreen extends StatelessWidget {
  String gasStationId;

  FuelListScreen({Key? key, required this.gasStationId}) : super(key: key);

  Future<void> _refreshItems(BuildContext ctx) async {
    return Future.delayed(Duration.zero, () async {
      return await Provider.of<Fuels>(ctx, listen: false)
          .fetchFuelsForStation(gasStationId);
    });
  }

  void _addNewConsumption(BuildContext ctx) {
    final fuel = Provider.of<Fuels>(ctx, listen: false).getSelectedFuel();
    if (fuel != null) {
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              40,
            ),
          ),
        ),
        barrierColor: Colors.black54.withOpacity(0.75),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: ChangeNotifierProvider.value(
              value: fuel,
              child: NewConsumption(
                fuelId: fuel.id,
              ),
            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        },
      );
    } else {
      showDialog(
        context: ctx,
        builder: (contx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                40,
              ),
            ),
            backgroundColor: Theme.of(contx).primaryColor,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(contx).pop();
                },
                child: Text(
                  'OK',
                  style: Theme.of(contx).textTheme.headline6,
                ),
              ),
            ],
            title: Text(
              'Error!',
              style: Theme.of(contx).textTheme.headline6,
            ),
            content: Text(
              'Please, select a fuel!',
              style: Theme.of(contx).textTheme.headline6,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _refreshItems(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: Consumer<Fuels>(
                builder: (cts, fuels, _) => Container(
                    padding: const EdgeInsets.only(
                      top: 3.0,
                    ),
                  child: ListView.builder(
                    itemBuilder: ((ctx, index) =>
                        ChangeNotifierProvider.value(
                          value: fuels.items[index],
                          child: FuelItem(
                            key: ValueKey(
                              fuels.items[index].id,
                            ),
                            fuelId: fuels.items[index].id,
                          ),
                        )),
                    itemCount: fuels.items.length,
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewConsumption(context),
        child: const Icon(
          Icons.local_gas_station,
        ),
      ),
    );
  }
}
