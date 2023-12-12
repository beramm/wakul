import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wakul2/Data/kategori.dart';
import 'package:wakul2/Data/makanan.dart';
import 'package:wakul2/controller/products/products.dart';
import 'package:wakul2/home/detail_screen_makanan.dart';

class DetailScreenCategory extends StatelessWidget {
  final kategori;
  final Map<String, dynamic> data;

  const DetailScreenCategory(
      {Key? key, required this.kategori, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatCurrency = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.network(
                    data["bannerImageUrls"]["banner2"],
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(
                              Icons.local_grocery_store_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Text(
                  data["name"],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 26.0,
                    fontFamily: 'Staatliches',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Object?>>(
                stream: MakananController().streamDataByCategory(kategori),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return CircularProgressIndicator(); // or any other loading indicator
                  }
                  var listAllMakanan = snapshot.data!.docs;

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot<Map<String, dynamic>> document =
                          listAllMakanan[index]
                              as DocumentSnapshot<Map<String, dynamic>>;

                      final Map<String, dynamic> data = document.data()!;
                      // final Makanan makan = makananlaceList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DetailScreenFood(
                              pangan: data,
                            );
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 10.0, right: 10, bottom: 5),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    (listAllMakanan[index].data()
                                        as Map<String, dynamic>)["imageUrls"],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        (listAllMakanan[index].data()
                                            as Map<String, dynamic>)["name"],
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: listAllMakanan.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
