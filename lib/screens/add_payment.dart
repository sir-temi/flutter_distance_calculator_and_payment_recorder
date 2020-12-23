import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import '../model/payment.dart';
import '../model/keke_rider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import './iconbutton.dart';

class AddPayment extends StatefulWidget {
  static const routeName = '/addpayment';

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var isLoading = false;
  final payment = {
    'amount':'',
    'name': ''
  };

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final rider = Provider.of<KekeRider>(context).getRider(id);
    Future<void> submit() async{
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try{
      setState(() {
        isLoading = true;
      });
      await Provider.of<Payment>(context, listen: false).addPayment(int.parse(payment['amount']), id);
      await Provider.of<KekeRider>(context, listen: false).addPayment(int.parse(payment['amount']), id);
      Navigator.pushNamedAndRemoveUntil(context, "/paymentlist", (Route<dynamic> route) => false);
      setState(() {
        isLoading = false;
      });
    }catch(error){

    }
    }
    return Scaffold(
      appBar: AppBar(),
      body: isLoading == true
      ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GlowingProgressIndicator(
                    child: Icon(Icons.directions_bike,
                        size: 100,
                        color: Theme.of(context).primaryColorDark)),
              ],
            ),
          )
      : Container(
        padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'How much did ${rider.name} pay?',
                      focusColor: Colors.blueAccent,
                      prefixIcon: Icon(Icons.attach_money_outlined, size: 35, color: Theme.of(context).primaryColor,) ,
                      errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                              color:
                                  Colors.blueAccent)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: Colors.blue),)
                    ),
                    validator: (v) {
                              if (v.isEmpty) {
                                return 'Enter amount';
                              } else if(isNumeric(v) != true){
                                return 'Must be numbers';
                              }else if(v.length < 3){
                                return 'Type Amount correctly';
                              }
                              else {
                                return null;
                              }
                            },
                    onSaved: (v){
                      payment['amount'] = v;
                      payment['owner'] = id;
                    },
                  ),
                  
                ),
                // SizedBox(height:5),
                IconB(
                  subMit: submit,
                  level: 'Payment',
                    )
                ],
              )
            ),
      ),
    );
  }
}