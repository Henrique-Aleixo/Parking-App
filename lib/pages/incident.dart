import 'package:emel_parking_app_henrique/core/park.dart';
import 'package:emel_parking_app_henrique/core/park_incident.dart';
import 'package:emel_parking_app_henrique/core/park_utils.dart';
import 'package:emel_parking_app_henrique/data/app_data.dart';
import 'package:emel_parking_app_henrique/data/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Incident extends StatefulWidget {
  const Incident({super.key});

  @override
  State<Incident> createState() => _IncidentState();
}

class _IncidentState extends State<Incident> {
  Park? park;
  DateTime date = DateTime.now();
  String? description;
  int? gravity;

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
                    Text('Name',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 17),
                Center(child: dropDownParks(context.read<AppData>().parks)),
                SizedBox(height: 17),
                Text('Gravity',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 17),
                Center(child: dropDownGravity()),
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

  Widget dropDownParks(List<Park> parks) {
    parks.sort((park1, park2) => park1.name.compareTo(park2.name));
    return Container(
      child: DropdownMenu(
        width: MediaQuery.of(context).size.width - 40,
        label: Text('Select park'),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.indigo.withOpacity(0.4),
        ),
        dropdownMenuEntries: <DropdownMenuEntry<String>>[
          for (var park in parks)
            DropdownMenuEntry(value: park.name, label: park.name),
        ],
        onSelected: (selectedPark) {
          if (selectedPark != null) {
            setState(() {
              park = ParkUtils.getParkByName(parks, selectedPark);
            });
          }
        },
      ),
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

  Widget descriptionField() {
    return TextField(
      maxLines: null,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Insert description',
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

  Widget dropDownGravity() {
    return DropdownMenu(
      label: Text('Select gravity'),
      dropdownMenuEntries: const <DropdownMenuEntry<int>>[
        DropdownMenuEntry(value: 1, label: 'Very Light'),
        DropdownMenuEntry(value: 2, label: 'Light'),
        DropdownMenuEntry(value: 3, label: 'Moderate'),
        DropdownMenuEntry(value: 4, label: 'Severe'),
        DropdownMenuEntry(value: 5, label: 'Very Severe'),
      ],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.indigo.withOpacity(0.4),
      ),
      width: MediaQuery.of(context).size.width - 40,
      onSelected: (gravityUpdated) {
        if (gravityUpdated != null) {
          setState(() {
            gravity = gravityUpdated;
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
        if (park == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a park')),
          );
          return;
        }

        if (gravity == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a gravity')),
          );
          return;
        }

        if (description == null || description == '') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please insert a description')),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incident submitted successfully!')),
        );

        ParkIncident parkIncident =
            ParkIncident(park!.id, description!, gravity!, date);

        parkIncident.saveToDb(LocalDatabase.db);
      },
    );
  }
}
