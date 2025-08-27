import 'dart:async';

import 'package:floor/floor.dart';
import 'package:arcs_agro/location_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'location_model.dart';

part 'local_db.g.dart';

@Database(version: 1, entities: [LocationModel])
abstract class AppDatabase extends FloorDatabase {
  LocationDao get locationDao;
}