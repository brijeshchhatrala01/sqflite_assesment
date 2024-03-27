import 'package:assesment_app/model/inventory_model.dart';
import 'package:assesment_app/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class InventoryDatabase {
  late Database database;

  final DATABASENAME = "inventory.db";
  final TABLENAME = "inventory_data";
  final TABLEUSER = "users";
  Future openInventoryDatabase() async {
    database = await openDatabase(
      version: 1,
      join(await getDatabasesPath(), DATABASENAME),
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS $TABLENAME
        (
          barcode_number VARCHAR(50),
          item_name TEXT NOT NULL,
          item_price NUMBER NOT NULL,
          item_catagory TEXT NOT NULL,
          UNIQUE(barcode_number)
        );
        ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS $TABLEUSER
        (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first_name TEXT NOT NULL,
          last_name TEXT NOT NULL,
          email TEXT NOT NULL,
          username TEXT NOT NULL,
          password TEXT NOT NULL,
          confirm_password TEXT NOT NULL
        );
        ''');
      },
    );
  }

  //return database object with open database
  Future<Database> getDatabaseObject() async {
    return database = await openDatabase(
        version: 1, join(await getDatabasesPath(), DATABASENAME));
  }

  //insert product data in product table
  Future<void> insertProduct(InventoryModel inventoryModel) async {
    database = await getDatabaseObject();
    database.insert(TABLENAME, inventoryModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  //fetch all data from product table
  Future<List<Map<String, Object?>>> fetchAllProduct() async {
    database = await getDatabaseObject();
    List<Map<String, Object?>> listData = await database.query(TABLENAME);
    return listData;
  }

  //fetch data from prduct table by barcode number
  Future<Map<String, Object?>> fetchByBarcode(String barcode) async {
    database = await getDatabaseObject();
    List<Map<String, Object?>> listData = await database.query(
      TABLENAME,
      where: "barcode_number = ?",
      whereArgs: [barcode],
    );
    return listData.first;
  }

  //delete data from product table by barcode
  Future<void> deleteProductByBarcode(String barcode) async {
    database = await getDatabaseObject();
    database.delete(
      TABLENAME,
      where: "barcode_number = ?",
      whereArgs: [barcode],
    );
  }

  //update data in product table by barcode number
  Future<void> updateProductByBarcode(
      InventoryModel inventoryModel, String barcode) async {
    database = await getDatabaseObject();
    database.update(
      TABLENAME,
      inventoryModel.toMap(),
      where: "barcode_number = ?",
      whereArgs: [barcode],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  //return total sum of price in product table
  Future sumOfPrice() async {
    database = await getDatabaseObject();
    var sum = database.query(TABLENAME, columns: ['item_price']);
    return sum;
  }

  //get first barcode number from product table
  Future<Map<String, Object?>> barcodeSuggestion() async {
    database = await getDatabaseObject();
    var listData = await database.query(
      TABLENAME,
      columns: ['barcode_number'],
    );
    return listData.first;
  }

  Future<void> registerUser(UserModel userModel) async {
    database = await getDatabaseObject();
    database.insert(TABLEUSER, userModel.toMap(),conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<Map<String,Object?>> checkUser(String username) async {
    database = await getDatabaseObject();
    var listData = await database.query(TABLEUSER,where: "username = ?",whereArgs: [username]);
    return listData.first;
  }
}
