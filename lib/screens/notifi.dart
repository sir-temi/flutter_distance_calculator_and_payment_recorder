import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/keke_rider.dart';
import '../model/payment.dart';
import 'package:intl/intl.dart';

class Notifi extends StatelessWidget {
  static const routeName = '/notifi';
  final String idi;

  Notifi({
    this.idi
  });
  @override
  Widget build(BuildContext context) {
    final rider = Provider.of<KekeRider>(context, listen: false).getRider(idi);
    final lastPayment = Provider.of<Payment>(context).lastPayment(rider.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('${rider.name.toUpperCase()} should pay today!!!'),
        actions: [
          IconButton(
            icon: Icon(Icons.home), 
            onPressed: ()=>Navigator.of(context).pushReplacementNamed('/')
            )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('* ${rider.name.toUpperCase()} should pay today ${rider.paysOn.toUpperCase()}', style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
            Text('* His outstanding balance is ${NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0).format(rider.totalpayment)}', style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
            lastPayment == null
            ? Text('')
            :Text('* His last payment of ${NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0).format(rider.lastPayment)} was on ${DateFormat.EEEE().format(lastPayment.date)} ${DateFormat.yMMMd().format(lastPayment.date)}', style: TextStyle(fontSize: 20, color: Colors.blueAccent))
          ],
        )
      ),
    );
  }
}