import 'package:emel_parking_app_henrique/core/gira.dart';
import 'package:emel_parking_app_henrique/core/location_service.dart';
import 'package:emel_parking_app_henrique/core/park.dart';
import 'package:emel_parking_app_henrique/data/app_data.dart';
import 'package:emel_parking_app_henrique/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late AppData appData;
  late GoogleMapController mapController;
  late Future<LatLng?> _phoneLocFuture;
  late List<Park> _parks;
  late List<GiraStation> _bikes;
  final ValueNotifier<bool> _showParks = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _phoneLocFuture = _getPhoneLoc();
  }

  @override
  void didChangeDependencies() {
    appData = context.read<AppData>();
    _parks = appData.parks;
    _bikes = appData.giras;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<LatLng?> _getPhoneLoc() async {
    Position? position = await LocationService.getPosPhone();
    if (position != null) {
      return LatLng(position.latitude, position.longitude);
    } else {
      return null;
    }
  }

  void _toggleMarkers() {
    _showParks.value = !_showParks.value;
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.read<AppData>();
    final mainAppPage = context.read<MainPageViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: Future.wait([_phoneLocFuture]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error")); //TO-DO OFFLINE CONNECTION
              } else {
                final LatLng? _phoneLoc = snapshot.data![0]
                    as LatLng?; // Can be used to display user position in the map

                List<Park> parks = _parks;
                List<GiraStation> bikePoints = _bikes;

                return ValueListenableBuilder<bool>(
                  valueListenable: _showParks,
                  builder: (context, showParks, child) {
                    List<Marker> markers = [];

                    if (showParks) {
                      for (var park in parks) {
                        markers.add(Marker(
                            markerId: MarkerId(park.name), // Marker unique ID
                            position: LatLng(
                                double.parse(park.lat),
                                double.parse(park
                                    .lon)), // Position or marker in Google Maps
                            onTap: () {
                              appData.detailsPagePark = park;
                              mainAppPage.currentPageIndex = 4;
                            }));
                      }
                    } else {
                      for (var bikePoint in bikePoints) {
                        List<String> coordinates =
                            bikePoint.coordinates.split(',');

                        String lat = coordinates[0];
                        String lon = coordinates[1];
                        markers.add(Marker(
                            markerId:
                                MarkerId(bikePoint.id), // Marker unique ID
                            position: LatLng(
                                double.parse(lat),
                                double.parse(
                                    lon)), // Position or marker in Google Maps
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor
                                    .hueGreen), // Set marker color as green
                            onTap: () {
                              appData.detailsPageGira = bikePoint;
                              mainAppPage.currentPageIndex = 5;
                            }));
                      }
                    }

                    if (_phoneLoc != null) {
                      markers.add(
                        Marker(
                          markerId:
                              MarkerId('phoneLoc'), // Phone Marker unique ID
                          position:
                              _phoneLoc, // Position of phone in Google Maps
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor
                                  .hueBlue), // Set marker color as blue
                        ),
                      );
                    }

                    return GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                          target: _phoneLoc ?? LatLng(38.756911, -9.154712),
                          zoom: 14.0), // Set Initial Camera Pos
                      markers:
                          Set<Marker>.of(markers), // Set markers in Google Maps
                    );
                  },
                );
              }
            },
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
                SizedBox(height: 10)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
