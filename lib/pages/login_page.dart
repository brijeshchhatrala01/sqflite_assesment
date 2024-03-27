import 'package:assesment_app/database/inventory_database.dart';
import 'package:assesment_app/log/log_helper.dart';
import 'package:assesment_app/pages/homepage.dart';
import 'package:assesment_app/pages/register.dart';
import 'package:assesment_app/theme/colors.dart';
import 'package:assesment_app/theme/text.dart';
import 'package:assesment_app/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //database class Object for create database when user open app
  InventoryDatabase inventoryDatabase = InventoryDatabase();
  LoggingHelper loggingHelper = LoggingHelper();

  @override
  void initState() {
    //make database on device
    inventoryDatabase.openInventoryDatabase();
    //make log file on device
    LoggingHelper.localFile;
    super.initState();
  }

  //asset image path
  final imageLogo = "images/inventory.png";

  //controllers
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  bool isUserValid = false;

  Map<String, Object?> userData = {};

  //fetch login data from database by username
  void fetchData() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () async {
        userData = await inventoryDatabase.checkUser(_usernameController.text);
        setState(() {
          if (userData['username'].toString() ==
              _usernameController.text &&
              userData['password'].toString() ==
                  _passwordController.text) {
            isUserValid = !isUserValid;
            loggingHelper.writeLog(
                "Logged In Successfully : ${_usernameController.text}");
          }
          else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed")));
          }
        });
      },
    );
  }

  //form GlobalKey to check validation
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: loginPageBackground),
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      imageLogo,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Text(
                    "Inventory",
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
                  TextFormField(
                    controller: _passwordController,
                    validator: nullCheckValidator,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorColor)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorColor)),
                      errorStyle: errorTextStyle,
                      prefixIcon: const Icon(Icons.lock),
                      labelText: "Password",
                      labelStyle: lableStyle,
                    ),
                  ),
                  sizedBoxSmall,
                  MyAppButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        fetchData();
                        isUserValid ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Homepage(username: _usernameController.text),
                          ),
                        ) : null;
                      }
                    },
                    name: 'Login',
                  ),
                  sizedBoxSmall,
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password ?",
                      style: forgotPasswordTextStyle,
                    ),
                  ),
                  sizedBoxSmall,
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage(),));
                    },
                    child: Text(
                      "Register Hear",
                      style: forgotPasswordTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
