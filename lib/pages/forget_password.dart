import 'package:assesment_app/database/inventory_database.dart';
import 'package:assesment_app/log/log_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text.dart';
import '../util/widgets.dart';

class ForgetPassword extends StatefulWidget {
   ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  Map<String, Object?>? userData = {};

  final _usernameController = TextEditingController();

  InventoryDatabase inventoryDatabase = InventoryDatabase();

  void fetchData() {
    Future.delayed(
      const Duration(milliseconds: 300),
          () async {
        userData = await inventoryDatabase.checkUser(_usernameController.text.trim());
        setState(() {
          if (userData!= null) {
            if (_usernameController.text == userData!['username'].toString())  {
              showCupertinoDialog(context: context, builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Your Password is !",style: textHeaderStyle,),
                  content: Text(userData!['password'].toString(),style: gridButtonTextStyle,),
                  actions: [
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: const Text('OK'))
                  ],
                );
              },);
              LoggingHelper().writeLog(
                  "Password Get Successfully : ${_usernameController.text}");
            } else {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text("No User Found!")));
            }
          }
          else {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text("No User Found!")));
          }
        });
      },
    );
  }


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Inventory App",
            style: textStyleAppbar,
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: loginPageBackground),
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Forget Password",
                    style: textHeaderStyle,
                  ),
                  sizedBoxSmall,
                  TextFormField(
                    controller: _usernameController,
                    validator: nullCheckValidator,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorColor)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorColor)),
                      errorStyle: errorTextStyle,
                      prefixIcon: const Icon(Icons.person),
                      labelText: "User Name",
                      labelStyle: lableStyle,
                    ),
                  ),
                  sizedBoxSmall,
                  MyAppButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                          fetchData();
                      }
                    },
                    name: 'S H O W  P A S S W O R D',
                  ),

                ],
              ),
            ),
          ),
        )
    );
  }
}
