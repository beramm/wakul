import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wakul2/Data/makanan.dart';
import 'package:wakul2/controller/locationscontroller.dart';
import 'package:wakul2/controller/users/userController.dart';
import 'package:wakul2/home/detail_screen_makanan.dart';
import 'package:wakul2/test2.dart';
import 'package:intl/intl.dart';

class MenuPembayaran extends StatefulWidget {
  final Map<String, dynamic> pangan;
  const MenuPembayaran({Key? key, required this.pangan}) : super(key: key);

  @override
  State<MenuPembayaran> createState() => _MenuPembayaranState();
}

class _MenuPembayaranState extends State<MenuPembayaran> {
  Position? currentPosition;
  String address = "";
  List<Placemark> lokasi = [];
  LatLng? point;
  Placemark? firstPlacemark;
  TextEditingController? textEditingController;
  int count = 1;
  var formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

  getCurrentPosition() async {
    Position position = await determite();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      point = LatLng(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        firstPlacemark = placemarks.first;
      }
    });
  }

  Future<Position> determite() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreenFood(
                        pangan: widget.pangan,
                      ),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.amber,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text('Konfirmasi Pembayaran'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Alamat Pengiriman',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LokasiState(),
                                ),
                              );
                            },
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: UserController().getUsername(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.hasData) {
                              Map<String, dynamic>? user =
                                  snapshot.data!.data();
                              return Text(
                                '${user?['username']}',
                                style: TextStyle(fontSize: 10),
                              );
                            } else {
                              return const Text(
                                'Anonymus',
                                style: TextStyle(fontSize: 10),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                            stream: LocationController().streamLokasi(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Text('...');
                              }
                              Map<String, dynamic> userData =
                                  snapshot.data!.data()!;

                              String userAddress = userData['address'];

                              return Text(
                                userAddress,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                widget.pangan["imageUrls"],
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.pangan["name"],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontFamily: 'Staatliches',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatCurrency
                                  .format(widget.pangan["price"] * count),
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Staatliches',
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                CountdownWidget(
                                  pangan: widget.pangan,
                                  onCountChanged: (newCount) {
                                    setState(() {
                                      count = newCount;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.list_alt_outlined,
                              size: 30,
                            ),
                            Text(
                              'Point',
                              style: TextStyle(fontSize: 18),
                            ),
                            Spacer(),
                            Text(
                              '35000',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Catatan:'),
                            const Spacer(),
                            Expanded(
                              child: TextField(
                                controller: textEditingController,
                                decoration: const InputDecoration(
                                  labelText: 'Masukkan catatan tambahan',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Total Pesanan ($count Makanan): '),
                            const Spacer(),
                            Text(
                              formatCurrency
                                  .format(widget.pangan["price"] * count),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Metode Pembayaran'),
                            TextButton(
                              onPressed: () {},
                              child: const Row(
                                children: [
                                  Text('BCA'),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal Pemesanan'),
                            Text('0'),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Biaya Pengiriman'),
                            Text('0'),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Biaya Lain-lain'),
                            Text('0'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.zero),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Total Harga',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              formatCurrency
                                  .format(widget.pangan["price"] * count),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.amber),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Bayar',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountdownWidget extends StatefulWidget {
  final Map<String, dynamic> pangan;
  final void Function(int) onCountChanged;

  const CountdownWidget(
      {Key? key, required this.pangan, required this.onCountChanged})
      : super(key: key);

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  int count = 1;
  late int price;
  void increment() {
    setState(() {
      count++;
      price = widget.pangan["price"] * count;
      widget.onCountChanged(count);
    });
  }

  void decrement() {
    setState(() {
      if (count > 1) {
        count--;
        price = widget.pangan["price"] * count;
        widget.onCountChanged(count);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: decrement,
          icon: const Icon(Icons.remove),
        ),
        Text(
          '$count',
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          onPressed: increment,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
