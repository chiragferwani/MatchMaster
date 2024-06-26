import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchmaster/Admin/add_product.dart';
import 'package:matchmaster/pages/login.dart';
import 'package:matchmaster/widgets/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/login.png"), 
              SizedBox(height: 10,),
              Center(
                child: Text(
                  "Admin Panel", 
                  style: AppWidget.boldTextFieldStyle(),
                  ),
              ),
              SizedBox(height: 20.0,), 
              Text(
                "Username", 
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
                controller: usernamecontroller,
                decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Username"),
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
                  controller: userpasswordcontroller,
                decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Password"),
                ),
              ),
              SizedBox(height: 40,), 
              GestureDetector(
                onTap: (){
                  loginAdmin();
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
              SizedBox(height: 10.0,),  
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Are you a User? ",
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
    );
  }
  loginAdmin(){
  FirebaseFirestore.instance.collection("Admin").get().then((snapshot){
    snapshot.docs.forEach( (result){
      if(result.data()['username']!= usernamecontroller.text.trim()){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Incorrect Id", 
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
      else if(result.data()['password']!= userpasswordcontroller.text.trim()){
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
      else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProduct()));
      }
    });
  });
  }
}
