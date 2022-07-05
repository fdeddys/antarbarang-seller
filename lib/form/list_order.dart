import 'package:flutter/material.dart';

class ListOrder extends StatefulWidget {
  ListOrder({Key? key}) : super(key: key);

  @override
  State<ListOrder> createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("List Order"),);
  }
}