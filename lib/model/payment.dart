import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Payment with ChangeNotifier{
  final int amount;
  final DateTime date;
  final String owner;

  Payment({
    this.amount,
    this.date,
    this.owner,
  });

  List<Payment> _payments = [];
  List<Payment> get payments{
    return [..._payments];
  }
  int get paymentlength{
    return _payments.length-1;
  }

  lastPayment(a){
    if (_payments.length > 0) {
      List b = [];
      _payments.forEach((element) { 
        if (element.owner == a) {
          b.add(element);
        }
        if (b.length == 0) {
          return null;
        } else{
          return b[b.length-1];
        }
      });
    }else{
      return null;
    }

  }

  Future addPayment(int p, String name) async{
    final url = 'https://keke-riders.firebaseio.com/payments.json';
    try{
      final response = await http.post(url,
        body: json.encode({
          'amount':p,
          'date': DateTime.now().toIso8601String(),
          'owner': name
        })
      );
      if(response.statusCode >= 400){
        print(response.statusCode);
        throw('errorla');
      }
    final payment = Payment(
      amount: p, 
      date: DateTime.now(), 
      owner: name,
      );
    _payments.add(payment);
    }catch(error){
      throw(error);
    }
  }

  fetchpayments(String id){
    List pays = [];
    _payments.forEach((element) {
      if(element.owner == id) {
        pays.add(element);
      }
    });
    return [...pays.reversed];
  }

  Future<void> setPayments() async{
    final url = 'https://keke-riders.firebaseio.com/payments.json';
    try{
      final response = await http.get(url);
      if (response.statusCode >= 400){
        throw('errorla');
      }
      Map payments = json.decode(response.body) as Map<String, dynamic>;
      if(payments == null){
        return;
      }
      final List<Payment> loadedPayments= [];
      payments.forEach((k, v) {
        loadedPayments.add(Payment(
          amount: v['amount'],
          owner: v['owner'],
          date: DateTime.parse(v['date'])
        ));
      });
      _payments = loadedPayments;
    }catch(e){
      throw(e);
    }
  }
}