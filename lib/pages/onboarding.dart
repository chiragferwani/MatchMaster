import 'package:flutter/material.dart';
import 'package:matchmaster/Admin/admin_login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  @override
  State<Onboarding> createState() => _OnboardingState();
}
class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 235, 231),
      body: Container(
        margin: EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Center(child: Image.asset("images/logo.png")),
            Center(
              child: Text(
                "Match Master", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 35.0, 
                  fontFamily: 'sfprodisplay',
                  fontWeight: FontWeight.bold
                  ),
                  ),
            ),
            SizedBox(height: 100.0,),
            Center(
              child: Text(
                "Analyze Cricket Easily!", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 25.0, 
                  fontFamily: 'sfprodisplay',
                  fontWeight: FontWeight.bold
                  ),
                  ),
            ),
            SizedBox(height: 100.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminLogin()));
                    },
                    child: Container(
                          width: MediaQuery.of(context).size.width/3,
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 234, 235, 231), 
                            borderRadius: BorderRadius.circular(10), 
                            border: Border.all(width: 5)
                          ),
                          child: Center(
                            child: Text(
                              "NEXT", 
                              style: TextStyle(
                                color: Colors.black, 
                                fontSize: 20.0, 
                                fontFamily: 'sfprodisplay', 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        
                        ),
                  ),
                    
                ),
                
              ],
            )
          ],
          ),
          ),
    );
  }
}