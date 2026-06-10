import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductImageDb extends GetxService {
  static const _dbName = 'food_images.db';
  static const _table = 'product_images';

  Database? _db;

  Future<ProductImageDb> init() async {
    final basePath = await getDatabasesPath();
    final dbPath = join(basePath, _dbName);

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            product_id TEXT PRIMARY KEY,
            image_data BLOB NOT NULL
          )
        ''');
      },
    );

    return this;
  }

  Future<void> saveImage(String productId, List<int> bytes) async {
    await _db!.insert(
      _table,
      {'product_id': productId, 'image_data': bytes},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<int>?> getImage(String productId) async {
    final rows = await _db!.query(
      _table,
      where: 'product_id = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return rows.first['image_data'] as List<int>?;
  }

  Future<void> deleteImage(String productId) async {
    await _db!.delete(
      _table,
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }
}
