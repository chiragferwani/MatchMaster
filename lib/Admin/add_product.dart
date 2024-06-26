import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matchmaster/Admin/admin_login.dart';
import 'package:matchmaster/services/database.dart';
import 'package:matchmaster/widgets/support_widget.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController pricecontroller = new TextEditingController();
  TextEditingController detailcontroller = new TextEditingController();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {
      
    });
  }

  uploadItem()async{
    if(selectedImage!=null && namecontroller.text != ""){
      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImage").child(addId);
      
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      String firstletter = namecontroller.text.substring(0,1).toUpperCase();

      Map<String, dynamic> addProduct = {
        "Name": namecontroller.text, 
        "Image": downloadUrl, 
        "SearchKey": firstletter, 
        "UpdatedName": namecontroller.text.toUpperCase(),
        "Price": pricecontroller.text, 
        "Detail": detailcontroller.text,

      };

      await DatabaseMethods().addProduct(addProduct, value!).then((value) async{
        
        await DatabaseMethods().addAllProducts(addProduct);

        selectedImage = null;
        namecontroller.text = "";
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            "Match Added Successfully!", 
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0, 
                  fontFamily: 'sfprodisplay', 
                  fontWeight: FontWeight.bold
                ),
              )
            )
          );
      });

    }
  }

  String? value;
  final List<String> categoryitem = [
    'ICC','IPL','BBL','Coupon'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined
            ),
        ),
        title: Text("Add Matches", style: AppWidget.semiboldTextFieldStyle(),
        )),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Upload Match Report Image",
                  style: AppWidget.semiboldTextFieldStyle(),),
              ),
              SizedBox(height: 20.0,),
              selectedImage==null? GestureDetector(
                onTap: (){
                  getImage();
                },
                child: Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5), 
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.camera_alt_outlined, size: 40,),
                  ),
                ),
              ): Center(
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5), 
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          selectedImage!, 
                          fit: BoxFit.cover,
                          )
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
                  child: TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Match Name", hintStyle: AppWidget.lightTextFieldStyle()),
                  ),
                ), 
                SizedBox(height: 20.0,),
                Text(
                  "Match Report Price",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                SizedBox(height: 15.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: pricecontroller,
                    decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Match Price", hintStyle: AppWidget.lightTextFieldStyle()),
                  ),
                ), 
                SizedBox(height: 20.0,),
                Text(
                  "Match Category",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFFececf8), 
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: categoryitem.map((item) => DropdownMenuItem(value: item, child: Text(item, style: AppWidget.semiboldTextFieldStyle(),))).toList(), onChanged: ((value)=> setState(() {
                      this.value = value;
                    })),
                    dropdownColor: Colors.white,
                    hint: Text("Select Category", style: AppWidget.lightTextFieldStyle(),),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                    value: value,
                                ),
                  ),
              ),
              SizedBox(height: 20.0,),
                Text(
                  "Match Details",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                SizedBox(height: 15.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    maxLines: 6,
                    controller: detailcontroller,
                    decoration: InputDecoration(border: InputBorder.none, hintText: "Enter Match Details", hintStyle: AppWidget.lightTextFieldStyle()),
                  ),
                ),  
              SizedBox(height: 30.0,),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      width: 1.5, 
                      color: Colors.black
                    )
                  ),
                  onPressed: (){
                    uploadItem();
                  }, 
                  child: Text(
                    "Add Match", 
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
    );
  }
}