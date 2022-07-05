import 'package:flutter/material.dart';

class HistoryOrder extends StatefulWidget {
  HistoryOrder({Key? key}) : super(key: key);

  @override
  State<HistoryOrder> createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("History"),);
  }
}