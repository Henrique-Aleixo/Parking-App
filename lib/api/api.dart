import 'dart:convert';

import 'package:emel_parking_app_henrique/core/gira.dart';
import 'package:emel_parking_app_henrique/core/park.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://emel.city-platform.com/opendata';
const String parksEndpoint = '$baseUrl/parking/lots';
const String girasEndpoint = '$baseUrl/gira/station/list';
const String apiKey = '93600bb4e7fee17750ae478c22182dda';

class ApiFetcher {
  static Future<List<Park>> fetchParkingLots() async {
    final response = await http.get(Uri.parse(parksEndpoint), headers: {
      'api_key': apiKey,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to get API data');
    }

    // get json data
    final data = json.decode(response.body) as List<dynamic>;

    // parse json data into objects
    List<Park> parks = (data
        .map((item) => Park.fromMap(item as Map<String, dynamic>))
        .toList());
    return parks;
  }

  static Future<List<GiraStation>> fetchGiraStations() async {
    final response = await http.get(Uri.parse(girasEndpoint), headers: {
      'api_key': apiKey,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to get API data');
    }

    // get gira stations json data
    final data = json.decode(response.body)['features'] as List<dynamic>;

    // parse json data into objects
    List<GiraStation> stations = data.map((item) {
      final itemData = item['properties'];
      final coordinates = "${itemData['bbox'][1]},${itemData['bbox'][0]}";

      return GiraStation(
        id: itemData['id_expl'],
        numDocks: itemData['num_docas'],
        numBikes: itemData['num_bicicletas'],
        address: itemData['desig_comercial'],
        coordinates: coordinates,
        serviceLevel: itemData['tipo_servico_niveis'],
        state: itemData['estado'],
        lastUpdateTimestamp: itemData['update_date'],
      );
    }).toList();

    return stations;
  }
}
