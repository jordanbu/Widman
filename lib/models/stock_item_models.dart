// models/stock_item_model.dart
class StockItem {
  final int cantFisica;
  final int nsAlmacen;
  final int nsProducto;

  StockItem({
    required this.cantFisica,
    required this.nsAlmacen,
    required this.nsProducto,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      cantFisica: json['cantFisica'],
      nsAlmacen: json['ns_Almacen'],
      nsProducto: json['ns_Producto'],
    );
  }
}
