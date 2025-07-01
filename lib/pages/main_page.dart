import 'package:emel_parking_app_henrique/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPageViewModel extends ChangeNotifier {
  int _currentPageIndex = 0;

  int get currentPageIndex => _currentPageIndex;

  set currentPageIndex(int value) {
    _currentPageIndex = value;
    notifyListeners();
  }
}

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final mainPageViewModel = context.watch<MainPageViewModel>();
    int currentPageIndex = mainPageViewModel._currentPageIndex;
    bool indexInNavbar = pages[currentPageIndex].inNavbar;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(pages[currentPageIndex].title),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 55),
        child: pages[currentPageIndex].widget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.indigo,
        unselectedItemColor: Colors.black,
        selectedItemColor: !indexInNavbar ? Colors.black : Colors.white,
        currentIndex: !indexInNavbar ? 0 : currentPageIndex,
        onTap: (idx) {
          setState(() {
            mainPageViewModel.currentPageIndex = idx;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Incident',
          ),
        ],
      ),
      extendBody: true,
    );
  }
}
