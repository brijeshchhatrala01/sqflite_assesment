import 'package:assesment_app/database/inventory_database.dart';
import 'package:assesment_app/log/log_helper.dart';
import 'package:assesment_app/pages/add_product.dart';
import 'package:assesment_app/pages/delete_product.dart';
import 'package:assesment_app/pages/login_page.dart';
import 'package:assesment_app/pages/view_inventory.dart';
import 'package:assesment_app/pages/view_product.dart';
import 'package:assesment_app/theme/colors.dart';
import 'package:assesment_app/theme/text.dart';
import 'package:assesment_app/util/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Homepage extends StatefulWidget {
  final String username;
  const Homepage({super.key,required this.username});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  Map<String,Object?> userData = {};

  InventoryDatabase inventoryDatabase = InventoryDatabase();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300),() async {
      userData = await inventoryDatabase.checkUser(widget.username);
    },);
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
        actions: [
          IconButton(onPressed: () {
              showCupertinoModalPopup(context: context, builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text("User Information",style: textHeaderStyle,),
                  content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    sizedBoxSmall,
                    Text("First Name : ${userData['first_name'].toString()}"),
                    sizedBoxSmall,
                    Text("Last Name : ${userData['last_name'].toString()}"),
                    sizedBoxSmall,
                    Text("Email : ${userData['email'].toString()}"),
                    sizedBoxSmall,
                    Text("Username : ${userData['username'].toString()}"),
                  ],
                ),
                  actions: [
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text('OK'))
                  ],
                );
              },);
          }, icon: const Icon(Icons.person)),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
              LoggingHelper().writeLog('Logout Sucessfully ${widget.username}');
            },
            icon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: loginPageBackground),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(42),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ClipOval(
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: homePageGredient.reversed.toList(),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Welcome ${widget.username}",
                          style: textHeaderStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
              child: GridView.count(
                padding: const EdgeInsets.all(12.00),
                crossAxisCount: 2,
                children: [
                  GridButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(username: widget.username.toString(),),));
                    },
                    iconData: Icons.add,
                    iconBackGround: addButtonBackground,
                    iconTitle: "Add Product",
                  ),
                  GridButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  DeleteProduct(username: widget.username.toString(),),));
                    },
                    iconData: Icons.delete,
                    iconBackGround: deleteBackground,
                    iconTitle: "Delete Product",
                  ),
                  GridButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ViewProduct(username: widget.username.toString()),));
                    },
                    iconData: Icons.find_replace,
                    iconBackGround: viewProductBG,
                    iconTitle: "View Product",
                  ),
                  GridButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewInventory(),));
                    },
                    iconData: Icons.currency_exchange,
                    iconBackGround: viewInventoryBG,
                    iconTitle: "View Inventory",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
