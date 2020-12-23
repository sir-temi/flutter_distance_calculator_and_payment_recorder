import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/keke_rider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../model/payment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class PaymentList extends StatefulWidget {
  static const routeName = '/paymentlist';

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  @override
  // var isLoading = false;
  // var isInit = false;
  // void didChangeDependencies() {
  //   if (isInit == false) {
  //     setState(() {
  //     isLoading = true;
  //     });
  //     Provider.of<KekeRider>(context, listen: false).fetchRiders().catchError((error){
  //       showDialog(
  //         context: context,
  //         builder: (ctx) => AlertDialog(
  //           title: Text(
  //             error is String && error.contains('errorla')
  //             ?'Something went wrong'
  //             :error
  //             ),
  //           content: Text('Click the button below to refresh'),
  //           actions: <Widget>[
  //             RaisedButton(
  //               color: Theme.of(context).primaryColor,
  //               onPressed: () => Navigator.of(context).pushReplacementNamed('/paymentlist'),
  //               child: Text('REFRESH'),
  //               )
  //           ],
  //         )
  //       );
  //     }).then((_) {
  //       Provider.of<Payment>(context, listen: false).setPayments().catchError((error){
  //       showDialog(
  //         context: context,
  //         builder: (ctx) => AlertDialog(
  //           title: Text(
  //             error is String && error.contains('errorla')
  //             ?'Something went wrong'
  //             :error
  //             ),
  //           content: Text('Click the button below to refresh'),
  //           actions: <Widget>[
  //             RaisedButton(
  //               color: Theme.of(context).primaryColor,
  //               onPressed: () => Navigator.of(context).pushReplacementNamed('/paymentlist'),
  //               child: Text('REFRESH'),
  //               )
  //           ],
  //         )
  //       );
  //     }).then((_) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     });
  //     });
  //     isInit = true;
  //   }

  //   super.didChangeDependencies();
  // }
  
  void initState() {
    final FirebaseMessaging fbm = FirebaseMessaging();
      fbm.configure(
      onLaunch: (msg){
        // Navigator.of(context).pushReplacementNamed('/').then((_) => Navigator.of(context).pushReplacementNamed('/notifi', arguments: msg['data']['id']));
        return;
      },
      onResume: (msg){
        if (msg['data'].containsKey('id')) {
          Navigator.of(context).pushReplacementNamed('/notifi', arguments: msg['data']['id']);
        } else if (msg['data'].containsKey('payment')){
          Navigator.of(context).pushReplacementNamed('/paymentlist');
        }else{
          Navigator.of(context).pushReplacementNamed('/');
        }
        return;
      },
      onMessage: (msg){
        if (msg['data'].containsKey('id')) {
          Navigator.of(context).pushReplacementNamed('/notifi', arguments: msg['data']['id']);
        } else if (msg['data'].containsKey('payment')){
          Navigator.of(context).pushReplacementNamed('/paymentlist');
        }else{
          Navigator.of(context).pushReplacementNamed('/');
        }
        return;
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final kekeN = Provider.of<KekeRider>(context, listen: false).numRiders;
    Widget appy(int a){
    if (a == 0) {
      return AppBar(
        title: Text('Payment History'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.home_rounded), 
            iconSize: 32,
            onPressed: () => Navigator.of(context).pushReplacementNamed('/')
            )
        ],
      );
    } else {
      return AppBar(
        title: Text('Payment History'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.home_rounded), 
            iconSize: 32,
            onPressed: () => Navigator.of(context).pushReplacementNamed('/')
            ),
            IconButton(
            icon: Icon(Icons.add), 
            iconSize: 32,
            onPressed: () => Navigator.of(context).pushNamed('/addrider')
            )
        ],
      );
    }
  }
    List ls = Provider.of<KekeRider>(context, listen: false).riders;
    return Scaffold(
      appBar: appy(Provider.of<KekeRider>(context, listen: false).numRiders),
      body:Consumer<KekeRider>(
        builder: (context, keke, child){
          return Provider.of<KekeRider>(context, listen: false).numRiders == 0
      ? Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Keke has been added',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          RaisedButton(onPressed:()=>Navigator.of(context).pushNamed('/addrider'), child: Text('Add Keke', style: TextStyle(color: Colors.white),), color: Colors.blueAccent,)
        ],
      ))
      : Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              child: Card(elevation: 8,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // margin: EdgeInsets.only(right:10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.electric_rickshaw_rounded, size: 45, color: Theme.of(context).primaryColor,),
                            SizedBox(width:5),
                            Text(kekeN.toString(), style: TextStyle(fontSize: 40, color: Colors.blueAccent, fontWeight: FontWeight.w900,),)
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.account_balance_wallet_rounded, size: 26, color: Theme.of(context).primaryColor),
                                SizedBox(width:3),
                                FittedBox(child: Text(NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0).format(Provider.of<KekeRider>(context, listen: false).totalPayment), style: TextStyle(fontSize: 22, color: Colors.blueAccent, fontWeight: FontWeight.bold)))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.account_balance_sharp, size: 26, color: Theme.of(context).primaryColor),
                                SizedBox(width:3),
                                FittedBox(
                                  child: Text(NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0).format((1200000*kekeN)-Provider.of<KekeRider>(context, listen: false).totalPayment), style: TextStyle(fontSize: 22, color: Colors.blueAccent, fontWeight: FontWeight.bold)))
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Expanded(
                              child: ListView.builder(
                  itemCount: ls.length,
                  itemBuilder: (ctx, i){
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed("/riderdetail", arguments: ls[i].id),
                                          child: Card(
                                            elevation: 3,
                                            shadowColor: Colors.indigo,
                        margin: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          margin: EdgeInsets.only(left:10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ls[i].name, style: TextStyle(fontSize: 25, color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),),
                              Text(
                                'Pays on ${ls[i].paysOn.toUpperCase()}s', 
                                style: TextStyle(fontSize: 18),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                    ),
              ),
            ),
          ],
        ),
      );
        }
        )
    );
  }
}