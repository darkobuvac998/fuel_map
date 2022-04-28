import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/fuel.dart';
import '../providers/fuels.dart';
import '../widgets/custom_card.dart';

class FuelItem extends StatelessWidget {
  final String fuelId;
  bool disableTap = false;
  FuelItem({required this.fuelId, this.disableTap = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fuel = Provider.of<Fuel>(context);
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
            color: !fuel.selected
                ? const Color(0xfff2f2f2)
                : const Color(0xfff8be32),
            borderRadius: BorderRadius.circular(
              40,
            ),
          ),
          child: ListTile(
              onTap: !disableTap
                  ? () {
                      fuel.onSelect();
                      Provider.of<Fuels>(context, listen: false)
                          .onItemSelect(fuel.id);
                    }
                  : null,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  fuel.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              trailing: FittedBox(
                child: Container(
                  padding: const EdgeInsets.all(
                    10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      40,
                    ),
                    color: Theme.of(context).canvasColor,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${fuel.price} KM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
