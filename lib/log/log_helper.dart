// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:path_provider/path_provider.dart';

enum TransectionType{
  Product_Add,
  Product_Update,
  Product_Remove,
}

class LogHelper {
  final String username;
  final TransectionType transectionType;
  final product_barcode;
  final product_name;
  final product_catagory;
  final product_price;

  LogHelper({
    required this.username,
    required this.transectionType,
    required this.product_barcode,
    required this.product_name,
    required this.product_catagory,
    required this.product_price,
});

  @override
  String toString() {

    return ("\n\nTransaction By ${username}\ntransection type : ${transectionType}\nbarcode number : ${product_barcode}\nproduct name : ${product_name}'\nproduct catagory : ${product_catagory}\nproduct price : ${product_price}\n\n");
  }
}


class LoggingHelper {
//make log file on storage

//method to get directory path

  static Future<File> get localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/log.txt');
  }


  //add transection on log file
  Future<File> transectionProduct(LogHelper logHelper) async {

    final file = await localFile;
    return file.writeAsString(logHelper.toString(),mode: FileMode.append);
  }

  //add particular message on log file
  Future<File> writeLog(String msg) async {
    final file = await localFile;
    return file.writeAsString("\n\n${msg}",mode: FileMode.append);
  }
}
