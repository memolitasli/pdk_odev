import 'package:flutter/material.dart';

import 'personel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class personelDatabase {
  static final personelDatabase instance = personelDatabase._init();
  static Database? _database;

  personelDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('personel.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final uniqueType = 'TEXT NOT NULL UNIQUE';
    final fotoType = 'TEXT';
/*
* CREATE TABLE $tablePersonel (
        ${personelField.id} $idType,
        ${personelField.isim} $textType,
        ${personelField.soyisim} $textType,
        ${personelField.bolum} $textType,
        ${personelField.mailAdresi} $uniqueType,
        ${personelField.telefonNo} $uniqueType,
        ${personelField.perFotoYolu} $fotoType,
        ${personelField.kayitTarihi} $textType,
        ${personelField.tcNo} $uniqueType
        )
*
* */
    await db.execute(
        'CREATE TABLE $tablePersonel (${personelField.id} INTEGER PRIMARY KEY AUTOINCREMENT, ${personelField.isim} $textType, ${personelField.soyisim} $textType, ${personelField.bolum} $textType, ${personelField.mailAdresi} $uniqueType, ${personelField.telefonNo} $uniqueType, ${personelField.perFotoYolu} $fotoType, ${personelField.kayitTarihi} $textType, ${personelField.tcNo} $uniqueType)');
  }

  Future<personel> create(personel per) async {
    final db = await instance.database;

    debugPrint("db açik mi ${db.isOpen}, ${db.path}");
    final id = await db.insert(tablePersonel, per.toJson());
    return per.copy(id: id);
  }

  Future<personel> readPersonel(int id) async {
    final db = await instance.database;
    final maps = await db.query(tablePersonel,
        columns: personelField.values,
        where: '${personelField.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return personel.fromJson(maps.first);
    } else {
      throw Exception('ID : ${id}, Kayıtlı değil');
    }
  }

  Future<List<personel>> tumPersonelOku() async {
    final db = await instance.database;
    final orderby = '${personelField.id} ASC';
    final result = await db.query(tablePersonel, orderBy: orderby);
    return result.map((json) => personel.fromJson(json)).toList();
  }

  Future<int> update(personel per) async {
    final db = await instance.database;
    return await db.update(tablePersonel, per.toJson(),
        where: '${personelField.id} = ?', whereArgs: [per.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(tablePersonel,
        where: '${personelField.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
