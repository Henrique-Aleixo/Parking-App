import 'dart:async';
import 'dart:collection';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emel_parking_app_henrique/api/api.dart';
import 'package:emel_parking_app_henrique/core/gira.dart';
import 'package:emel_parking_app_henrique/core/location_service.dart';
import 'package:emel_parking_app_henrique/core/park.dart';
import 'package:emel_parking_app_henrique/core/park_utils.dart';
import 'package:emel_parking_app_henrique/data/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';

class AppData extends ChangeNotifier {
  Timer? _apiTimer;

  // PARKS
  List<Park> parks = [];
  Park? detailsPagePark;
  Queue<String> lastAccessedParkIds = Queue(); // max of 2 items

  // GIRAS
  List<GiraStation> giras = [];
  GiraStation? detailsPageGira;

  // DEVICE LOCATION
  double? lat;
  double? lon;

  AppData() {
    // Load data at startup
    loadStartupData();
  }

  Future<void> loadStartupData() async {
    await LocalDatabase.init();
    Database db = LocalDatabase.db;

    getDeviceGeolocation();

    await getParkDataFromDb(db);
    await getGiraDataFromDb(db);
    updateParkingLots(db);
    updateGiraStations(db);

    _fetchApiDataPeriodically(const Duration(seconds: 30), LocalDatabase.db);
    _fetchDeviceGeolocationPeriodically(const Duration(seconds: 15));
  }

  Future<bool> _hasInternetConnection() async {
    final connectivity = await (Connectivity().checkConnectivity());
    return connectivity.contains(ConnectivityResult.mobile) ||
        connectivity.contains(ConnectivityResult.wifi);
  }

  void _fetchApiDataPeriodically(Duration duration, Database db) {
    _apiTimer = Timer.periodic(duration, (_) {
      updateParkingLots(db);
      updateGiraStations(db);
    });
  }

  void _fetchDeviceGeolocationPeriodically(Duration duration) {
    _apiTimer = Timer.periodic(duration, (_) {
      getDeviceGeolocation();
    });
  }

  void updateParkingLots(Database db) async {
    if (!(await _hasInternetConnection())) {
      return;
    }
    final parkData = await ApiFetcher.fetchParkingLots();
    parks = parkData;
    saveParkDataToDb(db);
    notifyListeners();
  }

  void updateGiraStations(Database db) async {
    if (!(await _hasInternetConnection())) {
      return;
    }
    final giraData = await ApiFetcher.fetchGiraStations();
    giras = giraData;
    saveGiraDataToDb(db);
    notifyListeners();
  }

  Future<void> getParkDataFromDb(Database db) async {
    final data = await db.rawQuery('SELECT * FROM parks');
    parks = [];
    for (var item in data) {
      parks.add(Park.fromDb(item));
    }
    notifyListeners();
  }

  void saveParkDataToDb(Database db) async {
    // delete all data from table
    await db.execute('DELETE FROM parks');

    // save all parks to db
    for (var park in parks) {
      await park.saveToDb(db);
    }
  }

  Future<void> getGiraDataFromDb(Database db) async {
    final data = await db.rawQuery('SELECT * FROM giras');
    giras = [];
    for (var item in data) {
      giras.add(GiraStation.fromDb(item));
    }
    notifyListeners();
  }

  void saveGiraDataToDb(Database db) async {
    // delete all data from table
    await db.execute('DELETE FROM giras');

    // save all giras to db
    for (var gira in giras) {
      await gira.saveToDb(db);
    }
  }

  void getDeviceGeolocation() async {
    Position? position = await LocationService.getPosPhone();

    if (position != null) {
      lat = position.latitude;
      lon = position.longitude;
    }
    notifyListeners();
  }

  void updateLastAccessedParkIds(String parkId) {
    if (lastAccessedParkIds.contains(parkId)) return;
    if (lastAccessedParkIds.length == 2) lastAccessedParkIds.removeFirst();
    lastAccessedParkIds.add(parkId);
    notifyListeners();
  }

  Park? getLastAccessedPark1() {
    if (lastAccessedParkIds.length != 2) return null;
    Park? park = ParkUtils.getParkById(parks, lastAccessedParkIds.last);
    if (park == null) return null;
    return park;
  }

  Park? getLastAccessedPark2() {
    if (lastAccessedParkIds.isEmpty) return null;
    Park? park = ParkUtils.getParkById(parks, lastAccessedParkIds.first);
    if (park == null) return null;
    return park;
  }

  List<Park> getParksByDistanceClosestFirst() {
    List<Park> sortedParks = [...parks];
    sortedParks.sort((p1, p2) {
      double? p1Distance = p1.getDistanceInKm(this);
      double? p2Distance = p2.getDistanceInKm(this);

      if (p1Distance == null || p2Distance == null) return 0;
      return p1Distance.compareTo(p2Distance);
    });

    /*for (var item in sortedParks) {
      print('ITEM: ${item.getDistanceInKm(this)}');
    }*/
    return sortedParks;
  }

  @override
  void dispose() {
    super.dispose();
    _apiTimer?.cancel();
  }
}
