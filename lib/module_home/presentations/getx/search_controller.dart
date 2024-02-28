import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchContactController extends GetxController {
  late TextEditingController searchController;

  var firstData = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firebase = FirebaseFirestore.instance;

  void searchContact(String data, String email) async {
    print("SEARCH : $data");

    if (data.length == 0) {
      firstData.value = [];
      tempSearch.value = [];
    } else {
      var capitalized = data.substring(0, 1).toUpperCase() + data.substring(1);
      print(capitalized);

      if (firstData.length == 0 && data.length == 1) {
        // fungsi yang akan dijalankan pada 1 huruf ketikan pertama
        CollectionReference users = await firebase.collection("users");
        final keyNameResult = await users
            .where("keyName", isEqualTo: data.substring(0, 1).toUpperCase())
            .where("email", isNotEqualTo: email)
            .get();

        print("TOTAL DATA : ${keyNameResult.docs.length}");
        if (keyNameResult.docs.length > 0) {
          for (int i = 0; i < keyNameResult.docs.length; i++) {
            firstData.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }
          print("QUERY RESULT : ");
          print(firstData);
        } else {
          print("TIDAK ADA DATA");
        }
      }

      if (firstData.length != 0) {
        tempSearch.value = [];
        firstData.forEach((element) {
          if (element["name"].startsWith(capitalized)) {
            tempSearch.add(element);
          }
        });
      }
    }

    firstData.refresh();
    tempSearch.refresh();
  }
}
