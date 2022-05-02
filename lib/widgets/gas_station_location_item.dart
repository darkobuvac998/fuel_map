import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../models/gas_station_location_item.dart'
    show GasStationLocationItemModel;

class GasStationLocationItem extends StatelessWidget {
  final GasStationLocationItemModel location;
  const GasStationLocationItem({required this.location, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
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
            title: Text(location.city),
            subtitle: Text(location.address),
          ),
        ),
      ),
    );
  }
}
