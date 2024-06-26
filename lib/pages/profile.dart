import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matchmaster/pages/login.dart';
import 'package:matchmaster/pages/onboarding.dart';
import 'package:matchmaster/services/auth.dart';
import 'package:matchmaster/services/shared_pref.dart';
import 'package:matchmaster/widgets/support_widget.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String? image, name, email;

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getthesharedpref() async{
    image = await SharedPrefrenceHelper().getUserImage();
    name = await SharedPrefrenceHelper().getUserName();
    email = await SharedPrefrenceHelper().getUserEmail();
    setState(() {
      
    });
  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadItem();
    setState(() {
      
    });
  }

  uploadItem()async{
    if(selectedImage!=null){
      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImage").child(addId);
      
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPrefrenceHelper().saveUserImage(downloadUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xfff2f2f2),
        title: Text(
          "Profile",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      backgroundColor: Color(0xfff2f2f2),
      body: name==null? Center(
        child: CircularProgressIndicator()): 
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              selectedImage!=null? GestureDetector(
                onTap: (){
                  getImage();
                },
                child: Center(
                  child: Container(
                    height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2.0), 
                            borderRadius: BorderRadius.circular(20),
                          ),
                    child: ClipRRect(
                      borderRadius: BorderRadiusDirectional.circular(20),
                      child: Image.file(
                        selectedImage!, 
                        height: 150,
                        width: 150,
                      )
                    ),
                  ),
                ),
              ): 
              GestureDetector(
                onTap: (){
                  getImage();
                },
                child: Center(
                  child: Container(
                    height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2.0), 
                            borderRadius: BorderRadius.circular(20),
                          ),
                    child: ClipRRect(
                      borderRadius: BorderRadiusDirectional.circular(20),
                      child: Icon(Icons.person, size: 60,)
                    ),
                  ),
                ),
              ), 
              SizedBox(height: 20.0,),
              //
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person_2_outlined, size: 35.0,),
                        SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name", 
                            style: AppWidget.semiboldTextFieldStyle(),
                            ), 
                            Text(name!, 
                            style: AppWidget.semiboldTextFieldStyle(),
                            ), 
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ), 
              SizedBox(height: 20.0,),
              //
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.mail_outlined, size: 35.0,),
                        SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email", 
                            style: AppWidget.semiboldTextFieldStyle(),
                            ), 
                            Text(email!, 
                            style: AppWidget.semiboldTextFieldStyle(),
                            ), 
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ), 
              SizedBox(height: 20.0,),
              //
              GestureDetector(
                onTap: ()async{
                  await AuthMethods().SignOut().then((value) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogIn()));
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 35.0,),
                          SizedBox(width: 10.0,),
                          Text("Log Out", style: AppWidget.semiboldTextFieldStyle(),), 
                          Spacer(),
                          Icon(Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
              ), 
              SizedBox(height: 20.0,),
              GestureDetector(
                onTap: ()async{
                  await AuthMethods().deleteuser().then((value) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Onboarding()));
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 35.0,),
                          SizedBox(width: 10.0,),
                          Text("Delete Account", style: AppWidget.semiboldTextFieldStyle(),), 
                          Spacer(),
                          Icon(Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        ),
    );
  }
}