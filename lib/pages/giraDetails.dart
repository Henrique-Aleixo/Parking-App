import 'package:emel_parking_app_henrique/core/gira_incident.dart';
import 'package:emel_parking_app_henrique/data/app_data.dart';
import 'package:emel_parking_app_henrique/data/database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class GiraDetails extends StatelessWidget {
  const GiraDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = context.read<AppData>();
    final gira = appData.detailsPageGira!;
    final db = LocalDatabase.db;

    return Container(
      padding: EdgeInsets.only(top: 30, right: 30, left: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gira Station #${gira.id}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: CircularPercentIndicator(
                radius: 100,
                lineWidth: 20,
                percent: gira.getOccupationPercentage() / 100,
                center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${gira.getOccupationPercentage().toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.indigo.shade400,
                        ),
                      ),
                      Text(
                        'Occupied',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade400,
                        ),
                      ),
                    ]),
                progressColor: Colors.indigo.shade400,
                backgroundColor: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Capacity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${gira.numBikes}/${gira.numDocks}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${gira.getDistanceInKm(appData) != null ? gira.getDistanceInKm(appData)!.toStringAsFixed(0) : '-'} m',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          gira.state,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Typology',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Bikes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GPS Coordinates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  gira.coordinates,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  gira.address,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Incidents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FutureBuilder<List<GiraIncident>>(
                    future: gira.getIncidents(db),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<GiraIncident>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        List<Widget> widgets = [];

                        for (var incident in snapshot.data!) {
                          final ts = incident.timestamp;

                          widgets.add(
                            Container(
                              margin: EdgeInsets.only(bottom: 4),
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.indigo,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Problem Type: ${incident.problemType}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${ts.day}/${ts.month}/${ts.year} ${ts.hour}:${ts.minute}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    incident.description,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(children: widgets);
                      } else {
                        return Text(
                          'No Data',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        );
                      }
                    }),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
