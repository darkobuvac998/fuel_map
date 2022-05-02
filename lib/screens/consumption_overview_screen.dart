import 'package:flutter/material.dart';

import '../widgets/consumption_chart.dart';

class ConsumptionOverviewScreen extends StatefulWidget {
  const ConsumptionOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ConsumptionOverviewScreen> createState() =>
      _ConsumptionOverviewScreenState();
}

class _ConsumptionOverviewScreenState extends State<ConsumptionOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Expanded(
        child: ConsumptionChart(),
      ),
    );
  }
}
