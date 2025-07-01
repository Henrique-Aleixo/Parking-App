import 'package:emel_parking_app_henrique/core/gira_incident.dart';
import 'package:emel_parking_app_henrique/data/database.dart';
import 'package:emel_parking_app_henrique/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:emel_parking_app_henrique/core/gira.dart';
import 'package:provider/provider.dart';
import 'package:emel_parking_app_henrique/data/app_data.dart';

class BikeIncidentPage extends StatefulWidget {
  const BikeIncidentPage({super.key});

  @override
  State<BikeIncidentPage> createState() => _BikeIncidentPageState();
}

class _BikeIncidentPageState extends State<BikeIncidentPage> {
  String? giraId;
  String? description;
  String? problemType;
  final _descriptionController = TextEditingController();
  DateTime date = DateTime.now();

  Future<DateTime?> selectDate(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
  }

  Future<TimeOfDay?> selectTime(BuildContext context) {
    return showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
        initialEntryMode: TimePickerEntryMode.input,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });
    }

  @override
  Widget build(BuildContext context) {
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');

    return Container(
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 38),
                Row(
                  children: const [
                    Text('Station ID',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 17),
                Center(
                    child: dropDownGiraStations(context.read<AppData>().giras)),
                SizedBox(height: 17),
                Text('Problem Type',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 17),
                Center(child: dropDownProblemType()),
                SizedBox(height: 17),
                Text('Description',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 17),
                Center(child: descriptionField()),
                SizedBox(height: 17),
                Text('Time',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: calendarBtn()),
                    SizedBox(width: 30),
                    Expanded(child: timeBtn(hours, minutes, context)),
                  ],
                ),
                SizedBox(height: 50),
                Center(child: submitBtn())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownGiraStations(List<GiraStation> giraStations) {
    giraStations.sort((station1, station2) => station1.id.compareTo(station2.id));
    return Container(
      child: DropdownMenu(
        width: MediaQuery.of(context).size.width - 40,
        label: Text('Select station'),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.indigo.withOpacity(0.4),
        ),
        dropdownMenuEntries: <DropdownMenuEntry<String>>[
          for (var station in giraStations)
            DropdownMenuEntry(value: station.id, label: station.id),
        ],
        onSelected: (selectedStation) {
          if (selectedStation != null) {
            setState(() {
              giraId = selectedStation;
            });
          }
        },
      ),
    );
  }

  Widget dropDownProblemType() {
    return DropdownMenu(
      label: Text('Select problem type'),
      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(
            value: 'Bicycle vandalised', label: 'Bicycle vandalised'),
        DropdownMenuEntry(
            value: 'Dock did not release bike',
            label: 'Dock did not release bike'),
        DropdownMenuEntry(value: 'Other situation', label: 'Other situation'),
      ],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.indigo.withOpacity(0.4),
      ),
      width: MediaQuery.of(context).size.width - 40,
      onSelected: (problemUpdated) {
        if (problemUpdated != null) {
          setState(() {
            problemType = problemUpdated;
          });
        }
      },
    );
  }

  Widget descriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: null,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Insert description (min 20 characters)',
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 40,
          maxHeight: double.infinity,
        ),
        fillColor: Colors.indigo.withOpacity(0.4),
        border: OutlineInputBorder(),
      ),
      onChanged: (text) {
        setState(() {
          description = text;
        });
      },
    );
  }

   Widget calendarBtn() {
    return ElevatedButton.icon(
      icon: Icon(Icons.calendar_month),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        fixedSize: MaterialStatePropertyAll(Size(100, 50)),
        backgroundColor:
            MaterialStateProperty.all<Color?>(Colors.indigo.shade100),
      ),
      label: Text('${date.day}-${date.month}-${date.year}'),
      onPressed: () async {
        var date = await selectDate(context);
        if (date != null) {
          final newDateTime =
              DateTime(date.year, date.month, date.day, date.hour, date.minute);
          setState(() {
            date = newDateTime;
          });
        }
      },
    );
  }

  Widget timeBtn(String hours, String minutes, BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.access_time_rounded),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        fixedSize: MaterialStatePropertyAll(Size(100, 50)),
        backgroundColor:
            MaterialStateProperty.all<Color?>(Colors.indigo.shade100),
      ),
      label: Text('${hours}:${minutes}'),
      onPressed: () async {
        final time = await selectTime(context);
        if (time != null) {
          final dateUpdated = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          setState(() {
            date = dateUpdated;
          });
        }
      },
    );
  }

  Widget submitBtn() {
    return ElevatedButton(
      child: Text('Submit Incident'),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        backgroundColor: MaterialStateProperty.all<Color?>(
            Color.fromARGB(255, 67, 202, 123)),
        foregroundColor: MaterialStatePropertyAll(Colors.white),
        fixedSize: MaterialStatePropertyAll(Size(200, 50)),
      ),
      onPressed: () {
        if (giraId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a station')),
          );
          return;
        }

        if (problemType == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a problem type')),
          );
          return;
        }

        if (_descriptionController.text.length < 20) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Description must be at least 20 characters long')),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incident submitted successfully!')),
        );

        GiraIncident giraIncident = GiraIncident(giraId!, description!, problemType!, date);

        giraIncident.saveToDb(LocalDatabase.db);

      },
    );
  }
}
