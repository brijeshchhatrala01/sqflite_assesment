import 'package:assesment_app/database/inventory_database.dart';
import 'package:assesment_app/theme/colors.dart';
import 'package:assesment_app/theme/text.dart';
import 'package:assesment_app/util/widgets.dart';
import 'package:flutter/material.dart';

class ViewInventory extends StatefulWidget {
  const ViewInventory({super.key});

  @override
  State<ViewInventory> createState() => _ViewInventoryState();
}

class _ViewInventoryState extends State<ViewInventory> {
  List<Map<String, Object?>> recivedDataList = [];
  List<Map<String, Object?>> recivedPriceList = [];
  InventoryDatabase inventoryDatabase = InventoryDatabase();

  int sum = 0;

  @override
  void initState() {
    inventoryDatabase.sumOfPrice();
    Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        recivedDataList = await inventoryDatabase.fetchAllProduct();
        recivedPriceList = await inventoryDatabase.sumOfPrice();

        recivedPriceList.forEach(
          (element) {
            sum += int.parse(element['item_price'].toString());
          },
        );
        setState(() {});
      },
    );
    super.initState();
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
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: loginPageBackground)
          ),
        
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "No. Of Items : ${recivedDataList.length}",
                            style: gridButtonTextStyle,
                          ),
                          Text(
                            "Total Sum : $sum",
                            style: gridButtonTextStyle,
                          )
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 24,
                            ),
                            children: recivedDataList.map((data) {
                              return Card(
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
                                      databaseValue: data['barcode_number'].toString(),
                                    ),
                                    sizedBoxSmall,
                                    ShowRowFields(
                                      fieldName: "Product Name : ",
                                      databaseValue: data['item_name'].toString(),
                                    ),
                                    sizedBoxSmall,
                                    ShowRowFields(
                                      fieldName: "Product Price : ",
                                      databaseValue: '\$${data['item_price'].toString()}',
                                    ),
                                    sizedBoxSmall,
                                    ShowRowFields(
                                      fieldName: "Product Catagory",
                                      databaseValue: data['item_catagory'].toString(),
                                    ),
                                    sizedBoxSmall,
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                sizedBoxMedium,
                    ],
                  ),
                ),
            ),
          ),
        );
  }
}
