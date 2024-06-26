import 'package:flutter/material.dart';

class AppWidget{
  static TextStyle boldTextFieldStyle(){
    return TextStyle(
                color: Colors.black,
                fontSize: 27.0, 
                fontWeight: FontWeight.bold, 
                fontFamily: 'sfprodisplay'
              );
  }
  static TextStyle lightTextFieldStyle(){
    return TextStyle(
                  color: Colors.black54, 
                  fontSize: 20.0, 
                  fontFamily: 'sfprodisplay', 
                  fontWeight: FontWeight.w500
                );
  }

  static TextStyle semiboldTextFieldStyle(){
    return TextStyle(
                  color: Colors.black, 
                  fontSize: 20.0, 
                  fontFamily: 'sfprodisplay', 
                  fontWeight: FontWeight.bold
                );
  }

}