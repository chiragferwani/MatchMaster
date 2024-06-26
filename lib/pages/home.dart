import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchmaster/pages/category_products.dart';
import 'package:matchmaster/pages/match_detail.dart';
import 'package:matchmaster/services/database.dart';
import 'package:matchmaster/services/shared_pref.dart';
import 'package:matchmaster/widgets/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool search = false;

  List categories = [
    "images/cat1.png",
    "images/cat2.png",
    "images/cat3.png",
    "images/cat4.png",
  ];

  List Categoryname = [
    "ICC", 
    "IPL",
    "BBL", 
    "Coupon"
  ];

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchController = new TextEditingController();

  initiateSearch(value){
    if(value.length == 0){
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    
    var CapitalizedValue = value.substring(0,1).toUpperCase()+value.substring(1);
    if(queryResultSet.isEmpty && value.length==1){
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for(int i = 0; i < docs.docs.length; ++i){
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else{
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if(element['UpdatedName'].startsWith(CapitalizedValue)){
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }

  }

  String? name, image;

  getthesharedpref() async{
    name = await SharedPrefrenceHelper().getUserName();
    image = await SharedPrefrenceHelper().getUserImage();
    setState(() {
      
    });
  }

  ontheload() async{
    await getthesharedpref();
    setState(() {
      
    });
  }

  String greetUser() {
  final currentTime = DateTime.now();
  final hour = currentTime.hour;
  if (hour < 12) {
    return 'Morning';
  } else if (hour < 18) {
    return 'Afternoon';
  } else {
    return 'Evening';
  }
}

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f2f2),
      body: name==null? Center(
        child: CircularProgressIndicator()): 
        Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0, bottom: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey, "+ name!,
                        style: AppWidget.boldTextFieldStyle(),
                        ),
                        Text(
                        "Good "+greetUser(),
                        style: AppWidget.lightTextFieldStyle(),
                      ),
                    ],
                  ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "images/logo.png", 
                        height: 70, 
                        width: 70, 
                        fit: BoxFit.cover
                        ),
                    ),
                ],
              ),
              SizedBox(height: 30.0,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(10),
                  ),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    initiateSearch(value.toUpperCase());
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none, 
                    hintText: "Search Matches", 
                    hintStyle: AppWidget.lightTextFieldStyle(),
                    prefixIcon: search? GestureDetector(
                      onTap: (){
                        search = false;
                        tempSearchStore = [];
                        queryResultSet = [];
                        searchController.text = "";
                        setState(() {
                          
                        });
                      },
                      child: Icon(
                        Icons.close, 
                        color: Colors.black,
                        )
                        ): Icon(
                       Icons.search, 
                      color: Colors.black,
                      ),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              search? ListView(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                primary: false,
                shrinkWrap: true,
                children: tempSearchStore.map((element) {
                  return buildResultCard(element);
                }).toList(),
              ): Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Categories",
                          style: AppWidget.semiboldTextFieldStyle(),
                        ),
                      ],
                    ),
                  ),
              SizedBox(height: 20,),
              Row(
                children: [
                    Container(
                      height: 130,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                        color: Color(0XFFFD6F3E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "All",
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 20, 
                            fontFamily: 'sfprodisplay', 
                            fontWeight: FontWeight.bold
                            ),
                            ),
                      ),
                  ),
                  Expanded(
                    child: Container(
                      height: 130,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return CategoryTile(image: categories[index], name: Categoryname[index],);
                      }
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Matches",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),
              Container(
                height: 240,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    //match1
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Image.asset(
                            "images/wcrep.png", 
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,), 
                            Text(
                            "IND VS AFG", 
                            style: AppWidget.semiboldTextFieldStyle(),), 
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("₹99/-", style: TextStyle(
                                  color: Color(0xFFfd6f3e), 
                                  fontSize: 22.0, 
                                  fontWeight: FontWeight.bold, 
                                  fontFamily: 'sfprodisplay'
                                ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: GestureDetector(
                                     onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MatchDetail(
                                        detail: "Get detailed analysis of IND vs AFG, including player stats and conditions. Purchase to receive the match report on your registered email.", 
                                        image: "https://firebasestorage.googleapis.com/v0/b/matchmaster-94765.appspot.com/o/blogImage%2F690N2251r7?alt=media&token=682602e2-7ed4-4edc-91cb-26aa5e31149d", 
                                        name: "IND VS AFG", 
                                        price: "99"
                                        )
                                        )
                                        );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(color: Color(0xFFfd6f3e), borderRadius: BorderRadius.circular(7)),
                                      child: Icon(
                                        Icons.add, 
                                        color: Colors.white,
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ), 
                    //match2
                    Container(
                      margin: EdgeInsets.only(right: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Image.asset(
                            "images/bblrep.png", 
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,), 
                            Text(
                            "ADS VS HBH", 
                            style: AppWidget.semiboldTextFieldStyle(),), 
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("₹49/-", style: TextStyle(
                                  color: Color(0xFFfd6f3e), 
                                  fontSize: 22.0, 
                                  fontWeight: FontWeight.bold, 
                                  fontFamily: 'sfprodisplay'
                                ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MatchDetail(
                                        detail: "Get detailed analysis of ADS VS HBH, including player stats and conditions. Purchase to receive the match report on your registered email.", 
                                        image: "https://firebasestorage.googleapis.com/v0/b/matchmaster-94765.appspot.com/o/blogImage%2F6ETQF8M18W?alt=media&token=faf0cc94-334a-4172-9557-c1e621bd6256", 
                                        name: "ADS VS HBH", 
                                        price: "49"
                                        )
                                        )
                                        );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(color: Color(0xFFfd6f3e), borderRadius: BorderRadius.circular(7)),
                                      child: Icon(
                                        Icons.add, 
                                        color: Colors.white,
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ), 
                    //match3
                    Container(
                      margin: EdgeInsets.only(right: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Image.asset(
                            "images/iplrep.png", 
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,), 
                            Text(
                            "MI VS CSK", 
                            style: AppWidget.semiboldTextFieldStyle(),), 
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("₹149/-", style: TextStyle(
                                  color: Color(0xFFfd6f3e), 
                                  fontSize: 22.0, 
                                  fontWeight: FontWeight.bold, 
                                  fontFamily: 'sfprodisplay'
                                ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MatchDetail(
                                        detail: "Get detailed analysis of MI VS CSK, including player stats and conditions. Purchase to receive the match report on your registered email.", 
                                        image: "https://firebasestorage.googleapis.com/v0/b/matchmaster-94765.appspot.com/o/blogImage%2F7204h5O011?alt=media&token=a9d54f9e-51ce-4356-bfc1-1c8da87e5f91", 
                                        name: "MI VS CSK", 
                                        price: "149"
                                        )
                                        )
                                        );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(color: Color(0xFFfd6f3e), borderRadius: BorderRadius.circular(7)),
                                      child: Icon(
                                        Icons.add, 
                                        color: Colors.white,
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    //match4
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Image.asset(
                            "images/wcrep.png", 
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,), 
                            Text(
                            "AUS VS ENG", 
                            style: AppWidget.semiboldTextFieldStyle(),), 
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("₹49/-", style: TextStyle(
                                  color: Color(0xFFfd6f3e), 
                                  fontSize: 22.0, 
                                  fontWeight: FontWeight.bold, 
                                  fontFamily: 'sfprodisplay'
                                ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MatchDetail(
                                        detail: "Get detailed analysis of AUS vs ENG, including player stats and conditions. Purchase to receive the match report on your registered email.", 
                                        image: "https://firebasestorage.googleapis.com/v0/b/matchmaster-94765.appspot.com/o/blogImage%2F690N2251r7?alt=media&token=682602e2-7ed4-4edc-91cb-26aa5e31149d", 
                                        name: "AUS VS ENG", 
                                        price: "49"
                                        )
                                        )
                                        );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(color: Color(0xFFfd6f3e), borderRadius: BorderRadius.circular(7)),
                                      child: Icon(
                                        Icons.add, 
                                        color: Colors.white,
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ],
              ),
        ),
      ),
    );
  }
  Widget buildResultCard(data){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MatchDetail(
          detail: data["Detail"], 
          image: data["Image"], 
          name: data["Name"], 
          price: data["Price"]
          )));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0, ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 100,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusDirectional.circular(10),
              child: Image.network(
                data["Image"], 
                height: 70, 
                width: 70,
                fit: BoxFit.cover,),
            ), 
            SizedBox(height: 20.0,),
              Text(data["Name"], style: AppWidget.boldTextFieldStyle(),),
          ],
        ),
      ),
    );
  }
}
class CategoryTile extends StatelessWidget {
  String image, name;
  CategoryTile({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryProduct(category: name)));
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image, 
              height: 50, 
              width: 50, 
              fit: BoxFit.cover,),
              SizedBox(height: 10,),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }


}