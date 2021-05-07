import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class KekeRider with ChangeNotifier{
  final String name;
  final int totalpayment;
  final int payment;
  final DateTime day;
  final String paysOn;
  final int payTimes;
  final String id;
  // final String authToken;

  KekeRider({
    this.name,
    this.totalpayment,
    this.payment,
    this.day,
    this.paysOn,
    this.payTimes,
    this.id
    // this.authToken
  });


  List<KekeRider> _riders = [];
  List<KekeRider> get riders {
    return [..._riders];
  }

  int get numRiders {
    return _riders.length;
  }

  int get totalPayment {
    int tot = 0;
    _riders.forEach((element) {
      tot+=element.payment;
    });
    return tot;
  }

  getRider(i){
    final rider = _riders.singleWhere((element) => element.id == i);
    return rider;
  }

  String riderID(id){
    return _riders[id].id;
  }

  Future<void> fetchRiders() async{
    final url = 'https://keke-riders.firebaseio.com/riders.json';
    try{
      final response = await http.get(url);
      if (response.statusCode >= 400){
        throw('errorla');
      }
      Map riders = json.decode(response.body) as Map<String, dynamic>;
      if(riders == null){
        return;
      }
      final List<KekeRider> loadedRiders= [];
      riders.forEach((k, v) {
        loadedRiders.add(KekeRider(
          id: k,
          day: DateTime.parse(v['day']),
          name: v['name'],
          paysOn: v['paysOn'],
          totalpayment: v['totalpayment'],
          payment: v['payment']
        ));
      });
      _riders = loadedRiders;
      notifyListeners();
    }catch(e){
      print(e);
      throw(e);
    }
  }

  Future addrider(KekeRider r) async{
    final url = 'https://keke-riders.firebaseio.com/riders.json';

    try{
      final response = await http.post(url,
        body: json.encode({
          'day': r.day.toIso8601String(),
          'name': r.name,
          'payment': r.payment,
          'totalpayment': r.totalpayment - r.payment,
          'paysOn': r.paysOn
        })
      );
      if(response.statusCode >= 400){
        print(response.statusCode);
        throw('errorla+${r.name}');
      }
      final lastr = KekeRider(
        id: json.decode(response.body)['name'],
        day: r.day,
        name: r.name,
        payment: r.payment,
        totalpayment: r.totalpayment - r.payment,
        paysOn: r.paysOn
      );
    _riders.add(lastr);
    notifyListeners();
    }catch(error){
      print(error);
      throw(error);
    }
  }

  addPayment(int p, String id)async{
    // final r = _riders[id];
    final url = 'https://keke-riders.firebaseio.com/riders/$id/payment/.json';

    try{
      final getRes = await http.get(url);
      final response = await http.patch(url,
        body: json.encode({
          'payment': json.decode(getRes.body)+p,
        })
      );
      print(json.decode(getRes.body)-p);
      print(json.decode(getRes.body));
      if(response.statusCode >= 400){
        throw('error');
      }
    final riderIndex = _riders.indexWhere((e) => e.id == id);
    _riders[riderIndex] = KekeRider(
      day: _riders[riderIndex].day,
      name: _riders[riderIndex].name,
      paysOn: _riders[riderIndex].paysOn,
      payTimes: _riders[riderIndex].payTimes,
      id: _riders[riderIndex].id,
      payment: _riders[riderIndex].payment+p
    );
  }catch(e){
        
      }
  }

  sendEmail(n, p) async{
    final smtpServer = SmtpServer(
      'smtp-relay.sendinblue.com',
      port: 587,
      username : 'info@topeyankey.com',
      password : '4rAkVyZBINTmYWO1'
    );
    final sendMessage = new Message()
      ..from = Address('noreply@yankeytechnologies.topeyankey.com', 'TopeYankey Logistics')
      ..recipients.add(Address('topeyankeyltd@gmail.com'))
      ..subject = '${n.toUpperCase()} should pay today ${p.toUpperCase()}'
      ..html = "<h1>TODAY IS A PAYMENT DAY</h1>\n<p>${n.toUpperCase()} should to pay today which is a ${p.toUpperCase()}</p>"
    ;
    try {
    final sendReport = await send(sendMessage, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

}