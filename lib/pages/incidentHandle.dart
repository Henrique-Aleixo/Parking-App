import 'package:emel_parking_app_henrique/pages/incident.dart';
import 'package:emel_parking_app_henrique/pages/incidentGira.dart';
import 'package:flutter/material.dart';

class IncidentPage extends StatefulWidget {
  const IncidentPage({super.key});

  @override
  State<IncidentPage> createState() => _IncidentPageState();
}

class _IncidentPageState extends State<IncidentPage> {
  final PageController _pageController = PageController();
  bool isParkIncident = true;

  void _toggleMarkers() {
    setState(() {
      isParkIncident = !isParkIncident;
    });
    _pageController.animateToPage(
      isParkIncident ? 0 : 1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              Incident(),
              BikeIncidentPage(),
            ],
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _toggleMarkers,
                  child: Icon(Icons.swap_horiz),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
