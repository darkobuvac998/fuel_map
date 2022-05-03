import 'package:flutter/material.dart';
import 'package:fuel_map/widgets/month_consumption.dart';
import 'package:provider/provider.dart';

import '../widgets/consumption_item.dart';
import '../providers/consumptions.dart';
import '../widgets/no_data_found.dart';

class ConsumptionListScreen extends StatelessWidget {
  const ConsumptionListScreen({Key? key}) : super(key: key);

  Future<void> _refresItems(BuildContext ctx) async {
    return Future.delayed(Duration.zero, () async {
      return await Provider.of<Consumptions>(ctx, listen: false)
          .fetchConsumption();
    });
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
                            ? ListView.builder(
                                itemBuilder: (context, index) =>
                                    ConsumptionItem(
                                  consumptionId:
                                      consumptions.filteredItems[index].id,
                                ),
                                itemCount: consumptions.filteredItems.length,
                              )
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
