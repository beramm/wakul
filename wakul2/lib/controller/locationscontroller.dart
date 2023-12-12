import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LocationController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updatePositioned(LatLng position) async {
    try {
      User? user = auth.currentUser;

      if (user != null) {
        String uid = user.uid;
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        String address =
            "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}";

        await firestore.collection("users").doc(uid).update({
          "location": {
            "latitude": position.latitude,
            "longitude": position.longitude,
          },
          "address": address,
        });
        Get.snackbar(
          'Location Updated',
          'Lokasi Anda Berhasil disimpan!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        print("User is null");
      }
    } catch (e) {
      print("Error updating location: $e");
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamLokasi() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("users").doc(uid).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getLocation() async {
    String uid = auth.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection("users").doc(uid).get();

    return snapshot;
  }
}
