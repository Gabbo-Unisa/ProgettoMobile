import 'package:flutter/material.dart';

class Barrasotto extends StatelessWidget {
  const Barrasotto({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return NavigationBar(
        /*onDestinationSelected: (int index) {
      setState(() {
        currentPageIndex = index;
      });
    },*/
    indicatorColor: Colors.amber,
    /*selectedIndex: currentPageIndex,*/
    destinations: const <Widget>[
    NavigationDestination(
    selectedIcon: Icon(Icons.home),
    icon: Icon(Icons.home_outlined),
    label: 'Home',
    ),
    NavigationDestination(
    icon: Badge(child: Icon(Icons.notifications_sharp)),
    label: 'Notifications',
    ),
    NavigationDestination(
    icon: Badge(label: Text('2'), child: Icon(Icons.messenger_sharp)),
    label: 'Messages',
    ),
    ],
    );
}}
