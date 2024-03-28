import 'package:assesment_app/database/inventory_database.dart';
import 'package:assesment_app/log/log_helper.dart';
import 'package:assesment_app/model/inventory_model.dart';
import 'package:assesment_app/theme/text.dart';
import 'package:assesment_app/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ProductDetails extends StatefulWidget {
  final String username;
  const ProductDetails({super.key,required this.username});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  //controllers
  final _productNameController = TextEditingController();

  final _catagoryController = TextEditingController();

  final _priceController = TextEditingController();

  final _barcodeController = TextEditingController();

  //form globalkey
  final _formKey = GlobalKey<FormState>();

  //get database class object
  InventoryDatabase inventoryDatabase = InventoryDatabase();

  //logging helper object for add log detail in log file
  LoggingHelper loggingHelper = LoggingHelper();

  //list for get data from barcode scanner
  List barcodeProductList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inventory App",
          style: textStyleAppbar,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.inventory),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sizedBoxMedium,
              Center(
                child: Text(
                  "Product Details",
                  style: headerProductDetails,
                ),
              ),
              sizedBoxMedium,
              RowTextField(
                fieldName: "Product",
                hintText: "Name",
                controller: _productNameController, keyboardType: TextInputType.name,
              ),
              sizedBoxMedium,
              RowTextField(
                fieldName: "Catagory",
                hintText: "Catagory",
                controller: _catagoryController, keyboardType: TextInputType.text,
              ),
              sizedBoxMedium,
              RowTextField(
                fieldName: "Price",
                hintText: "\$ Price",
                controller: _priceController, keyboardType: TextInputType.number,
              ),
              sizedBoxMedium,
              RowTextField(
                  fieldName: "Numbers",
                  hintText: "Add Barcode Number",
                  controller: _barcodeController, keyboardType: TextInputType.number,),
              sizedBoxMedium,
              MyAppButton(
                  onPressed: () async {
                    //get data from barcode with Navigate to SimpleBarcodeScannerPage
                    var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SimpleBarcodeScannerPage(),
                        ));
                    //add data to barcodeProductList
                    barcodeProductList.add(res.split('-'));
                    setState(() {
                      //set textformfields data filled
                      _barcodeController.text =
                          barcodeProductList[0][0].toString();
                      _catagoryController.text =
                          barcodeProductList[0][2].toString();
                      _priceController.text =
                          barcodeProductList[0][3].toString();
                      _productNameController.text =
                          barcodeProductList[0][1].toString();
                    });
                  },
                  name: 'Scan The QR Code'),
              sizedBoxMedium,
              MyAppButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //get all fields data in inventoryModel object
                      var productData = InventoryModel(
                          barcodeNum: _barcodeController.text,
                          itemName: _productNameController.text,
                          itemPrice: int.parse(_priceController.text),
                          itemCatagory: _catagoryController.text);
                      try {
                        //add data in database
                        inventoryDatabase.insertProduct(productData);
                        Navigator.pop(context);
                        //add loghing detail in logging file
                        var transectionDetail = LogHelper(
                          username: widget.username,
                          transectionType: TransectionType.Product_Add,
                          product_barcode: _barcodeController.text,
                          product_name: _productNameController.text,
                          product_catagory: _catagoryController.text,
                          product_price: _priceController.text,
                        );
                        loggingHelper.transectionProduct(transectionDetail);
                      } catch (e) {
                        //if error in adding data that show dialouge box with error details
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(e.toString()),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text('OK'))
                              ],
                            );
                          },
                        );
                      }
                      //after adding data user navigate to homepage
                      context.push('/homepage');
                      //clear the textformfields
                      _barcodeController.clear();
                      _catagoryController.clear();
                      _priceController.clear();
                      _productNameController.clear();
                    }
                  },
                  name: 'Add Item')
            ],
          ),
        ),
      ),
    );
  }
}
