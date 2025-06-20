import 'package:sqflite/sqflite.dart';
import 'package:praktikum_1/service/database/database.dart';

class CartHelper {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // CREATE (Insert item ke cart)
  Future<void> insertCartItem(Map<String, dynamic> item) async {
    final db = await dbHelper.database;
    await db.insert('cart', item, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await dbHelper.database;
    return await db.query('cart');
  }

  // FUNGSI BARU UNTUK MENGECEK ITEM
  Future<Map<String, dynamic>?> getCartItemByName(String name) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cart',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // UPDATE (Perbarui jumlah item di cart)
  Future<void> updateCartItem(int id, int quantity) async {
    final db = await dbHelper.database;
    await db.update(
      'cart',
      {"quantity": quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE (Hapus item berdasarkan id)
  Future<void> deleteCartItem(int id) async {
    final db = await dbHelper.database;
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE ALL (Hapus semua item di cart)
  Future<void> clearCart() async {
    final db = await dbHelper.database;
    await db.delete('cart');
  }
}
