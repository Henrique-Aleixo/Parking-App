import 'package:emel_parking_app_henrique/data/app_data.dart';
import 'package:emel_parking_app_henrique/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/park.dart';

class ParkListItem extends StatelessWidget {
  const ParkListItem({super.key, required this.park});

  final Park park;

  @override
  Widget build(BuildContext context) {
    final appData = context.read<AppData>();
    final mainPageViewModel = context.watch<MainPageViewModel>();

    return InkWell(
      onTap: () {
        appData.detailsPagePark = park; // sets park for detail page
        appData.updateLastAccessedParkIds(park.id); // update last access parks
        mainPageViewModel.currentPageIndex = 4; // updates current page index
      },
      child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.4),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Colors.indigo, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    park.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.directions_car, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '${park.getOccupationPercentage().toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        ' (${park.occupation}/${park.maxCapacity})',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.check_circle, size: 20),
                      const SizedBox(width: 5),
                      Text('${park.active ? 'Active' : 'Not active'}')
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.update, size: 20),
                      const SizedBox(width: 5),
                      Text('${park.occupationTimestamp}')
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.place, size: 22),
                      Text(
                        '${park.getDistanceInKm(appData) != null ? park.getDistanceInKm(appData)!.toStringAsFixed(0) : '-'} m',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
