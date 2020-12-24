import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/single_data.dart';
import './model/keke_rider.dart';
import './model/payment.dart';

import './screens/search_form.dart';
import './screens/result.dart';
import './screens/multiple_result.dart';
import './screens/payment_screen.dart';
import './screens/add_rider.dart';
import './screens/detail_rider.dart';
import './screens/add_payment.dart';
import './screens/notifi.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;

void callbackDispatcher(){
  Workmanager.executeTask((taskName, inputData) async{
    // DO something
  final response = await http.get('https://keke-riders.firebaseio.com/riders.json');
  
  Map riders = json.decode(response.body) as Map<String, dynamic>;
    if (riders.length > 0) {
      final smtpServer = SmtpServer(
            'in-v3.mailjet.com',
            port: 587,
            username : 'f35b809921d73bd2ff7cccb52236a128',
            password : 'd67740db89327612471f24e42246f775'
        );
      riders.forEach((k, v) async{ 
        if (v['paysOn'].toUpperCase() == DateFormat('EEEE').format(DateTime.now()).toUpperCase() ) {
          const AndroidNotificationDetails androidPlatformChannelSpecifics =
              AndroidNotificationDetails(
                  'your channel id', 'your channel name', 'your channel description',
                  importance: Importance.max,
                  priority: Priority.high,
                  showWhen: false);
          const NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.show(
              0, 'PAYMENT TODAY', '${v['name']} should pay today', platformChannelSpecifics,
              payload: k);
          final sendMessage = new Message()
            ..from = Address('info@topeyankey.com', 'TopeYankey Logistics')
            ..recipients.add(Address('topeyankeyltd@gmail.com'))
            ..subject = '${v['name'].toUpperCase()} should pay today ${v['paysOn'].toUpperCase()}'
            ..html = "<h1>TODAY IS A PAYMENT DAY</h1>\n<p>${v['name'].toUpperCase()} should to pay today which is a ${v['paysOn'].toUpperCase()}</p>"
          ;
          try {
            print('hello');
            final sendReport = await send(sendMessage, smtpServer);
            print('Message sent: ' + sendReport.toString());
          } on MailerException catch (e) {
            print('Message not sent.');
            for (var p in e.problems) {
              print('Problem: ${p.code}: ${p.msg}');
            }
          }
        }else if(v['paysOn'].toUpperCase() == DateFormat('EEEE').format(DateTime.now().add(new Duration(days: 1))).toUpperCase()){
          const AndroidNotificationDetails androidPlatformChannelSpecifics =
              AndroidNotificationDetails(
                  'your channel id', 'your channel name', 'your channel description',
                  importance: Importance.max,
                  priority: Priority.high,
                  showWhen: false);
          const NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.show(
              0, 'TOMORROW', '${v['name']} will pay tomorrow', platformChannelSpecifics,
              payload: k);
        }
        
      });
    }
    return Future.value(true);
  });
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async{
  var deLay = 0;
  final hours = int.parse(DateFormat('H').format(DateTime.now()));
  final minutes = int.parse(DateFormat('m').format(DateTime.now()));
  final seconds = int.parse(DateFormat('s').format(DateTime.now()));
  final time = (hours*3600)+(minutes*60)+seconds;
  if (time < 39600) {
    deLay = 39600-time;
  } else {
    final j = 86400 - time;
    deLay = j+39600;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(
    callbackDispatcher,
    // isInDebugMode: true
    );
  await Workmanager.registerPeriodicTask(
    '1uy1ab9s9', 
    'dawi3a8s2s22ab', 
    frequency: Duration(days: 1),
    initialDelay: Duration(seconds: 10)
    );
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: (payload) async{
    if (payload != null) {
      navigatorKey.currentState.pushReplacement(
        MaterialPageRoute(builder: (_) => Notifi(idi: payload,))
      );
        }
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => KekeRider()),
            ChangeNotifierProvider(create: (context) => Payment()),
            ChangeNotifierProvider(create: (context) => SingleData()),
          ],
          child: MaterialApp(
          navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
        routes: {
          Result.routeName: (ctx) => Result(),
          MultipleResult.routeName: (ctx) => MultipleResult(),
          PaymentList.routeName: (ctx) => PaymentList(),
          AddRider.routeName: (ctx) => AddRider(),
          DetailRider.routeName: (ctx) => DetailRider(),
          AddPayment.routeName: (ctx) => AddPayment(),
          Notifi.routeName: (ctx) => Notifi()
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String serverToken = 'AAAAAU5msZc:APA91bHeyOY69PaEu2QOVFg-fRC0SdVK16bKyr-l5IWFREbdCKW9Jrhc7DByMcKogAIx610-lDTVNLmJJIWK7fjcAxqy66eoTiVV17T28JNsGsivhvgs5LplH6LcS9iBTfUAUxbYfnlF';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    // Workmanager.cancelAll();
    final deviceSize = MediaQuery.of(context).size;
    final fontsize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Distance Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.list), 
            iconSize: 32,
            onPressed: 
            () { 
              Navigator.of(context).pushReplacementNamed('/paymentlist');
              }
            )
        ],
      ),
      body: SearchForm(deviceSize, fontsize)
    );
  }
}

