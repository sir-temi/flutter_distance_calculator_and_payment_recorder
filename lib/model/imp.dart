import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() async{
  final smtpServer = SmtpServer(
      'in-v3.mailjet.com',
      port: 587,
      username : 'f35b809921d73bd2ff7cccb52236a128',
      password : 'd67740db89327612471f24e42246f775'
  );
  final sendMessage = new Message()
    ..from = Address('info@topeyankey.com', 'TopeYankey Logistics')
    ..recipients.add(Address('topeyankeyltd@gmail.com'))
    ..subject = 'hi'
    ..html = "<h1>TODAY IS A PAYMENT DAY</h1>"
  ;
  print('hi');
  try {
    final sendReport = await send(sendMessage, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
  print('done');
}