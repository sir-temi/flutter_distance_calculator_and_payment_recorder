import 'dart:async';

import 'package:distance_calculator/model/keke_rider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/single_data.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../model/keke_rider.dart';
import '../model/payment.dart';

import 'package:firebase_messaging/firebase_messaging.dart';




const googleKey = "AIzaSyDdbA43bFJOu8AZVMa54af8CvC_zzSZHMs";


class SearchForm extends StatefulWidget {
  final size;
  final fontsize;

  SearchForm(this.size, this.fontsize);

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  @override
  var isInit = false;
  var _isLoading = false;
  void didChangeDependencies() {
    if(!isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<KekeRider>(context, listen: false).fetchRiders().catchError((error){
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              error is String && error.contains('errorla')
              ?'Something went wrong'
              :error
              ),
            content: Text('Click the button below to refresh'),
            actions: <Widget>[
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.of(context).pushReplacementNamed('/paymentlist'),
                child: Text('REFRESH'),
                )
            ],
          )
        );
      }).then((_) {
        Provider.of<Payment>(context, listen: false).setPayments().catchError((error){
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              error is String && error.contains('errorla')
              ?'Something went wrong'
              :error
              ),
            content: Text('Click the button below to refresh'),
            actions: <Widget>[
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.of(context).pushReplacementNamed('/paymentlist'),
                child: Text('REFRESH'),
                )
            ],
          )
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      });
      isInit = true;
      
    }
    super.didChangeDependencies();
  }
  @override
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
  final GlobalKey<FormState> _formKey = GlobalKey();
  // var _isLoading = false;
  
  @override
  

  final Map<String, String> _addresses = {
    'pickup': '',
    'destination': '',
    'dest3': '',
    'dest4': '',
    'dest5': ''
  };

  
  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_more == false) {
        final res = await Provider.of<SingleData>(context, listen: false)
            .calculateNow(_addresses['pickup'], _addresses['destination']);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed('/result', arguments: res);
      } else {
        final res = await Provider.of<SingleData>(context, listen: false).calculateOrder(_addresses);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed('/mresult', arguments: res);
      }
    } catch (error) {
      var err;
      if (error is String &&
          error.contains("SocketException: Failed host lookup:")) {
        err = "Iya Jesse your internect connection is poor, please try again";
      } else {
        err = error;
      }
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('OOPS',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                content: Text(
                  err.toString(),
                  style: TextStyle(
                      color: Colors.black, fontSize: widget.fontsize * 18),
                ),
                actions: <Widget>[
                  Row(
                    children: <Widget>[
                      RaisedButton(
                        padding: EdgeInsets.all(10),
                        color: Theme.of(context).primaryColor,
                        child: Text('RESTART',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () =>
                            Navigator.of(context).pushReplacementNamed('/'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(10),
                        color: Colors.blueAccent,
                        child: Text(
                          'Try Again',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  )
                ],
              ));
    }
  }

  String _valu1 = '';
  String _valu2 = '';
  String _valu3 = '';
  String _valu4 = '';
  String _valu5 = '';

  void changeV(i, res) {
    if (i == 1) {
      setState(() {
        _valu1 = res;
      });
    } else if (i == 2) {
      setState(() {
        _valu2 = res;
      });
    } else if (i == 3) {
      setState(() {
        _valu3 = res;
      });
    } else if (i == 4) {
      setState(() {
        _valu4 = res;
      });
    } else if (i == 5) {
      setState(() {
        _valu5 = res;
      });
    }
  }

  var _textController = TextEditingController();
  var _secController = TextEditingController();
  var _3Controller = TextEditingController();
  var _4Controller = TextEditingController();
  var _5Controller = TextEditingController();

  var _more = false;
  void morechanger(n) {
    setState(() {
      _more = n;
    });
  }

  void clearForm(m){
    if (m == false) {
      setState(() {
        _textController.clear();
        _secController.clear();
        _valu1 = '';
        _valu2 = '';
      });
    } else {
      _textController.clear();
      _secController.clear();
      _3Controller.clear();
      _4Controller.clear();
      _5Controller.clear();
      _valu1 = '';
      _valu2 = '';
      _valu3 = '';
      _valu4 = '';
      _valu5 = '';
    }
  }

  @override
  void dispose() {
     _textController.dispose();
      _secController.dispose();
      _3Controller.dispose();
      _4Controller.dispose();
      _5Controller.dispose();
    super.dispose();
  }
  @override

  @override
  Widget build(BuildContext context) {
    if (_valu1.length != 0) {
      _textController.text = _valu1;
    }
    if (_valu2.length != 0) {
      _secController.text = _valu2;
    }
    if (_valu3.length != 0) {
      _3Controller.text = _valu3;
    }
    if (_valu4.length != 0) {
      _4Controller.text = _valu4;
    }
    if (_valu5.length != 0) {
      _5Controller.text = _valu5;
    }
    return _isLoading == true
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GlowingProgressIndicator(
                    child: Icon(Icons.directions_bike,
                        size: widget.fontsize * 100,
                        color: Theme.of(context).primaryColorDark)),
              ],
            ),
          )
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                // width: deviceSize.width * 0.8,
                margin: EdgeInsets.symmetric(horizontal: 25),
                alignment: Alignment.center,
                // margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: widget.size.height * .16,
                        width: double.infinity,
                        margin:
                            EdgeInsets.only(left: 40, right: 40, bottom: 10),
                        child: Image.asset(
                          "assets/images/yl.png",
                          fit: BoxFit.contain,
                        )),
                    Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: _more == true
                                      ? Colors.white24
                                      : Theme.of(context).primaryColorDark,
                                  onPressed: () {
                                    morechanger(false);
                                  },
                                  child: Text(
                                    'Single',
                                    style: TextStyle(
                                        color: _more == true
                                            ? Colors.blueAccent
                                            : Colors.white),
                                  )),
                            ),
                            Expanded(
                              child: FlatButton(
                                  color: _more == false
                                      ? Colors.white
                                      : Theme.of(context).primaryColorDark,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    morechanger(true);
                                  },
                                  child: Text('Multiple',
                                      style: TextStyle(
                                          color: _more == true
                                              ? Colors.white
                                              : Colors.blueAccent))),
                            )
                          ],
                        )),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                controller: _textController,
                                onTap: () async {
                                  Prediction p = await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: googleKey,
                                      language: "en",
                                      components: [
                                        Component(Component.country, "ng")
                                      ]);
                                  String res = p.description;
                                  if (p != null) {
                                    changeV(1, res);
                                  }
                                },
                                style:
                                    TextStyle(fontSize: widget.fontsize * 20),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.home,
                                    color: Colors.blueAccent,
                                  ),
                                  labelText: 'Pick Up Address',
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent),
                                  ),
                                ),
                                validator: (v) {
                                  if (v.isEmpty) {
                                    return "An address can't be empty";
                                  } else if (v.length < 5) {
                                    return "An address can't be lesser than 5 characters";
                                  }
                                },
                                onSaved: (v) {
                                  _addresses['pickup'] = v;
                                },
                              ),
                            ),
                            Container(
                              // margin: EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: _secController,
                                onTap: () async {
                                  Prediction p = await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: googleKey,
                                      language: "en",
                                      components: [
                                        Component(Component.country, "ng")
                                      ]);
                                  String res = p.description;
                                  if (p != null) {
                                    changeV(2, res);
                                  }
                                },
                                style:
                                    TextStyle(fontSize: widget.fontsize * 20),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.directions_bike,
                                    color: Colors.blueAccent,
                                  ),
                                  // filled: true,
                                  labelText: 'Delivery Address',
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent),
                                  ),
                                ),
                                validator: (v) {
                                  if (v.isEmpty) {
                                    return "An address can't be empty";
                                  } else if (v.length < 5) {
                                    return "An address can't be lesser than 5 characters";
                                  }
                                },
                                onSaved: (v) {
                                  _addresses['destination'] = v;
                                },
                              ),
                            ),
                            _more == true
                                ? Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: TextFormField(
                                            controller: _3Controller,
                                            onTap: () async {
                                              Prediction p =
                                                  await PlacesAutocomplete.show(
                                                      context: context,
                                                      apiKey: googleKey,
                                                      language: "en",
                                                      components: [
                                                    Component(
                                                        Component.country, "ng")
                                                  ]);
                                              String res = p.description;
                                              if (p != null) {
                                                changeV(3, res);
                                              }
                                            },
                                            style: TextStyle(
                                                fontSize: widget.fontsize * 20),
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.directions_bike,
                                                color: Colors.blueAccent,
                                              ),
                                              labelText: 'Delivery Address',
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Colors.blueAccent),
                                              ),
                                            ),
                                            validator: (v) {
                                              if (v.isEmpty) {
                                                return "An address can't be empty";
                                              } else if (v.length < 5) {
                                                return "An address can't be lesser than 5 characters";
                                              }
                                            },
                                            onSaved: (v) {
                                              _addresses['dest3'] = v;
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: TextFormField(
                                            controller: _4Controller,
                                            onTap: () async {
                                              Prediction p =
                                                  await PlacesAutocomplete.show(
                                                      context: context,
                                                      apiKey: googleKey,
                                                      language: "en",
                                                      components: [
                                                    Component(
                                                        Component.country, "ng")
                                                  ]);
                                              String res = p.description;
                                              if (p != null) {
                                                changeV(4, res);
                                              }
                                            },
                                            style: TextStyle(
                                                fontSize: widget.fontsize * 20),
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.directions_bike,
                                                color: Colors.blueAccent,
                                              ),
                                              labelText: 'Delivery Address',
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Colors.blueAccent),
                                              ),
                                            ),
                                            validator: (String v) {
                                              if (v.isNotEmpty &&
                                                  v.length < 5) {
                                                return "An address can't be lesser than 5 characters";
                                              }
                                            },
                                            onSaved: (v) {
                                              _addresses['dest4'] = v;
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: TextFormField(
                                            controller: _5Controller,
                                            onTap: () async {
                                              Prediction p =
                                                  await PlacesAutocomplete.show(
                                                      context: context,
                                                      apiKey: googleKey,
                                                      language: "en",
                                                      components: [
                                                    Component(
                                                        Component.country, "ng")
                                                  ]);
                                              String res = p.description;
                                              if (p != null) {
                                                changeV(5, res);
                                              }
                                            },
                                            style: TextStyle(
                                                fontSize: widget.fontsize * 20),
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.directions_bike,
                                                color: Colors.blueAccent,
                                              ),
                                              labelText: 'Delivery Address',
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Colors.blueAccent),
                                              ),
                                            ),
                                            validator: (String v) {
                                              if (v.isNotEmpty &&
                                                  v.length < 5) {
                                                return "An address can't be lesser than 5 characters";
                                              }
                                            },
                                            onSaved: (v) {
                                              _addresses['dest5'] = v;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RaisedButton(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        color: Colors.blueAccent,
                                        child: Icon(
                                          Icons.check,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                        onPressed: _submit),
                                    flex: 2,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: RaisedButton(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        color: Colors.red,
                                        child: Icon(
                                          Icons.close,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          clearForm(_more);
                                          
                                        }),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
  }
  // showNotifi()async{
  //   print('hello');
  //   var android = new AndroidNotificationDetails(
  //     'channelId', 'channelName', 'channelDescription'
  //     );
  //   var platform = new NotificationDetails(android:android);
  //   await flutterLocalNotificationsPlugin.show(
  //     0, 
  //     'Hi there', 
  //     'How are you', 
  //     platform,
  //     payload: 'Hi'
  //     );
  // }
}
