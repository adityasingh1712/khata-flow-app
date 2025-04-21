import 'package:khata_book_assignment/models/billItems.dart';
import 'package:khata_book_assignment/models/items.dart';
import 'package:khata_book_assignment/models/transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/bills.dart';

class DataBaseHelper {
  static const _dataBaseName = 'transaction.db';
  static const _dataBaseVersion = 2;

  static const table = 'transactions';
  static const itemsTable = 'items';
  static const billsTable = 'bills';
  static const billsItemTable = 'billItems';
  //trx column names
  static const columnId = 'id';
  static const columnAmount = 'amount';
  static const columnDescription = 'description';
  static const columnType = 'type';
  static const columnMode = 'mode';
  static const columnDateTime = 'dateTime';
  //items column names
  static const columnName = 'name';
  static const columnPurchasingPrice = 'purchasingPrice';
  static const columnSalePrice = 'salePrice';
  static const columnQuantity = 'quantity';
  static const columnLowStock = 'lowStock';
  //bills column names
  static const columnBillType = 'billType';
  static const columnTotalAmount = 'totalAmount';
  //bill items column names
  static const columnBillId = 'billId';
  static const columnItemId = 'itemId';

  DataBaseHelper._init();

  static final DataBaseHelper instance = DataBaseHelper._init();
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, _dataBaseName);
    return await openDatabase(
      path,
      version: _dataBaseVersion,
      onCreate: _create,
      onUpgrade: _onUpgrade,
    );
  }

  Future _create(Database db, int version) async {
    // Create transactions table
    await db.execute('''
      CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnAmount REAL NOT NULL,
        $columnDescription TEXT,
        $columnType TEXT NOT NULL,
        $columnMode TEXT NOT NULL,
        $columnDateTime TEXT NOT NULL)
      ''');

    // Create items table
    await db.execute('''
      CREATE TABLE $itemsTable(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnQuantity INTEGER NOT NULL,
        $columnSalePrice REAL NOT NULL,
        $columnPurchasingPrice REAL NOT NULL,
        $columnLowStock INTEGER NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE $billsTable (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnName TEXT,
          $columnBillType TEXT,
          $columnTotalAmount REAL,
          $columnDateTime TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE $billsItemTable(
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnBillId INTEGER,
          $columnItemId INTEGER,
          $columnName TEXT,
          $columnAmount REAL,
          $columnQuantity INTEGER,
          FOREIGN KEY ($columnBillId) REFERENCES $billsTable ($columnId)
      )
      ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $itemsTable (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnName TEXT NOT NULL,
          $columnQuantity INTEGER NOT NULL,
          $columnSalePrice REAL NOT NULL,
          $columnPurchasingPrice REAL NOT NULL,
          $columnLowStock INTEGER NOT NULL
        )
      ''');
    }
  }

  // Transaction CRUD
  Future<int> insertTransaction(TransactionModel txn) async {
    final db = await instance.database;
    return await db.insert(table, txn.toMap());
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await instance.database;
    final result = await db.query(
      table,
      orderBy: 'dateTime DESC',
    );
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<List<TransactionModel>> getTodayTransactions() async {
    final db = await database;
    final today = DateTime.now();
    final todayString =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'dateTime LIKE ?',
      whereArgs: ['$todayString%'],
      orderBy: 'dateTime DESC',
    );

    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  // Items CRUD
  Future<int> insertItem(Items item) async {
    final db = await instance.database;
    return await db.insert(itemsTable, item.toMap());
  }

  Future<List<Items>> getItems() async {
    final db = await instance.database;
    final result = await db.query(itemsTable);
    return result.map((item) => Items.fromMap(item)).toList();
  }

  Future<Items?> getItem(int id) async {
    final db = await instance.database;
    final result = await db.query(
      itemsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Items.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<void> updateItems(Items items) async {
    final db = await instance.database;
    await db.update(itemsTable, items.toMap(),
        where: 'id = ?', whereArgs: [items.id]);
  }

  //bill CRUD
  Future<void> insertBill(Bill bill, TransactionMode mode) async {
    final db = await instance.database;

    final billId = await db.insert(billsTable, bill.toMap());

    for (var item in bill.items) {
      final billItemMap = item.toMap();
      billItemMap['billId'] = billId;
      await db.insert(billsItemTable, billItemMap);
    }

    final txn = TransactionModel(
      amount: bill.totalAmount,
      mode: mode,
      description: '${bill.billType} FROM ${bill.name}',
      dateTime: bill.dateTime,
      type: bill.billType == BillType.sale ? 'credit' : 'debit',
    );

    await db.insert(table, txn.toMap());
  }

  Future<List<Bill>> getBills() async {
    final db = await instance.database;
    final itemResult = await db.query(billsItemTable);

    final billItems =
        itemResult.map((billItem) => BillItem.fromMap(billItem)).toList();

    final result = await db.query(billsTable);

    final bills = result.map((bill) {
      final billId = bill['id'] as int;
      final itemList =
          billItems.where((item) => item.billId == billId).toList();

      return Bill.fromMap(bill, itemList);
    }).toList();

    return bills;
  }
}
