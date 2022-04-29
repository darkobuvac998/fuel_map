import 'package:flutter/material.dart';
import 'package:fuel_map/providers/consumptions.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_card.dart';

class MonthConsumption extends StatefulWidget {
  MonthConsumption({Key? key}) : super(key: key);

  @override
  State<MonthConsumption> createState() => _MonthConsumptionState();
}

class _MonthConsumptionState extends State<MonthConsumption> {
  DateTime initialDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  Map<String, dynamic> data = {};
  bool _init = true;

  @override
  void didChangeDependencies() {
    if (_init) {
      Future.delayed(Duration.zero, () async {
        return onDateChange(context);
      });
      _init = false;
    }
    super.didChangeDependencies();
  }

  void _showMonthPicker(BuildContext ctx) async {
    final DateTime? date = await showMonthPicker(
      context: ctx,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        initialDate = date;
        onDateChange(ctx);
      });
    } else {
      setState(() {
        selectedDate = DateTime.now();
      });
    }
  }

  void onDateChange(BuildContext ctx) async {
    Provider.of<Consumptions>(ctx, listen: false)
        .filterItmes(selectedDate.month);
    data =
        await Provider.of<Consumptions>(ctx, listen: false).getCostsPerMonth();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      child: CustomCard(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              40,
            ),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xfff8be32),
                Color(0xffea5e29),
              ],
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.yMMM().format(
                            selectedDate,
                          ),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          onPressed: () => _showMonthPicker(context),
                          icon: Icon(
                            Icons.date_range,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      child: Text(
                        'Cost: ${data['totalAmount']} KM',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )
                  ],
                ),
                VerticalDivider(
                  thickness: 1,
                  width: 20,
                  indent: 10,
                  endIndent: 10,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Liters:'),
                      Text('${data['totalLiters']}'),
                      const Text('Average price'),
                      Text('${data['avgPrice']} KM'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
