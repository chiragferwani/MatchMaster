import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:matchmaster/pages/bottomnav.dart';
import 'package:matchmaster/pages/login.dart';
import 'package:matchmaster/services/database.dart';
import 'package:matchmaster/services/shared_pref.dart';
import 'package:matchmaster/widgets/support_widget.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String? name, email, password;

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  regestration()async{
    if(password!=null && name!=null && email!=null){
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            "Registered Successfully", 
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0, 
                  fontFamily: 'sfprodisplay', 
                  fontWeight: FontWeight.bold
                ),
              )
            )
          );
          String Id = randomAlphaNumeric(10);
          await SharedPrefrenceHelper().saveUserEmail(mailcontroller.text);
          await SharedPrefrenceHelper().saveUserId(Id);
          await SharedPrefrenceHelper().saveUserName(namecontroller.text);
          await SharedPrefrenceHelper().saveUserImage("https://ibb.co/ZVYMp8V");
          Map<String, dynamic> userInfoMap = {
            "Name": namecontroller.text, 
            "Email": mailcontroller.text,
            "Id": Id,
            "Image": "https://ibb.co/ZVYMp8V"
          };
          await DatabaseMethods().addUserDetails(userInfoMap, Id);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNav()));
      } on FirebaseException catch(e){
        if(e.code == 'weak-password'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Enter Strong Password", 
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
        else if(e.code == 'email-already-in-use'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Account already exists. Login", 
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
                SizedBox(height: 10,),
                Center(
                  child: Text(
                    "Sign Up", 
                    style: AppWidget.boldTextFieldStyle(),
                    ),
                ),
                SizedBox(height: 5.0,),
                Center(
                  child: Text(
                    "Please enter the details", 
                    style: AppWidget.lightTextFieldStyle(),
                    ),
                ), 
                SizedBox(height: 20.0,),
                Text(
                  "Name", 
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
                        return 'Please Enter Your Name';
                      }
                      else{
                        return null;
                      }
                    },
                  controller: namecontroller,
                  decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Name"),
                  ),
                ),
                SizedBox(height: 10.0,),
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
                SizedBox(height: 10.0,),
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
                SizedBox(height: 20,), 
                GestureDetector(
                  onTap: (){
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        name = namecontroller.text;
                        email = mailcontroller.text;
                        password = passwordcontroller.text;
                      });
                    }
                    regestration();
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
                          "SIGN UP", 
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
                SizedBox(height: 10.0,), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                    style: TextStyle(
                        color: Colors.black54, 
                        fontSize: 18.0, 
                        fontWeight: FontWeight.bold, 
                        fontFamily: 'sfprodisplay'
                      ),),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> LogIn()));
                        },
                        child: Text(
                        "Log In",
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