import 'package:assesment_app/theme/colors.dart';
import 'package:assesment_app/theme/text.dart';
import 'package:flutter/material.dart';

//validator method for checking null value in textfields
String? nullCheckValidator(String? value) {
  return value!.isEmpty ? "please enter detail" : null;
}

//small height sizedbox
const SizedBox sizedBoxSmall = SizedBox(
  height: 18,
);

//medium height sizedbox
const SizedBox sizedBoxMedium = SizedBox(
  height: 24,
);

//Grid buttons for homepage
class GridButton extends StatelessWidget {
  final IconData iconData;
  final Color iconBackGround;
  final String iconTitle;
  final Function()? onTap;

  const GridButton(
      {super.key,
      required this.iconData,
      required this.iconBackGround,
      required this.iconTitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12.00),
        child: Column(
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: iconBackGround,
              child: Icon(
                iconData,
                size: 42,
              ),
            ),
            sizedBoxSmall,
            Text(
              iconTitle,
              style: gridButtonTextStyle,
            )
          ],
        ),
      ),
    );
  }
}

//text fields for add product page
class RowTextField extends StatelessWidget {
  final String fieldName;
  final String hintText;
  final TextEditingController controller;

  const RowTextField(
      {super.key,
      required this.fieldName,
      required this.hintText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            fieldName,
            style: gridButtonTextStyle,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
            child: TextFormField(
              controller: controller,
              validator: nullCheckValidator,
              decoration: InputDecoration(
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: errorColor),
                ),
                errorStyle: errorTextStyle,
                labelText: hintText,
                labelStyle: errorTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}

//custom Buttons for app
class MyAppButton extends StatelessWidget {
  final void Function()? onPressed;
  final String name;
  const MyAppButton({super.key, required this.onPressed, required this.name});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: const ButtonStyle(
        shape: MaterialStatePropertyAll(
          BeveledRectangleBorder(),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        name.toUpperCase(),
      ),
    );
  }
}

//show product data in row by fields 
class ShowRowFields extends StatelessWidget {
  final String fieldName;
  final Object databaseValue;
  const ShowRowFields(
      {super.key, required this.fieldName, required this.databaseValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(fieldName),
        Text(databaseValue.toString()),
      ],
    );
  }
}
