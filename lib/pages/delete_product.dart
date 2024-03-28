import 'package:assesment_app/database/inventory_database.dart';
import 'package:assesment_app/log/log_helper.dart';
import 'package:assesment_app/theme/colors.dart';
import 'package:assesment_app/theme/text.dart';
import 'package:assesment_app/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class DeleteProduct extends StatefulWidget {
  final String username;
  const DeleteProduct({super.key,required this.username});

  @override
  State<DeleteProduct> createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  //map for get particular data from database
  Map<String, Object?> reciveDataByBarcode = {};

  //map for show suggetion on hint of barcode number
  Map<String, Object?> randomSuggestion = {};

  //inventory database class object
  InventoryDatabase inventoryDatabase = InventoryDatabase();

  //controller
  final _searchController = TextEditingController();

  //logginghelper class object
  LoggingHelper loggingHelper = LoggingHelper();

  //set visiblity for show data
  bool isVisibleSingleData = false;

  //set validator by bool in textfield
  bool isEmpty = false;

  //barcodeproductList for get barcode number by barcode scanner
  List barcodeProductList = [];

  @override
  void initState() {
    //get random barcode numberhint in textfields
    getRandomSuggetion();
    super.initState();
  }

  Future getRandomSuggetion() {
    return Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        randomSuggestion = await inventoryDatabase.barcodeSuggestion();
      } catch (e) {
        randomSuggestion = {};
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    errorStyle: errorTextStyle,
                    errorText: isEmpty ? "Please Enter Barcode Number" : null,
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: errorColor),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    hintText: randomSuggestion.isNotEmpty
                        ? randomSuggestion['barcode_number'].toString()
                        : "No Data Available To Delete",
                    hintStyle: errorTextStyle,
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
                          ),
                        );
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
                      isEmpty = !isEmpty;
                    }
                    fetchDataByBarcode(context);
                  },
                  name: 'Search',
                ),
                sizedBoxMedium,
                Visibility(
                  visible: isVisibleSingleData,
                  child: reciveDataByBarcode.isNotEmpty
                      ? Card(
                          margin: const EdgeInsets.all(12),
                          color: appBarColor,
                          elevation: 0,
                          shape: const BeveledRectangleBorder(
                              side: BorderSide(style: BorderStyle.solid)),
                          child: Column(
                            children: [
                              sizedBoxSmall,
                              ShowRowFields(
                                fieldName: "Barcode Number : ",
                                databaseValue:
                                    reciveDataByBarcode['barcode_number']
                                        .toString(),
                              ),
                              sizedBoxSmall,
                              ShowRowFields(
                                fieldName: "Product Name : ",
                                databaseValue:
                                    reciveDataByBarcode['item_name'].toString(),
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
                              ElevatedButton(
                                onPressed: () {
                                  inventoryDatabase.deleteProductByBarcode(
                                    reciveDataByBarcode['barcode_number']
                                        .toString(),
                                  );
                                  loggingHelper.transectionProduct(LogHelper(
                                    username: widget.username.toString(),
                                      transectionType:
                                          TransectionType.Product_Remove,
                                      product_barcode:
                                          reciveDataByBarcode['barcode_number']
                                              .toString(),
                                      product_name:
                                          reciveDataByBarcode['item_name']
                                              .toString(),
                                      product_catagory:
                                          reciveDataByBarcode['item_catagory']
                                              .toString(),
                                      product_price:
                                          reciveDataByBarcode['item_price']
                                              .toString()));
                                  reciveDataByBarcode = {};
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                              sizedBoxMedium
                            ],
                          ),
                        )
                      : const Center(
                          child: Text("No Data Found!"),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future fetchDataByBarcode(BuildContext context) {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        try {
          reciveDataByBarcode =
              await inventoryDatabase.fetchByBarcode(_searchController.text);
          setState(() {
            isVisibleSingleData = true;
          });
        } catch (e) {
          setState(() {
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
