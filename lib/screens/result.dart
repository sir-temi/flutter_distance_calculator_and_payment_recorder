import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Result extends StatelessWidget {
  static const routeName = '/result';
  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    final fontsize = MediaQuery.of(context).textScaleFactor;
    final data = ModalRoute.of(context).settings.arguments as Map;
    String from = data['origin_addresses'][0];
    String to = data['destination_addresses'][0];
    String distance = data['rows'][0]['elements'][0]['distance']['text'];
    String duration = data['rows'][0]['elements'][0]['duration']['text'];
    var amount = num.parse(distance.substring(0, distance.length - 3)) * 75;
    return Scaffold(
      appBar: AppBar(
        title: Text('Price and Distance Estimate'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: screensize.height * 0.35,
                width: double.infinity,
                child: Card(
                  elevation: 6,
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.credit_card,
                                size: fontsize * 70,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(width: 5),
                              amount < 1200
                                  ? Tooltip(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(10),
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontsize * 20,
                                          color: Colors.white),
                                      message: NumberFormat.simpleCurrency(
                                              name: 'NGN', decimalDigits: 0)
                                          .format(amount),
                                      child: Text(
                                        NumberFormat.simpleCurrency(
                                                name: 'NGN', decimalDigits: 0)
                                            .format(1200),
                                        style: TextStyle(
                                            fontSize: fontsize * 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    )
                                  : Text(
                                      NumberFormat.simpleCurrency(
                                              name: 'NGN', decimalDigits: 0)
                                          .format(amount),
                                      style: TextStyle(
                                          fontSize: fontsize * 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.timelapse,
                                        size: fontsize * 50,
                                        color: Color(0xff800080),
                                      ),
                                      SizedBox(height: 7),
                                      Text(
                                        duration,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.directions_bike,
                                        size: fontsize * 50,
                                        color: Color(0xffDAA520),
                                      ),
                                      SizedBox(height: 7),
                                      Text(
                                        distance,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Icon(
                        Icons.home,
                        size: fontsize * 30,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Text(from,
                            softWrap: true,
                            // overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontSize: fontsize * 18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w800)),
                      ),
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: <Widget>[
                      Icon(
                        Icons.directions_bike,
                        size: fontsize * 30,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(to,
                            style: TextStyle(
                                fontSize: fontsize * 18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w800)),
                      ),
                    ]),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: Colors.blueAccent,
                          child: Icon(
                            Icons.refresh,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              Navigator.of(context).pushReplacementNamed('/')),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
