import 'package:emel_parking_app_henrique/core/gira_incident.dart';
import 'package:emel_parking_app_henrique/data/app_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';

class GiraStation {
  String id;
  int numDocks;
  int numBikes;
  String address;
  String coordinates;
  String serviceLevel;
  String state;
  String lastUpdateTimestamp;

  GiraStation({
    required this.id,
    required this.numDocks,
    required this.numBikes,
    required this.address,
    required this.coordinates,
    required this.serviceLevel,
    required this.state,
    required this.lastUpdateTimestamp,
  });

  factory GiraStation.fromDb(Map<String, dynamic> data) {
    return GiraStation(
        id: data['id'].toString(),
        numDocks: data['numDocks'],
        numBikes: data['numBikes'],
        address: data['address'],
        coordinates: data['coordinates'],
        serviceLevel: data['serviceLevel'],
        state: data['state'],
        lastUpdateTimestamp: data['lastUpdateTimestamp']);
  }

  Future<bool> saveToDb(Database db) async {
    return await db.insert('giras', {
          'id': id,
          'numDocks': numDocks,
          'numBikes': numBikes,
          'address': address,
          'coordinates': coordinates,
          'serviceLevel': serviceLevel,
          'state': state,
          'lastUpdateTimestamp': lastUpdateTimestamp,
        }) ==
        1;
  }

  double getOccupationPercentage() {
    return numBikes / numDocks * 100;
  }

  double? getDistanceInKm(AppData appData) {
    double? deviceLat = appData.lat;
    double? deviceLon = appData.lon;

    if (deviceLat == null || deviceLon == null) return null;

    double lat = double.parse(coordinates.split(',')[0]);
    double lon = double.parse(coordinates.split(',')[1]);
    return Geolocator.distanceBetween(deviceLat, deviceLon, lon, lat);
  }

  Future<List<GiraIncident>> getIncidents(Database db) async {
    final List<GiraIncident> incidents = [];
    final data = await db.query(
      'gira_incidents',
      where: 'stationId = ?',
      whereArgs: [id],
    );
    for (var item in data) {
      incidents.add(GiraIncident.fromDb(item));
    }
    return incidents;
  }
}
