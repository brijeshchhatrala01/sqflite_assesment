import 'package:assesment_app/database/inventory_database.dart';
import 'package:assesment_app/pages/update_product.dart';
import 'package:assesment_app/theme/colors.dart';
import 'package:assesment_app/theme/text.dart';
import 'package:assesment_app/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ViewProduct extends StatefulWidget {
  final String username;
  const ViewProduct({super.key, required this.username});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  //list for recive data
  List<Map<String, Object?>> reciveDataList = [];

  Map<String, Object?> reciveDataByBarcode = {};

  InventoryDatabase inventoryDatabase = InventoryDatabase();

  @override
  void initState() {
    fetchAllData();
    super.initState();
  }

  Future fetchAllData() {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        reciveDataList = await inventoryDatabase.fetchAllProduct();
        setState(() {});
      },
    );
  }

  //controller
  final _searchController = TextEditingController();

  bool isEmpty = false;

  bool showAllData = true;

  bool isVisibleSingleData = true;

  List barcodeProductList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Inventory App",
          style: textStyleAppbar,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration:
              BoxDecoration(gradient: LinearGradient(colors: homePageGredient)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Scan Items",
                    style: textHeaderStyle,
                  ),
                ),
                sizedBoxMedium,
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    errorStyle: errorTextStyle,
                    errorText: isEmpty ? "Please Enter Barcode Number" : null,
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    labelText: "Search By Barcode",
                    labelStyle: errorTextStyle,
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SimpleBarcodeScannerPage(),
                            ));
                        barcodeProductList.add(res.split('-'));
                        setState(() {
                          _searchController.text =
                              barcodeProductList[0][0].toString();
                        });
                      },
                      icon: const Icon(Icons.camera_alt),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                sizedBoxMedium,
                MyAppButton(
                  onPressed: () {
                    if (_searchController.text.isEmpty) {
                      setState(() {
                        isEmpty = !isEmpty;
                      });
                    }
                    fetchDataByBarcode();
                  },
                  name: 'Search',
                ),
                sizedBoxMedium,
                Text(showAllData || isVisibleSingleData
                    ? "Press Long On Card To Update A Product"
                    : ""),
                showAllData
                    ? Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 24,
                          ),
                          children: reciveDataList.map((data) {
                            return GestureDetector(
                              onLongPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateProduct(
                                          username: widget.username.toString(),
                                          barcodeNumber: data['barcode_number']
                                              .toString()),
                                    ));
                              },
                              child: Card(
                                margin: const EdgeInsets.all(12),
                                color: appBarColor,
                                elevation: 0,
                                shape: const BeveledRectangleBorder(
                                    side: BorderSide(style: BorderStyle.solid)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    sizedBoxSmall,
                                    ShowRowFields(
                                      fieldName: "Barcode Number : ",
                                      databaseValue:
                                          data['barcode_number'].toString(),
                                    ),
                                    sizedBoxSmall,
                                    ShowRowFields(
                                      fieldName: "Product Name : ",
                                      databaseValue:
                                          data['item_name'].toString(),
                                    ),
                                    sizedBoxSmall,
                                    ShowRowFields(
                                      fieldName: "Product Price : ",
                                      databaseValue:
                                          '\$${data['item_price'].toString()}',
                                    ),
                                    sizedBoxSmall,
                                    ShowRowFields(
                                      fieldName: "Product Catagory",
                                      databaseValue:
                                          data['item_catagory'].toString(),
                                    ),
                                    sizedBoxMedium,
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : Visibility(
                        visible: isVisibleSingleData,
                        child: reciveDataByBarcode.isNotEmpty
                            ? GestureDetector(
                                onLongPress: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateProduct(
                                            barcodeNumber: reciveDataByBarcode[
                                                    'barcode_number']
                                                .toString(),
                                            username: widget.username),
                                      ));
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(12),
                                  color: appBarColor,
                                  elevation: 0,
                                  shape: const BeveledRectangleBorder(
                                      side:
                                          BorderSide(style: BorderStyle.solid)),
                                  child: Column(
                                    children: [
                                      sizedBoxSmall,
                                      ShowRowFields(
                                        fieldName: "Barcode Number : ",
                                        databaseValue: reciveDataByBarcode[
                                                'barcode_number']
                                            .toString(),
                                      ),
                                      sizedBoxSmall,
                                      ShowRowFields(
                                        fieldName: "Product Name : ",
                                        databaseValue:
                                            reciveDataByBarcode['item_name']
                                                .toString(),
                                      ),
                                      sizedBoxSmall,
                                      ShowRowFields(
                                        fieldName: "Product Price : ",
                                        databaseValue:
                                            '\$${reciveDataByBarcode['item_price'].toString()}',
                                      ),
                                      sizedBoxSmall,
                                      ShowRowFields(
                                        fieldName: "Product Catagory",
                                        databaseValue:
                                            reciveDataByBarcode['item_catagory']
                                                .toString(),
                                      ),
                                      sizedBoxSmall,
                                    ],
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text("No Data Found!"),
                              ),
                      ),
                sizedBoxMedium
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future fetchDataByBarcode() {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        try {
          reciveDataByBarcode =
              await inventoryDatabase.fetchByBarcode(_searchController.text);
          setState(() {
            showAllData = false;
            isVisibleSingleData = true;
          });
        } catch (e) {
          setState(() {
            showAllData = false;
            isVisibleSingleData = true;
          });
          reciveDataByBarcode = {};
          showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("No Data Found"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                     Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
