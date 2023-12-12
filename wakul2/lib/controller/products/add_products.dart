import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController priceController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addProduct(String name, int price) async {
    CollectionReference products = firestore.collection("products");

    try {
      await products.add({
        "name": name,
        "price": price,
      });
    } catch (e) {
      Get.defaultDialog(
        title: "Error",
        middleText: "Tidak Berhasil menambahkan product",
        onConfirm: () => Get.back(),
        textConfirm: "Okay",
      );
    }

    Get.defaultDialog(
      title: "Berhasil",
      middleText: "Berhasil Menambahkan produk",
      onConfirm: () => Get.back(),
      textConfirm: "Okay",
    );
  }

  @override
  void onInit() {
    nameController = TextEditingController();
    priceController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
