import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wakul2/form/login.dart';
import 'package:wakul2/home/navbar/navbar.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseAuthService extends GetxController {
  final isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final box = GetStorage();
  final errorMessage = ''.obs;
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> registrasi({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        Get.snackbar(
          'Register Status',
          'Email atau Password yang anda masukkan kosong.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      isLoading.value = true;

      var status = await Permission.location.request();
      if (status.isDenied) {
        isLoading.value = false;

        Get.snackbar(
          'Status Error',
          'Permission to access location is denied.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        Position position = await Geolocator.getCurrentPosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        String uid = userCredential.user!.uid;
        await firestore.collection("users").doc(uid).set(
          {
            "uid": uid,
            "username": username,
            "email": email,
            "createdAt": DateTime.now().toIso8601String(),
            "roles": "customer",
            "location": {
              "latitude": position.latitude,
              "longitude": position.longitude,
            },
            "address":
                "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}"
          },
        );
        isLoading.value = false;

        // errorMessage.value = 'Registration Succesful. Anda Bisa Login Sekarang';
        Get.snackbar(
          'Registration Status',
          'Registrasi Berhasil. Anda Bisa Login Sekarang',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        Get.to(() => const LoginPage());
      } else {
        isLoading.value = false;

        Get.snackbar(
          'Registration Status',
          'Registrasi gagal. tolong ulangi lagi.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          Get.snackbar(
            'Registration Status',
            'Email sudah digunakan. Tolong gunakan Email lain.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Registration Status',
            'Registration failed due to an exception: $e',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Registration Status',
          'Unexpected error during registration: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> login({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        // errorMessage.value = 'Email atau Password yang anda masukkan kosong.';
        // print(errorMessage.value);
        Get.snackbar(
          'Login Status',
          'Email atau Password yang anda masukkan kosong.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      isLoading.value = true;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(userCredential);

      if (userCredential.user != null) {
        isLoading.value = false;
        // Save the user token to GetStorage if needed
        // box.write('token', userCredential.user!.uid);

        Get.offAll(() => const CustomNavBar());
      } else {
        isLoading.value = false;
        // errorMessage.value = 'Login gagal. Periksa kredensial Anda.';
        // print(errorMessage.value);
      }
    } catch (e) {
      isLoading.value = false;
      // errorMessage.value = 'Terjadi Kealahan, anda tidak dapat Login';
      // print(errorMessage.value);
    }
  }
}
