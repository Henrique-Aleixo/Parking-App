import 'package:sqflite/sqflite.dart';

class ParkIncident {
  final String parkId;
  final String description;
  final int severity;
  final DateTime timestamp;

  ParkIncident(this.parkId, this.description, this.severity, this.timestamp);

  factory ParkIncident.fromDb(Map<String, dynamic> data) {
    return ParkIncident(
      data['parkId'],
      data['description'],
      data['severity'],
      DateTime.parse(data['datetime']),
    );
  }

  Future<bool> saveToDb(Database db) async {
    return await db.insert('park_incidents', {
          'parkId': parkId,
          'description': description,
          'severity': severity,
          'datetime': timestamp.toIso8601String(),
        }) ==
        1;
  }
}
