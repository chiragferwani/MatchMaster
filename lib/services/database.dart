import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchmaster/Admin/add_product.dart';

class DatabaseMethods{

  Future addUserDetails(Map<String, dynamic> userInfoMap, String id)async{
    return await FirebaseFirestore.instance
    .collection("users")
    .doc(id)
    .set(userInfoMap);
  }

  Future addAllProducts(Map<String, dynamic> userInfoMap)async{
    return await FirebaseFirestore.instance
    .collection("Products")
    .add(userInfoMap);
  }

  Future addProduct(Map<String, dynamic> userInfoMap, String categoryname)async{
    return await FirebaseFirestore.instance
    .collection(categoryname)
    .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getProducts(String category) async{
    return await FirebaseFirestore.instance
    .collection(category)
    .snapshots();
  }

  Future<QuerySnapshot> search(String UpdatedName) async{
    return await FirebaseFirestore.instance.collection("Products").where("SearchKey", isEqualTo: UpdatedName.substring(0,1).toUpperCase()).get();
  }

}
