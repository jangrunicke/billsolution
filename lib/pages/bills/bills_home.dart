import 'dart:math';

import 'package:flutter/material.dart';

import 'widgets/vendor_list.dart';
import 'widgets/zeitraum_filter.dart';
import './add_bill_popup.dart';
import './belege_liste.dart';

class BillsHome extends StatefulWidget {
  @override
  _BillsHomeState createState() => _BillsHomeState();
}

class _BillsHomeState extends State<BillsHome> {
  final mockData = ['Rewe', 'DM', 'Edeka', 'Penny', 'Aldi'];

  final colors = [
    Color.fromRGBO(230, 57, 70, 1.0),
    Color.fromRGBO(168, 218, 220, 1.0),
    Color.fromRGBO(254, 168, 168, 1.0),
    Color.fromRGBO(69, 123, 157, 1.0),
    Color.fromRGBO(255, 33, 0, 1.0),
  ];

  final rng = new Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Belege'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  AddBillPopup().openPopup(context);
                }),
          ],
        ),
        body: Column(
          children: [
            Zeitraumfilter(),
            VendorList(),
            BelegeListe(),
          ],
        ));
  }
}
