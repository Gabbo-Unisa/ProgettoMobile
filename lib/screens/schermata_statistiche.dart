import 'package:flutter/material.dart';

class SchermataStatistiche extends StatefulWidget {
  const SchermataStatistiche({super.key});

  @override
  State<SchermataStatistiche> createState() => _SchermataStatisticheState();
}

class _SchermataStatisticheState extends State<SchermataStatistiche> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000B23),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Statistiche', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}