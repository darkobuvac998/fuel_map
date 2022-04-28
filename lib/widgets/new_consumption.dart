import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/fuel_item.dart';
import '../models/consumption_item.dart';
import '../providers/consumptions.dart';
import '../providers/fuels.dart';
import '../models/http_exception.dart';

class NewConsumption extends StatefulWidget {
  String fuelId;
  NewConsumption({required this.fuelId, Key? key}) : super(key: key);

  @override
  State<NewConsumption> createState() => _NewConsumptionState();
}

class _NewConsumptionState extends State<NewConsumption> {
  final _form = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController amountCtl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    dateCtl.dispose();
    amountCtl.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    final fuel =
        Provider.of<Fuels>(context, listen: false).getFuelById(widget.fuelId);
    final total = double.parse(
        (double.parse(amountCtl.text) / fuel.price).toStringAsPrecision(2));
    print(total);
    var item = ConsumptionItem(
      amount: double.parse(amountCtl.text),
      date: dateCtl.text,
      fuel: fuel,
      id: '',
      total: total,
    );

    try {
      setState(() {
        _loading = true;
      });
      await Provider.of<Consumptions>(context, listen: false)
          .addConsumptionItem(item);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Consumption added successfully',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } catch (error) {
      var tempError = error as HttpException;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tempError.message,
            textAlign: TextAlign.center,
          ),
        ),
      );
      Navigator.of(context).pop();
      setState(() {
        _loading = false;
      });
    }

    Navigator.of(context).pop();
    setState(() {
      _loading = false;
    });
  }

  void _datePick(BuildContext ctx) async {
    DateTime? date = DateTime(1900);
    date = await showDatePicker(
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: const Color(0xfffa8b27),
                onPrimary: Colors.white,
                surface: Theme.of(ctx).canvasColor,
                onSurface: Theme.of(ctx).colorScheme.secondary,
                background: Colors.white,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!);
      },
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );

    dateCtl.text = DateFormat.yMMMd().format(date ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final fuel =
        Provider.of<Fuels>(context, listen: false).getFuelById(widget.fuelId);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          right: 20.0,
          left: 20.0,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FuelItem(
              fuelId: widget.fuelId,
              disableTap: true,
            ),
            Container(
              height: mediaQuery.size.height * 0.3,
              width: mediaQuery.size.width * 0.7,
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: mediaQuery.size.width * 0.5,
                      child: TextFormField(
                        controller: amountCtl,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          label: Text(
                            'Amount',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          focusColor: Theme.of(context).primaryColor,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        style: Theme.of(context).textTheme.headline6,
                        cursorColor: Theme.of(context).primaryColor,
                        validator: (value) {
                          var temp = value ?? '';
                          if (temp != null && temp.isEmpty) {
                            return 'Please provide a value';
                          }
                          if (double.tryParse(temp) == null) {
                            return "Please enter a valid number";
                          }
                          if (double.parse(temp) <= 0) {
                            return 'Please enter a number greate than zero.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    ),
                    SizedBox(
                      width: mediaQuery.size.width * 0.5,
                      child: TextFormField(
                        readOnly: true,
                        autofocus: false,
                        controller: dateCtl,
                        decoration: InputDecoration(
                          label: Text(
                            'Date',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          focusColor: Theme.of(context).primaryColor,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          _datePick(context);
                        },
                        validator: (value) {
                          var temp = value ?? '';
                          if (temp.isEmpty) {
                            return 'Please provide a date';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (_loading)
              Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            if (!_loading)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: Theme.of(context).textTheme.headline6,
                  elevation: 5,
                ),
                onPressed: _saveForm,
                child: const Text(
                  'Save',
                ),
              )
          ],
        ),
      ),
    );
  }
}
