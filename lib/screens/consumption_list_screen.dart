import 'package:flutter/material.dart';
import 'package:fuel_map/widgets/month_consumption.dart';
import 'package:provider/provider.dart';

import '../widgets/consumption_item.dart';
import '../providers/consumptions.dart';
import '../widgets/no_data_found.dart';
import '../models/consumption_item.dart' as citem;

class ConsumptionListScreen extends StatelessWidget {
  const ConsumptionListScreen({Key? key}) : super(key: key);

  Future<void> _refresItems(BuildContext ctx) async {
    return Future.delayed(Duration.zero, () async {
      return await Provider.of<Consumptions>(ctx, listen: false)
          .fetchConsumption();
    });
  }

  Widget animatedList(BuildContext ctx, List<citem.ConsumptionItem> items) {
    return AnimatedList(
      initialItemCount: items.length,
      itemBuilder: (contx, index, animation) => SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(-1, 0),
            end: const Offset(0, 0),
          ),
        ),
        child: ConsumptionItem(
          consumptionId: items[index].id,
        ),
      ),
    );
  }

  Widget _itemList(BuildContext ctx, List<citem.ConsumptionItem> items) {
    return ListView.builder(
      itemBuilder: (context, index) => ConsumptionItem(
        consumptionId: items[index].id,
      ),
      itemCount: items.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: FutureBuilder(
          future: _refresItems(context),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Icon(Icons.broken_image),
              );
            }
            return Padding(
              padding: mediaQuery.orientation == Orientation.landscape
                  ? EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * 0.1)
                  : const EdgeInsets.all(
                      0,
                    ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MonthConsumption(),
                  Divider(
                    indent: 30,
                    endIndent: 30,
                    color: Theme.of(context).primaryColor,
                    height: 20,
                    thickness: 2,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      child: Consumer<Consumptions>(
                        builder: (context, consumptions, child) => consumptions
                                .filteredItems.isNotEmpty
                            ? _itemList(context, consumptions.filteredItems)
                            : const NoDataFound(),
                      ),
                      onRefresh: () => _refresItems(context),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
