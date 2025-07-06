import 'dart:io';
import 'package:flutter/material.dart';

import '../models/vinile.dart';
import 'dettaglio_vinile.dart';

class ViniliListView extends StatelessWidget {
  final List<Vinile> vinili;
  final String messaggio;

  const ViniliListView({
    super.key,
    required this.vinili,
    required this.messaggio,
  });

  @override
  Widget build(BuildContext context) {
    if (vinili.isEmpty) {
      return Center(child: Text(messaggio));
    }

    return ListView.builder(
      itemCount: vinili.length,
      itemBuilder: (context, index) {
        final vinile = vinili[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(
              8,
            ), // stesso raggio per entrambi
            child:
                vinile.copertina != null
                    ? SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.file(
                        File(vinile.copertina!),
                        fit: BoxFit.cover,
                      ),
                    )
                    : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.album,
                        size: 32,
                        color: Colors.grey,
                      ),
                    ),
          ),
          title: Text(vinile.titolo),
          subtitle: Text(vinile.artista),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DettaglioVinile(vinile: vinile),
              ),
            );
          },
        );
      },
    );
  }
}
