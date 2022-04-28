import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/consumption_item.dart';
import '../providers/consumptions.dart';

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
            return RefreshIndicator(
              child: Consumer<Consumptions>(
                builder: (context, consumptions, child) => Container(
                  padding: const EdgeInsets.only(
                    top: 3.0,
                  ),
                  child: ListView.builder(
                    itemBuilder: (context, index) => ConsumptionItem(
                      consumptionId: consumptions.items[index].id,
                    ),
                    itemCount: consumptions.items.length,
                  ),
                ),
              ),
              onRefresh: () => _refresItems(context),
            );
          }),
    );
  }
}
