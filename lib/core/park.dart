import 'package:emel_parking_app_henrique/core/park_incident.dart';
import 'package:emel_parking_app_henrique/data/app_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';

class Park {
  final String id;
  final String name;
  final String type;
  final int entityId;
  final String lat;
  final String lon;
  final int maxCapacity;
  int occupation;
  String occupationTimestamp;
  bool active;

  Park({
    required this.id,
    required this.name,
    required this.type,
    required this.entityId,
    required this.lat,
    required this.lon,
    required this.maxCapacity,
    required this.occupation,
    required this.occupationTimestamp,
    required this.active,
  });

  factory Park.fromMap(Map<String, dynamic> data) {
    // handle negative occupation values (turns them into their absolute value)
    int occupation = data['ocupacao'] < 0
        ? (data['ocupacao'] as int).abs()
        : data['ocupacao'];

    return Park(
      id: data['id_parque'],
      name: data['nome'],
      type: data['tipo'],
      entityId: data['id_entidade'],
      lat: data['latitude'],
      lon: data['longitude'],
      maxCapacity: data['capacidade_max'],
      occupation: occupation,
      occupationTimestamp: data['data_ocupacao'],
      active: data['activo'] == 1,
    );
  }

  factory Park.fromDb(Map<String, dynamic> data) {
    return Park(
      id: data['id'],
      name: data['name'],
      type: data['type'],
      entityId: data['entityId'],
      lat: data['lat'],
      lon: data['lon'],
      maxCapacity: data['maxCapacity'],
      occupation: data['occupation'],
      occupationTimestamp: data['occupationTimestamp'],
      active: data['active'] == 1,
    );
  }

  Future<bool> saveToDb(Database db) async {
    return await db.insert('parks', {
          'id': id,
          'name': name,
          'type': type,
          'entityId': entityId,
          'lat': lat,
          'lon': lon,
          'maxCapacity': maxCapacity,
          'occupation': occupation,
          'occupationTimestamp': occupationTimestamp,
          'active': active ? 1 : 0,
        }) ==
        1;
  }

  int getIdAsInt() {
    return int.parse(id.substring(1));
  }

  double? getDistanceInKm(AppData appData) {
    double? deviceLat = appData.lat;
    double? deviceLon = appData.lon;

    if (deviceLat == null || deviceLon == null) return null;
    return Geolocator.distanceBetween(
        deviceLat, deviceLon, double.parse(lat), double.parse(lon));
  }

  double getOccupationPercentage() {
    return occupation / maxCapacity * 100;
  }

  Future<List<ParkIncident>> getIncidents(Database db) async {
    final List<ParkIncident> incidents = [];
    final data = await db.query(
      'park_incidents',
      where: 'parkId = ?',
      whereArgs: [id],
    );
    for (var item in data) {
      incidents.add(ParkIncident.fromDb(item));
    }
    return incidents;
  }
}
