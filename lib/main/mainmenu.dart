import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Expanded(
            child: Column(
          children: [Text("Text 1"), Text("Text 2"), Text("Text 3")],
        ))
      ],
    ));
  }
}
