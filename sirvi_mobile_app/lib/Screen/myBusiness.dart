import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:sirvi_mobile_app/Screen/addMyBusiness.dart';
import 'package:sirvi_mobile_app/Screen/viewMyStudents.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/widgets/business_data_row.dart';

class MyBusiness extends StatefulWidget {
  const MyBusiness({super.key});

  @override
  State<MyBusiness> createState() => _MyBusinessState();
}

class _MyBusinessState extends State<MyBusiness> {
  final bool _loadingDeleteBusiness = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Business'),
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 56, 106),
        ),
        body: Container(
          height: double.infinity,
          child: Stack(children: [
            SingleChildScrollView(
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.only(
                    top: 20, right: 20, left: 20, bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 10, right: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/india.png',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "AAI MATA GENERAL STORE",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            const SizedBox(height: 15),
                            const BusinessDataRow(
                                label: 'Location', value: 'Pali'),
                            const SizedBox(height: 5),
                            const BusinessDataRow(
                                label: 'Category', value: 'Medical'),
                            const SizedBox(height: 5),
                            const BusinessDataRow(
                                label: 'Mobile No.', value: '8949885630'),
                            const SizedBox(height: 5),
                            const BusinessDataRow(
                                label: 'Email', value: "bharatsirvi@gmail.com"),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Owners : ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bharat',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Suresh',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Manish',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.transparent,
                                  ),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  iconAlignment: IconAlignment.start,
                                  label: const Text(
                                    "EDIT",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16),
                                  ),
                                  onPressed: () {},
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.transparent,
                                  ),
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  iconAlignment: IconAlignment.start,
                                  label: const Text(
                                    "DELETE",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Add a small space between the card and the next widget
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 20,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddMyBusiness()));
                },
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 255, 56, 106),
                label: const Text(
                  'Add New Bussiness',
                  style: TextStyle(fontSize: 16),
                ),
                icon: const Icon(Icons.add_business),
              ),
            ),
            if (_loadingDeleteBusiness)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ]),
        ));
  }
}
