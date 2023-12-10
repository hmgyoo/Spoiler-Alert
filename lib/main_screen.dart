import 'package:flutter/material.dart';
import 'package:spoiler_alert/views/camera_view.dart';
import 'package:spoiler_alert/views/image_picker_view.dart';
import 'package:spoiler_alert/views/sensors_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    // CameraView(),
    ImagePickerDemo(),
    SensorsView()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Spoiler Alert'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.image),
            label: 'Image Picker',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_tree_rounded),
            label: 'Sensors Value',
          ),
        ],
      ),
    );
  }
}
