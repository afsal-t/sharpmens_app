import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'cart model.dart';


class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId VARCHAR UNIQUE,
        productName TEXT NOT NULL,
        initialPrice REAL NOT NULL,
        productPrice REAL NOT NULL,
        quantity INTEGER NOT NULL,
        image TEXT NOT NULL
      )
    ''');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await db;
    await dbClient.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartItems() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('cart');
    return List.generate(maps.length, (i) => Cart.fromMap(maps[i]));
  }

  Future<void> delete(int id) async {
    var dbClient = await db;
    await dbClient.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateQuantity(int id, int quantity, double price) async {
    var dbClient = await db;
    await dbClient.rawUpdate('''
      UPDATE cart
      SET quantity = ?, productPrice = ?
      WHERE id = ?
    ''', [quantity, price, id]);
  }
}
