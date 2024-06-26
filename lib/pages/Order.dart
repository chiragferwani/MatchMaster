import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/support_widget.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}
  
  String? value;
  final List<String> categoryitem = [
    'ICC','IPL','BBL','Coupon'
  ];

class _OrderState extends State<Order> {

  String? matchname, username, upi;

  TextEditingController matchnamecontroller = new TextEditingController();
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController upicontroller = new TextEditingController();

  main() async {
  // Note that using a username and password for gmail only works if
  // you have two-factor authentication enabled and created an App password.
  // Search for "gmail app password 2fa"
  // The alternative is to use oauth.
  String username = 'chiragferwani@gmail.com';
  String password = 'Enter your app key';

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.  

  // Create our message.
  final message = Message()
    ..from = Address(username, usernamecontroller.text)
    ..recipients.add('ferwanichirag@gmail.com')
    ..recipients.add('siddheshgundalkar@gmail.com')
    ..subject = 'Order Details'
    ..text = "UserName: "+ usernamecontroller.text +"\nMatch Name Needed: "+ matchnamecontroller.text + "\nUPI ID:"+ upicontroller.text;

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
  // DONE
  //
  // Create a smtp client that will persist the connection
  var connection = PersistentConnection(smtpServer);

  // Send the first message
  await connection.send(message);

  // close the connection
  await connection.close();
}

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, top: 50.0, right: 20.0, bottom: 20.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Center(
                 child: Text(
                          "Place Order",
                          style: AppWidget.boldTextFieldStyle(),
                          ),
               ),
                SizedBox(height: 20.0,),
                Center(
                  child: Text(
                    "Scan QR Code",
                    style: AppWidget.semiboldTextFieldStyle(),),
                ),
                SizedBox(height: 20.0,),
                Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5), 
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "images/sidqr.png", 
                        height: 100, 
                        width: 100, 
                        fit: BoxFit.cover
                        ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Text(
                    "Match Name",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: matchnamecontroller,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Match Name", hintStyle: AppWidget.lightTextFieldStyle()),
                    ),
                  ), 
                  SizedBox(height: 20.0,),
                  Text(
                    "Username",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: usernamecontroller,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Username", hintStyle: AppWidget.lightTextFieldStyle()),
                    ),
                  ), 
                  SizedBox(height: 20.0,),
                  Text(
                    "UPI ID",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: upicontroller,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Enter UPI ID", hintStyle: AppWidget.lightTextFieldStyle()),
                    ),
                  ), 
                   SizedBox(height: 30.0,),
                Center(
                  child: ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        width: 1.5, 
                        color: Colors.black,
                        
                      )
                    ),
                    onPressed: (){
                      matchname = matchnamecontroller.text;
                      username = usernamecontroller.text;
                      upi = upicontroller.text;
                      main();
                      if(matchname!="" && upi!="" && username!=""){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.greenAccent,
                        content: Text(
                          "Order Placed Successfully!", 
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0, 
                                fontFamily: 'sfprodisplay', 
                                fontWeight: FontWeight.bold
                              ),
                            )
                          )
                        );
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text(
                          "Please Enter Details!", 
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0, 
                                fontFamily: 'sfprodisplay', 
                                fontWeight: FontWeight.bold
                              ),
                            )
                          )
                        );
                      }
                    }, 
                    child: Text(
                      "Order Now", 
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'sfprodisplay',
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                      )
                  ),
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}