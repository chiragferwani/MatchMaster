import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchmaster/pages/bottomnav.dart';
import 'package:matchmaster/pages/signup.dart';
import 'package:matchmaster/widgets/support_widget.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  String email = "";
  String password = "";

  TextEditingController mailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            "Log In Successful", 
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0, 
                  fontFamily: 'sfprodisplay', 
                  fontWeight: FontWeight.bold
                ),
              )
            )
          );
      Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNav()));
    } on FirebaseException catch(e){
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "User Not Found", 
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
      else if(e.code == 'wrong--password'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Incorrect Password", 
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 40.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/login.png"), 
                SizedBox(height: 20,),
                Center(
                  child: Text(
                    "Sign In", 
                    style: AppWidget.boldTextFieldStyle(),
                    ),
                ),
                SizedBox(height: 10.0,),
                Center(
                  child: Text(
                    "Please enter the details", 
                    style: AppWidget.lightTextFieldStyle(),
                    ),
                ), 
                SizedBox(height: 40.0,),
                Text(
                  "Email", 
                style: AppWidget.boldTextFieldStyle(),
                ), 
                SizedBox(height: 10.0,),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F5F9), 
                    borderRadius: BorderRadius.circular(10)
                    ),
                  child: TextFormField(
                  validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Please Enter Your Email Id';
                      }
                      else{
                        return null;
                      }
                    },
                  controller: mailcontroller,
                  decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Email Id"),
                  ),
                ),
                SizedBox(height: 20.0,),
                Text(
                  "Password", 
                style: AppWidget.boldTextFieldStyle(),
                ), 
                SizedBox(height: 10.0,),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F5F9), 
                    borderRadius: BorderRadius.circular(10)
                    ),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Please Enter Your Password';
                      }
                      else{
                        return null;
                      }
                    },
                    controller: passwordcontroller,
                  decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Password"),
                  ),
                ),
                SizedBox(height: 30,), 
                GestureDetector(
                  onTap: (){
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        email = mailcontroller.text;
                        password = passwordcontroller.text;
                      });
                    }
                    userLogin();
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width/3,
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Color(0xFFfd6f3e), 
                        borderRadius: BorderRadius.circular(10), 
                      ),
                      child: Center(
                        child: Text(
                          "LOGIN", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 18.0, 
                            fontFamily: 'sfprodisplay', 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0,), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                    style: TextStyle(
                        color: Colors.black54, 
                        fontSize: 18.0, 
                        fontWeight: FontWeight.bold, 
                        fontFamily: 'sfprodisplay'
                      ),),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                        },
                        child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xFFfd6f3e), 
                          fontSize: 18.0, 
                          fontWeight: FontWeight.bold, 
                          fontFamily: 'sfprodisplay'
                        ),),
                      ),
                    
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}