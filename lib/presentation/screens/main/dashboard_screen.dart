import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/home_provider.dart';
import 'package:envqmon/presentation/providers/device_provider.dart';
import 'package:envqmon/presentation/screens/main/homes_list_screen.dart';
import 'package:envqmon/presentation/screens/main/devices_list_screen.dart';
import 'package:envqmon/presentation/screens/main/profile_screen.dart';
import 'package:envqmon/core/constants/app_constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomesListScreen(),
    const DevicesListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    if (authProvider.token != null) {
      await Future.wait([
        homeProvider.loadHomes(authProvider.token!),
        deviceProvider.loadDevices(authProvider.token!),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Homes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
