import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nobo_kormo/screens/main/resources_screen.dart';

import 'package:provider/provider.dart';

import '../../config/api_config.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_provider.dart';
import '../../providers/social_provider.dart';
import '../profile/profile_screen.dart';
import '../social/social_feed_screen.dart';
import 'dashboard_screen.dart';
import 'jobs_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      final socialProvider = Provider.of<SocialProvider>(context, listen: false);

      dataProvider.fetchAllData();
      if (user != null) {
        dataProvider.fetchMatchingData(user);
      }
      socialProvider.fetchPosts();
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const JobsScreen(),
    const ResourcesScreen(),
    const SocialFeedScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.briefcase), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.bookOpen), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Social'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }
}