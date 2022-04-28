import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/consumptions.dart';
import '../providers/gas_stations.dart';
import '../widgets/custom_card.dart';

class ConsumptionItem extends StatelessWidget {
  final String consumptionId;
  const ConsumptionItem({required this.consumptionId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consumption =
        Provider.of<Consumptions>(context).getConsumptionById(consumptionId);
    final gasStation = Provider.of<GasStations>(context)
        .findById(consumption?.fuel.gasStationId as String);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      child: CustomCard(
        child: Container(
          padding: const EdgeInsets.all(
            3,
          ),
          decoration: BoxDecoration(
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(
              40,
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 40,
              backgroundImage: NetworkImage(
                gasStation.logoUrl,
              ),
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '${consumption?.amount} KM',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            subtitle: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '${consumption?.date}',
              ),
            ),
            trailing: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Container(
                width: 100,
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${consumption?.total} L',
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${consumption?.fuel.name}',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
