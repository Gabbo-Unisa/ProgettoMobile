import 'package:flutter/material.dart';

class SchermataProfilo extends StatefulWidget {
  const SchermataProfilo({super.key});

  @override
  State<SchermataProfilo> createState() => _SchermataProfiloState();
}

class _SchermataProfiloState extends State<SchermataProfilo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000B23),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profilo utente', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}