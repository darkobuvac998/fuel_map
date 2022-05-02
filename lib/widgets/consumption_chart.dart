import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/consumption_chart_data.dart';
import '../providers/consumptions.dart';

class ConsumptionChart extends StatefulWidget {
  const ConsumptionChart({Key? key}) : super(key: key);
  @override
  State<ConsumptionChart> createState() => _ConsumptionChartState();
}

class _ConsumptionChartState extends State<ConsumptionChart> {
  late TooltipBehavior _tooltipBehavior;
  final _yearController = TextEditingController();
  bool _showLiters = false;
  int _year = DateTime.now().year;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      elevation: 10,
      enable: true,
    );
    _yearController.text = _year.toString();
    super.initState();
  }

  void _onYearPick(BuildContext ctx) async {
    var year = DateFormat.y().parse(_year.toString());
    await showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              selectedDate: year,
              onChanged: (DateTime dateTime) {
                setState(() {
                  _year = dateTime.year;
                  _yearController.text = _year.toString();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  void _onShowLiters(bool showLiters) {
    setState(() {
      _showLiters = showLiters;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Consumptions>(context).prepareChartData(_year);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Consumption for year: ',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 40,
                    child: TextFormField(
                      readOnly: true,
                      controller: _yearController,
                      onTap: () => _onYearPick(
                        context,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Show liters:',
                      ),
                      Switch(
                        value: _showLiters,
                        onChanged: (value) => _onShowLiters(value),
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                isTransposed: true,
                tooltipBehavior: _tooltipBehavior,
                legend: Legend(
                  opacity: 1,
                  isVisible: true,
                  position: LegendPosition.bottom,
                  title: LegendTitle(),
                ),
                series: [
                  if (!_showLiters)
                    BarSeries<ConsmumptionChartData, String>(
                      name: 'Total money',
                      color: Theme.of(context).primaryColor,
                      dataSource: data,
                      xValueMapper: (ConsmumptionChartData data, _) =>
                          data.month,
                      yValueMapper: (ConsmumptionChartData data, _) =>
                          data.expense,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                    ),
                  if (_showLiters)
                    BarSeries<ConsmumptionChartData, String>(
                      name: 'Total liters',
                      color: Theme.of(context).accentColor,
                      dataSource: data,
                      xValueMapper: (ConsmumptionChartData data, _) =>
                          data.month,
                      yValueMapper: (ConsmumptionChartData data, _) =>
                          data.liters,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                    ),
                ],
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                ),
                primaryXAxis: CategoryAxis(
                  visibleMaximum: 4,
                  visibleMinimum: 1,
                  interval: 1,
                ),
                primaryYAxis: NumericAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  numberFormat: !_showLiters
                      ? NumberFormat.simpleCurrency(
                          decimalDigits: 0,
                          locale: 'bs',
                        )
                      : NumberFormat.compact(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
