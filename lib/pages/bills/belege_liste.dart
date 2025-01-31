import 'package:billsolution_app/aggregates/bill/bill.dart';
import 'package:billsolution_app/aggregates/user.dart';
import 'package:billsolution_app/pages/bills/bill_details.dart';
import 'package:billsolution_app/pages/bills/models/vendor_filter_model.dart';
import 'package:billsolution_app/pages/bills/models/zeitraum_filter_model.dart';
import 'package:billsolution_app/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

/// Widget der Belege-Liste
class BelegeListe extends StatelessWidget {
  /// Methode die sich dem allgemeinen Darstellen der Belege widmet
  /// auslagerung durch buildBillListView().
  /// Es wird der aktuelle User genommen und auf diesem Objekt wird die Methode getBills() aufgerufen,
  /// welche Bills des Users liefert
  /// returned Container Widget, dass die Liste beinhaltet
  Widget _buildBelege(BuildContext context) {
    return Container(
      child: Consumer<User>(builder: (context, user, child) {
        if (user != null) {
          return StreamBuilder(
              stream: user.getBills(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Bill>> snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  var tempbills = List<Bill>();
                  var finalBills = List<Bill>();
                  var zeitraumfilter = context.watch<ZeitraumfilterModel>();
                  var lastValidDate = zeitraumfilter.getLastValidDate();

                  var vendorfilter = context.watch<VendorFilterModel>();
                  snapshot.data.forEach((bill) {
                    if (vendorfilter.selectedFilter == '') {
                      tempbills.add(bill);
                    } else if (bill.shop.vendor.name ==
                        vendorfilter.selectedFilter) {
                      tempbills.add(bill);
                    }
                  });

                  tempbills.forEach((bill) {
                    if (bill.created_at.isAfter(lastValidDate)) {
                      finalBills.add(bill);
                    }
                  });

                  return _buildBillListView(finalBills, context);
                }
                return Text('Waiting');
              });
        }
        return Text('Waiting');
      }),
      margin: EdgeInsets.all(5),
    );
  }

  ///Methode die dem erstellen des List-View Widgets dient
  /// Parameter bills: Liste der Bills die dargestellt werden sollen
  /// context: Build-Context
  /// returned ListView Element sobald die Daten aus dem Stream da sind
  Widget _buildBillListView(List<Bill> bills, BuildContext context) {
    if (bills != null) {
      return ListView.separated(
        padding: EdgeInsets.all(10),
        itemCount: bills.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildBillListTile(bills[index], context);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    }
    return Text('Waiting');
  }

  /// Methode baut ein einzelnes Listen-Element
  /// Parameter bill: Der Bill, der dargestellt werden soll
  /// Parameter context: BuildContext
  /// returned: ListTile-Widget, dass das Element beinhaltet
  Widget _buildBillListTile(Bill bill, BuildContext context) {
    return ListTile(
        title: Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Text(bill.shop.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(_toDateFormat(bill.created_at),
                    style: TextStyle(color: Color.fromRGBO(152, 152, 152, 1.0)))
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )),
            StreamBuilder(
                stream: bill.getCalculatedSum(),
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.toStringAsFixed(2) + '€',
                      style: TextStyle(
                          color: Color.fromRGBO(152, 152, 152, 1.0),
                          fontSize: 18),
                    );
                  }
                  return Text('Waiting');
                })
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Color.fromRGBO(152, 152, 152, 1.0),
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return BillDetails(bill);
          }));
        });
  }

  String _toDateFormat(DateTime date) {
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  /// Build-Methode, die aufgerufen wird wenn das Widget dargestellt werden soll
  /// returned ein Expanded Widgeet in dem die Liste liegt
  /// Liste wurde in _buildBelege() ausgelagert
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      child: _buildBelege(context),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                blurRadius: 4, color: Colors.grey, offset: Offset(0.0, 0.4)),
          ]),
      margin: EdgeInsets.all(15),
    ));
  }
}
