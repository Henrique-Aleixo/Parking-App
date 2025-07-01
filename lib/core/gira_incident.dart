import 'package:sqflite/sqflite.dart';

class GiraIncident {
  final String stationId;
  final String description;
  final String problemType;
  final DateTime timestamp;

  GiraIncident(
    this.stationId,
    this.description,
    this.problemType,
    this.timestamp,
  );

  factory GiraIncident.fromDb(Map<String, dynamic> data) {
    return GiraIncident(
      data['stationId'],
      data['description'],
      data['problemType'],
      DateTime.parse(data['datetime']),
    );
  }

  Future<bool> saveToDb(Database db) async {
    return await db.insert('gira_incidents', {
          'stationId': stationId,
          'description': description,
          'problemType': problemType,
          'datetime': timestamp.toIso8601String(),
        }) ==
        1;
  }
}
