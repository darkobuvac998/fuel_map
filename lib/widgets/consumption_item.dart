import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
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
    return IntrinsicHeight(
      child: Stack(
        children: [
          Center(
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Theme.of(context).errorColor,
                borderRadius: BorderRadius.circular(
                  40,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    'REMOVE',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
              padding: const EdgeInsets.only(
                right: 20,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 6,
              ),
            ),
          ),
          Dismissible(
            confirmDismiss: (direction) => showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 20,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes'),
                      )
                    ],
                    title: const Text(
                      'Are you sure?',
                    ),
                    content: const Text(
                      'Dou you want to remove consumption?',
                    ),
                  );
                }),
            onDismissed: (direction) async {
              try {
                await Provider.of<Consumptions>(context, listen: false)
                    .deleteConsumption(consumptionId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Consumption deleted successfuly',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } on HttpException catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } catch (erorr) {
                var msg = 'An error occured';
                SnackBar(
                  content: Text(
                    msg,
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
            key: ValueKey(consumptionId),
            direction: DismissDirection.endToStart,
            child: Center(
              child: Container(
                // width: deviceSize.width * 0.95,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: CustomCard(
                  child: Container(
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
                                '${consumption?.fuel.name} (${consumption?.fuel.price})',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
