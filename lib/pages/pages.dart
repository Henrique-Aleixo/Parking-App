import 'package:emel_parking_app_henrique/pages/dashboard.dart';
import 'package:emel_parking_app_henrique/pages/details.dart';
import 'package:emel_parking_app_henrique/pages/giraDetails.dart';
import 'package:emel_parking_app_henrique/pages/list.dart';
import 'package:emel_parking_app_henrique/pages/map.dart';
import 'package:emel_parking_app_henrique/pages/incidentHandle.dart';

const pages = [
  (title: 'Dashboard', widget: Dashboard(), inNavbar: true),
  (title: 'List', widget: List(), inNavbar: true),
  (title: 'Map', widget: Map(), inNavbar: true),
  (title: 'Incident', widget: IncidentPage(), inNavbar: true),
  (title: 'Details Park', widget: Details(), inNavbar: false),
  (title: 'Details Gira', widget: GiraDetails(), inNavbar: false),
];
