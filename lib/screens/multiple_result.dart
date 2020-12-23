import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MultipleResult extends StatelessWidget {
  static const routeName = '/mresult';
  int moneyC(String v) {
    return (num.parse(v.substring(0, v.length - 3)) * 75).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    final fontsize = MediaQuery.of(context).textScaleFactor;
    final data = ModalRoute.of(context).settings.arguments as Map;
    String from = data['pickup'];
    var dat = data['data'];

    // List to = data['destination_addresses'];
    // List ele = data['rows'][0]['elements'];
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Price and Distance Estimate'),
    );
    final appBarheight = appBar.preferredSize.height;
    final batterybar = MediaQuery.of(context).padding.top;
    final screenSize = screensize.height - (appBarheight + batterybar);

    // String to = data['destination_addresses'][0];
    // String distance = data['rows'][0]['elements'][0]['distance']['text'];
    // String duration = data['rows'][0]['elements'][0]['duration']['text'];
    // var amount = num.parse(distance.substring(0, distance.length - 3)) * 45;
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Column(
              children: <Widget>[
                Container(
                  height: screenSize * 0.16,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(
                              Icons.home,
                              size: fontsize * 40,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(from,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: fontsize * 20,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ]),
                          Expanded(
                                                      child: Container(
                              padding: EdgeInsets.only(top: 5),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Total  ',
                                      style: TextStyle(
                                        fontSize: fontsize * 25,
                                        color: Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.bold
                                        ),
                                    ),
                                    Chip(
                                      backgroundColor: Colors.blueAccent,
                                      label: Text(
                                      NumberFormat.simpleCurrency(
                                              name: 'NGN', decimalDigits: 0)
                                          .format(data['total']),
                                      style: TextStyle(
                                        fontSize: fontsize * 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                        ),
                                    ),
                                    )
                                  ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    height: screenSize * 0.81,
                    child: ListView.builder(
                      itemCount: dat.length,
                      itemBuilder: (ctx, i) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        size: fontsize * 40,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(dat[i]['address'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: fontsize * 20,
                                                fontWeight: FontWeight.w800)),
                                      ),
                                    ]),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.credit_card,
                                              size: fontsize * 30,
                                              color: Colors.blueAccent,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            moneyC(dat[i]['elements']
                                                        ['distance']['text']) <
                                                    1200
                                                ? Tooltip(
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .primaryColorDark,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    padding: EdgeInsets.all(10),
                                                    preferBelow: false,
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: fontsize * 20,
                                                        color: Colors.white),
                                                    message: NumberFormat
                                                            .simpleCurrency(
                                                                name: 'NGN',
                                                                decimalDigits:
                                                                    0)
                                                        .format(moneyC(dat[i]
                                                                    ['elements']
                                                                ['distance']
                                                            ['text'])),
                                                    child: Text(
                                                      NumberFormat
                                                              .simpleCurrency(
                                                                  name: 'NGN',
                                                                  decimalDigits:
                                                                      0)
                                                          .format(1200),
                                                      style: TextStyle(
                                                          fontSize:
                                                              fontsize * 30,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green),
                                                    ),
                                                  )
                                                : Text(
                                                    NumberFormat.simpleCurrency(
                                                            name: 'NGN',
                                                            decimalDigits: 0)
                                                        .format(moneyC(dat[i]
                                                                    ['elements']
                                                                ['distance']
                                                            ['text'])),
                                                    style: TextStyle(
                                                        fontSize: fontsize * 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green),
                                                  )
                                          ],
                                        )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.timelapse,
                                                      size: fontsize * 30,
                                                      color: Color(0xff800080)),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    dat[i]['elements']
                                                        ['duration']['text'],
                                                    style: TextStyle(
                                                        fontSize: fontsize * 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                                child: Row(
                                              children: <Widget>[
                                                Icon(Icons.directions_bike,
                                                    size: fontsize * 30,
                                                    color: Color(0xffDAA520)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    dat[i]['elements']
                                                        ['distance']['text'],
                                                    style: TextStyle(
                                                        fontSize: fontsize * 20,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
              ],
            )),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
            child: Icon(
              Icons.refresh,
              size: fontsize * 35,
            ),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/')),
      ),
    );
  }
}
