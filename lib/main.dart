import 'package:emel_parking_app_henrique/data/app_data.dart';
import 'package:emel_parking_app_henrique/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppData()),
    ChangeNotifierProvider(create: (context) => MainPageViewModel()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emel Parking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade300,
              ); // Color of the selected label
            }
            return TextStyle(
              color: Colors.black,
            ); // Color of the unselected labels
          }),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(
                color: Colors.grey.shade300,
              ); // Color of the selected icon
            }
            return IconThemeData(
              color: Colors.black,
            ); // Color of the unselected icons
          }),
        ),
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}
