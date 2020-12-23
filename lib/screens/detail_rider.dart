import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/keke_rider.dart';
import 'package:intl/intl.dart';
import '../model/payment.dart';

class DetailRider extends StatelessWidget {
  static const routeName = '/riderdetail';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final rider = Provider.of<KekeRider>(context, listen: false).getRider(id);
    final payments = Provider.of<Payment>(context, listen:false).fetchpayments(id);
    Provider.of<Payment>(context, listen:false).setPayments();
    return Scaffold(
      appBar: AppBar(
        title: Text('${rider.name}\'s summary'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Container(margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_circle_rounded, size: 40, color: Theme.of(context).primaryColor,),
                      SizedBox(width:10),
                      Text(rider.name, style: TextStyle(fontSize: 35, color: Colors.blueAccent, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.account_balance_wallet_rounded, size: 27, color: Theme.of(context).primaryColor),
                            SizedBox(width:3),
                            FittedBox(child: Text(NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0).format(rider.payment), style: TextStyle(fontSize: 23, color: Colors.blueAccent, fontWeight: FontWeight.bold)))
                          ],
                        )
                        ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.account_balance_rounded, size: 27, color: Theme.of(context).primaryColor),
                            SizedBox(width:3),
                            FittedBox(child: Text(NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0).format(1200000-rider.payment), style: TextStyle(fontSize: 23, color: Colors.blueAccent, fontWeight: FontWeight.bold)))
                          ],
                        )
                        ),
                    ],
                  ),
                ),
                Container(
                  child: Text('Pays on ${rider.paysOn.toUpperCase()}s', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                SizedBox(height:10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal:40),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 30,),
                        SizedBox(width:5),
                        Text('Add Payment', style: TextStyle(fontSize: 20),)
                      ],
                    ),
                    onPressed: ()=>Navigator.of(context).pushNamed('/addpayment', arguments:id),
                    elevation: 7,
                    ),
                ),
                Container(
                  margin: EdgeInsets.only(top:20),
                  child: Text(
                    payments.length == 0 
                    ?'No Payment has been added'
                    : payments.length > 1
                    ?'${payments.length} Payments'
                    :'${payments.length} Payment'
                    , 
                    style: TextStyle(fontSize: 20, color: Colors.blueAccent, fontWeight: FontWeight.bold)))
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: payments.length,
                itemBuilder: (ctx, i){
                  return Card(
                    elevation: 3,
                    shadowColor: Colors.blueGrey,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                        child: FittedBox(
                                          child: 
                        Text('${NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0).format(payments[i].amount)} on ${DateFormat.EEEE().format(payments[i].date)} ${DateFormat.yMMMd().format(payments[i].date)}', style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
    
                    ),
                                      ),
                  );
                }
                ),
            ),
          )
        ],
    ));
      }
}