import 'package:assesment_app/database/inventory_database.dart';
import 'package:assesment_app/log/log_helper.dart';
import 'package:assesment_app/model/inventory_model.dart';
import 'package:assesment_app/pages/homepage.dart';
import 'package:assesment_app/theme/text.dart';
import 'package:assesment_app/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class UpdateProduct extends StatefulWidget {
  final String barcodeNumber;
  final String username;
  UpdateProduct({super.key, required this.barcodeNumber,required this.username});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  //controllers
  final _productNameController = TextEditingController();

  final _catagoryController = TextEditingController();

  final _priceController = TextEditingController();

  final _barcodeController = TextEditingController();

  LoggingHelper loggingHelper = LoggingHelper();
  //form globalkey
  final _formKey = GlobalKey<FormState>();

  //get database class object
  InventoryDatabase inventoryDatabase = InventoryDatabase();

  List barcodeProductList = [];

  Map<String, Object?> recivedData = {};

  @override
  void initState() {
    fetchDataByBarcode(widget.barcodeNumber.toString());
    super.initState();
  }

  Future fetchDataByBarcode(String barcode) {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        recivedData = await inventoryDatabase.fetchByBarcode(barcode);
        setState(() {
          _productNameController.text = recivedData['item_name'].toString();
          _barcodeController.text = recivedData['barcode_number'].toString();
          _catagoryController.text = recivedData['item_catagory'].toString();
          _priceController.text = recivedData['item_price'].toString();
        });
      },
    );
  }

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
                  "Update Product",
                  style: headerProductDetails,
                ),
              ),
              sizedBoxMedium,
              RowTextField(
                fieldName: "Product",
                hintText: "Name",
                controller: _productNameController,
              ),
              sizedBoxMedium,
              RowTextField(
                fieldName: "Catagory",
                hintText: "Catagory",
                controller: _catagoryController,
              ),
              sizedBoxMedium,
              RowTextField(
                fieldName: "Price",
                hintText: "\$ Price",
                controller: _priceController,
              ),
              sizedBoxMedium,
              RowTextField(
                  fieldName: "Numbers",
                  hintText: "Add Barcode Number",
                  controller: _barcodeController),
              sizedBoxMedium,
              MyAppButton(onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const SimpleBarcodeScannerPage(),
                    ));
                barcodeProductList.add(res.split('-'));
                setState(() {
                  _barcodeController.text = barcodeProductList[0][0].toString();
                  _catagoryController.text = barcodeProductList[0][2].toString();
                  _priceController.text = barcodeProductList[0][3].toString();
                  _productNameController.text = barcodeProductList[0][1].toString();
                });


              }, name: 'Scan The QR Code'),
              sizedBoxMedium,
              MyAppButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var productData = InventoryModel(
                          barcodeNum: _barcodeController.text,
                          itemName: _productNameController.text,
                          itemPrice: int.parse(_priceController.text),
                          itemCatagory: _catagoryController.text);
                      try {
                        inventoryDatabase.updateProductByBarcode(
                          productData,
                          widget.barcodeNumber,
                        );
                        loggingHelper.transectionProduct(LogHelper(
                            username: widget.username.toString(),
                            transectionType: TransectionType.Product_Update, product_barcode: _barcodeController.text, product_name: _productNameController.text, product_catagory: _catagoryController.text, product_price: _priceController.text));
                      } catch (e) {
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
                                    child: Text('OK'))
                              ],
                            );
                          },
                        );
                      }
                      Navigator.pop(context);
                      print("Product Added");
                      _barcodeController.clear();
                      _catagoryController.clear();
                      _priceController.clear();
                      _productNameController.clear();
                    }
                  },
                  name: 'Update Product')
            ],
          ),
        ),
      ),
    );
  }
}
