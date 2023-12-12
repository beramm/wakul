import 'package:flutter/material.dart';

TextEditingController searchController = TextEditingController();

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, top: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Search",
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(2),
                    child: const Icon(Icons.email_outlined)),
                Container(
                    margin: const EdgeInsets.all(2),
                    child: const Icon(Icons.notifications_none_outlined)),
                Container(
                    margin: const EdgeInsets.all(2),
                    child: const Icon(Icons.local_grocery_store_outlined)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
