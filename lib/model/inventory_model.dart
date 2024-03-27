class InventoryModel {
  final String barcodeNum;
  final String itemName;
  final int itemPrice;
  final String itemCatagory;

  InventoryModel({
    required this.barcodeNum,
    required this.itemName,
    required this.itemPrice,
    required this.itemCatagory,
  });

  Map<String, Object?> toMap() {
    return {
      'barcode_number': barcodeNum,
      'item_name': itemName,
      'item_price': itemPrice,
      'item_catagory': itemCatagory,
    };
  }
}
