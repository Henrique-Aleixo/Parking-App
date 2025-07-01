import 'package:emel_parking_app_henrique/data/app_data.dart';
import 'package:emel_parking_app_henrique/ui/park_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class List extends StatefulWidget {
  const List({super.key});

  @override
  State<List> createState() => _ListState();
}

class _ListState extends State<List> {
  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final parks = appData.getParksByDistanceClosestFirst();

    return ListView.builder(
      padding: EdgeInsets.only(top: 14, left: 14, right: 14),
      itemCount: parks.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: ParkListItem(park: parks[index]),
        );
      },
    );
  }
}
