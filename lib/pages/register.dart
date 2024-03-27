import 'package:assesment_app/database/inventory_database.dart';
import 'package:assesment_app/log/log_helper.dart';
import 'package:assesment_app/model/user_model.dart';
import 'package:assesment_app/pages/homepage.dart';
import 'package:assesment_app/pages/login_page.dart';
import 'package:assesment_app/theme/colors.dart';
import 'package:assesment_app/theme/text.dart';
import 'package:assesment_app/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controllers
  final firstNameController = TextEditingController();
  final lasttNameController = TextEditingController();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  //form global key
  final _formKey = GlobalKey<FormState>();

  //make unique username for user
  _makeUserName() {

    setState(() {
      userNameController.text =
          firstNameController.text.trim().substring(0, 1).toUpperCase() +
              lasttNameController.text.trim().substring(0, 2).toUpperCase() +
              emailController.text.trim().substring(0, 3).toUpperCase();
    });
  }

  String? _passwordCheckValidator(String? value) {
    return value!.isEmpty ? "Please Enter Password" :  value != confirmPassController.text ? "Password Doesn't Match" : null;
  }

  //database file object
  InventoryDatabase inventoryDatabase = InventoryDatabase();

  LoggingHelper loggingHelper = LoggingHelper();

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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Inventory",
                  style: textHeaderStyle,
                ),
                sizedBoxSmall,
                TextFormField(
                  controller: firstNameController,
                  validator: nullCheckValidator,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    errorStyle: errorTextStyle,
                    labelText: "First Name",
                    labelStyle: lableStyle,
                  ),
                ),
                sizedBoxSmall,
                TextFormField(
                  controller: lasttNameController,
                  validator: nullCheckValidator,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    errorStyle: errorTextStyle,
                    labelText: "Last Name",
                    labelStyle: lableStyle,
                  ),
                ),
                sizedBoxSmall,
                TextFormField(
                  controller: emailController,
                  validator: nullCheckValidator,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    errorStyle: errorTextStyle,
                    labelText: "Email",
                    labelStyle: lableStyle,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                sizedBoxSmall,
                TextFormField(
                  enabled: false,
                  onTap: _makeUserName,
                  controller: userNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    errorStyle: errorTextStyle,
                    labelText: "Username",
                    labelStyle: lableStyle,
                  ),
                ),
                sizedBoxSmall,
                TextFormField(
                  controller: passwordController,
                  validator: _passwordCheckValidator,
                  obscureText: true,
                  onTap: _makeUserName,
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
                TextFormField(
                  controller: confirmPassController,
                  validator: _passwordCheckValidator,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor)),
                    errorStyle: errorTextStyle,
                    prefixIcon: const Icon(Icons.lock),
                    labelText: "Confirm Password",
                    labelStyle: lableStyle,
                  ),
                ),
                sizedBoxSmall,
                MyAppButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _makeUserName();
                      var userData = UserModel(first_name: firstNameController.text, last_name: lasttNameController.text, email: emailController.text, username: userNameController.text, password: passwordController.text, confirm_password: confirmPassController.text);
                      inventoryDatabase.registerUser(userData);
                      loggingHelper.writeLog("User : ${userNameController.text} logged in successfully");
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage(username: userNameController.text),));
                    }
                  },
                  name: 'Register',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
