import 'package:emel_parking_app_henrique/core/park_utils.dart';
import 'package:emel_parking_app_henrique/data/app_data.dart';
import 'package:emel_parking_app_henrique/ui/park_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final parks = appData.getParksByDistanceClosestFirst();
    final nearestParks = ParkUtils.sortByNearest(parks);
    final lastAccessedPark1 = appData.getLastAccessedPark1();
    final lastAccessedPark2 = appData.getLastAccessedPark2();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nearby',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            if (nearestParks.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Center(
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            if (nearestParks.length >= 1) ParkListItem(park: nearestParks[0]),
            const SizedBox(height: 12),
            if (nearestParks.length >= 2) ParkListItem(park: nearestParks[1]),
            const SizedBox(height: 12),
            if (nearestParks.length >= 3) ParkListItem(park: nearestParks[2]),
            const SizedBox(height: 20),
            const Text(
              'Last accessed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (lastAccessedPark1 == null && lastAccessedPark2 == null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(
                  child: Text(
                    'No history',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (lastAccessedPark1 != null)
              ParkListItem(park: lastAccessedPark1),
            const SizedBox(height: 12),
            if (lastAccessedPark2 != null)
              ParkListItem(park: lastAccessedPark2),
          ],
        ),
      ),
    );
  }
}
