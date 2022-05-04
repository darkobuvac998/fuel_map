import 'package:flutter/material.dart';
import '../screens/gas_station_detail_screen.dart' show SortByPrices;

class SortByPricesPopupMenuButton extends StatelessWidget {
  final SortByPrices sortby;
  final VoidCallback changeSorting;
  const SortByPricesPopupMenuButton(
      {required this.sortby, required this.changeSorting, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.filter_alt_outlined,
      ),
      itemBuilder: (_) => [
        if (sortby == SortByPrices.descending)
          PopupMenuItem(
            child: Row(
              children: [
                Text(
                  'Ascending',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.arrow_downward,
                  color: Colors.black,
                )
              ],
            ),
            onTap: changeSorting,
          ),
        if (sortby == SortByPrices.ascending)
          PopupMenuItem(
            child: Row(
              children: [
                Text(
                  'Descending',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.arrow_upward,
                  color: Colors.black,
                )
              ],
            ),
            onTap: changeSorting,
          )
      ],
    );
  }
}
