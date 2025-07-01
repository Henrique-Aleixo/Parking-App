import 'package:emel_parking_app_henrique/core/park.dart';

class ParkUtils {
  ParkUtils._();

  static Park? getParkById(List<Park> parks, String parkId) {
    for (var park in parks) {
      if (park.id == parkId) return park;
    }
    return null;
  }

  static Park? getParkByName(List<Park> parks, String name) {
    for (var park in parks) {
      if (park.name == name) return park;
    }
    return null;
  }

  static List<Park> sortByNearest(List<Park> parks) {
    // TODO
    return parks;
  }
}
