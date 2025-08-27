import 'package:floor/floor.dart';
import 'package:arcs_agro/location_model.dart';

@dao
abstract class LocationDao {
  @Query('SELECT * FROM LocationModel')
  Future<List<LocationModel>> getCacheLocation();

  @Query('DELETE FROM LocationModel')
  Future<void> clearCache();

  @insert
  Future<void> addLocation(LocationModel location);
}