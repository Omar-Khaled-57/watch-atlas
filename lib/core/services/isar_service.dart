import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static final IsarService instance = IsarService._();
  IsarService._();

  Isar? _isar;

  Isar get db {
    if (_isar == null) {
      throw StateError('Isar not initialized. Call init() first.');
    }
    return _isar!;
  }

  Future<void> init() async {
    if (_isar != null) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [],
      directory: dir.path,
      inspector: true,
    );
  }

  Future<void> writeTxn<T>(Future<T> Function() callback) async {
    await db.writeTxn(callback);
  }

  Future<void> clear() async {
    await db.writeTxn(() async {
      await db.clear();
    });
  }

  void dispose() {
    _isar?.close();
    _isar = null;
  }
}
