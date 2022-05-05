import 'package:flutter/material.dart';
import 'package:fuel_map/providers/consumptions.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_card.dart';

class MonthConsumption extends StatefulWidget {
  const MonthConsumption({Key? key}) : super(key: key);

  @override
  State<MonthConsumption> createState() => _MonthConsumptionState();
}

class _MonthConsumptionState extends State<MonthConsumption> {
  DateTime initialDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  // Map<String, dynamic> data = {};
  bool _init = true;

  @override
  void didChangeDependencies() {
    if (_init) {
      onDateChange(context);
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
      });
    } else {
      setState(() {
        selectedDate = DateTime.now();
      });
    }
    onDateChange(ctx);
  }

  void onDateChange(BuildContext ctx) {
    Provider.of<Consumptions>(ctx, listen: false)
        .filterItmes(selectedDate.month, selectedDate.year);
    // data = Provider.of<Consumptions>(ctx, listen: false).monthCosts;
  }

  Widget monthConsumptionoVersion2(BuildContext ctx) {
    final data = Provider.of<Consumptions>(ctx).monthCosts;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Padding(
              padding: EdgeInsets.all(
                8.0,
              ),
              child: Icon(
                Icons.calendar_month,
              ),
            ),
          ),
          title: Text(
            DateFormat.yMMM().format(
              selectedDate,
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: const Text(
            'Tap to chose moonth',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          onTap: () => _showMonthPicker(ctx),
        ),
        const Divider(
          height: 10,
          color: Colors.white70,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6.0,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${data['totalAmount']}',
                  ),
                  const Text(
                    'Total money',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${data['totalLiters']}',
                  ),
                  const Text(
                    'Total liters',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${data['avgPrice']}',
                  ),
                  const Text(
                    'Average Price',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
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
            color: Theme.of(context).primaryColor,
          ),
          child: IntrinsicHeight(
            child: monthConsumptionoVersion2(
              context,
            ),
          ),
        ),
      ),
    );
  }
}
