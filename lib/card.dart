import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key, required this.button1Text, required this.button2Text});

  final String button1Text;
  final String button2Text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.music_note_outlined),
            title: Text("The Card Item. Go for it now!"),
            subtitle: Text("Bla-bla-bla"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: Text(button1Text),
                onPressed: () {},
              ),
              TextButton(
                child: Text(button2Text),
                onPressed: () {},
              ),
              const SizedBox(width: 8)
            ],
          )
        ],
      )
    );
  }
}