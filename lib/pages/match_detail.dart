import 'package:flutter/material.dart';
import 'package:matchmaster/pages/Order.dart';
import 'package:matchmaster/pages/bottomnav.dart';
import 'package:matchmaster/widgets/support_widget.dart';

class MatchDetail extends StatefulWidget {
  String image, name, detail, price;
  MatchDetail({required this.detail, required this.image, required this.name, required this.price});

  @override
  State<MatchDetail> createState() => _MatchDetailState();
}

class _MatchDetailState extends State<MatchDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFfef5f1),
      body: Container(
        padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [ GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(30)),
                  child: Icon(
                    Icons.file_copy_outlined
                  ),
                  ),
              ),
              Center(
                child: Image.network(
                  widget.image, 
                  height: 400,
                  ),
                ), 
              ]
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), 
                    topRight: Radius.circular(20)
                    ),
                ),
                width: MediaQuery.of(context).size.width,
                child: 
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.name, 
                            style: AppWidget.boldTextFieldStyle(),
                            ),
                            Text(
                            "\₹"+widget.price+"/-",
                            style: TextStyle(
                              color: Color(0xFFfd6f3e), 
                              fontSize: 23.0, 
                              fontWeight: FontWeight.bold, 
                              fontFamily: 'sfprodisplay'
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0,),
                      Text("Details", style: AppWidget.semiboldTextFieldStyle(),), 
                      SizedBox(height: 10.0,),
                      Text(widget.detail, 
                      style: AppWidget.lightTextFieldStyle(), textAlign: TextAlign.justify,),
                      SizedBox(height: 35.0,),
                      GestureDetector(
                        onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Order()));
                          },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFfd6f3e),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "Buy Now", 
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 20.0, 
                              fontWeight: FontWeight.bold, 
                              fontFamily: 'sfprodisplay'
                            ),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}