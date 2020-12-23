import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import '../model/keke_rider.dart';
import 'package:provider/provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'iconbutton.dart';

class AddRider extends StatefulWidget {
  static const routeName = '/addrider';

  @override
  _AddRiderState createState() => _AddRiderState();
}

class _AddRiderState extends State<AddRider> {
  var isLoading = false;

  var _rider = KekeRider(
    payment: null,
    day: null,
    name: null,
    totalpayment: null,
    paysOn: null
  );

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    void submit(){
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    _rider = KekeRider(
          payment: _rider.payment,
          day: DateTime.now(),
          name: _rider.name,
          totalpayment: 1200000,
          paysOn: _rider.paysOn
        );
    setState(() {
      isLoading = true;
    });
    Provider.of<KekeRider>(context, listen: false).addrider(_rider)
    .catchError((error){
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              error is String && error.contains('errorla')
              ?'Something went wrong'
              :'NETWORK ERROR'
              ),
            content: Text('Couldn\'nt be added, please add again.'),
            actions: <Widget>[
              RaisedButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/addrider'),
                child: Text('Try Again'),
                )
            ],
          )
        );
    })
    .then((_){
      Navigator.pushNamedAndRemoveUntil(context, "/paymentlist", (Route<dynamic> route) => false);
      isLoading = false;
    });
  }
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            title: Text('Add a Rider'),
          ),
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
          : SingleChildScrollView(
                      child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 30),
        child: Form(
                        key: _formKey,
                        child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: TextFormField(
                      style: TextStyle(fontSize: 20,),
                      decoration: InputDecoration(
                        labelText: 'Rider\'s name',
                        focusColor: Colors.blueAccent,
                        prefixIcon: Icon(Icons.account_box_rounded, size: 35, color: Theme.of(context).primaryColor,) ,
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
                                  return 'Name can\'t be empty';
                                } else if(isNumeric(v) == true){
                                  return 'Name can\'t be numbers';
                                }else if(v.length < 3){
                                  return 'Name can\'t be lesser than 3';
                                }
                                else {
                                  return null;
                                }
                              },
                      onSaved: (v){
                        _rider = KekeRider(
                          payment: _rider.payment,
                          name: v,
                          day: _rider.day,
                          totalpayment: _rider.totalpayment
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: TextFormField(
                      style: TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Total Amount paid till date',
                        focusColor: Colors.blueAccent,
                        prefixIcon: Icon(Icons.account_balance_rounded, size: 35, color: Theme.of(context).primaryColor,) ,
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
                                  return 'Amount can\'t be empty';
                                } else if(isNumeric(v) != true){
                                  return 'Please type numbers';
                                }else if(v.length < 3){
                                  return 'Amount can\'t be lesser than 3';
                                }
                                else {
                                  return null;
                                }
                              },
                      onSaved: (v){
                        _rider = KekeRider(
                          payment: int.parse(v),
                          name: _rider.name,
                          day: _rider.day,
                          totalpayment: _rider.totalpayment
                        );
                      },
                    ),
                    
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: TextFormField(
                      style: TextStyle(fontSize: 20),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Day of the week this rider pays',
                        focusColor: Colors.blueAccent,
                        prefixIcon: Icon(Icons.account_balance_rounded, size: 35, color: Theme.of(context).primaryColor,) ,
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
                                  return 'Payment Date can\'t be empty';
                                } else if(isNumeric(v) == true){
                                  return 'A day can\'t be numbers';
                                }else if(v.length < 3){
                                  return 'Do specify the date';
                                }
                                else {
                                  return null;
                                }
                              },
                      onSaved: (v){
                        _rider = KekeRider(
                          payment: _rider.payment,
                          name: _rider.name,
                          day: _rider.day,
                          totalpayment: _rider.totalpayment,
                          paysOn: v
                        );
                      },
                    ),
                    
                  ),
                  // SizedBox(height:5),
                  IconB(
                    subMit: submit,
                    level: 'Rider',
                  )
                  // RaisedButton(onPressed: null)
                  // IconButton(
                  //         icon: Icon(Icons.add_box_rounded, size: 60,), onPressed: null
                  //         ),
                ],
              ),
            ),
        ),
          ),
    );
  }
}