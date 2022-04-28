import 'package:flutter/material.dart';
import 'package:fuel_map/providers/gas_station.dart';
import 'package:provider/provider.dart';

import '../screens/gas_station_detail_screen.dart';
import '../widgets/custom_card.dart';

class GasStationItem extends StatelessWidget {
  const GasStationItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gasStation = Provider.of<GasStation>(context, listen: false);
    var scaffold = Scaffold.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2,
      ),
      child: GestureDetector(
        onTap: () => {
          Navigator.of(context).pushNamed(
            GasStationDetailScreen.routeName,
            arguments: gasStation.id,
          )
        },
        child: CustomCard(
          child: Container(
            padding: const EdgeInsets.all(3),
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
                  gasStation.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              subtitle: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Locations number: ${gasStation.officesNumber}',
                ),
              ),
              trailing: Container(
                width: 100,
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Consumer<GasStation>(
                      builder: (ctx, item, child) => IconButton(
                        icon: Icon(
                          item.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () async {
                          // try {
                          //   await gasStation.updateFavoriteStatus();
                          // } catch (error) {
                          //   var tempError = error as Error;
                          //   scaffold.showSnackBar(
                          //     SnackBar(
                          //       content: Text(
                          //         error.toString(),
                          //       ),
                          //     ),
                          //   );
                          // }
                        },
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_right_sharp,
                    ),
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
