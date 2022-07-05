import 'package:flutter/material.dart';
import 'package:seller/form/add_new_customer.dart';
import 'package:seller/form/add_new_order.dart';
import 'package:seller/form/history_order.dart';
import 'package:seller/form/list-order/list_order_page.dart';
import 'package:seller/form/list_order.dart';
import 'package:seller/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  String? userName = 'tes-system';
  String? sellerName = 'tes-system';

  getData() async {
     final prefs = await SharedPreferences.getInstance();
     setState(() {
        userName =  prefs.getString('seller-kode');
        sellerName =  prefs.getString('seller-nama');
     });
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerSeller(),
      appBar: AppBar(title: const Text("Seller App")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [Text("Welcome")],
          )
        ],
      ),
    );
  }

  Widget drawerSeller() {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            drawerHeader(),
            _drawerItem(
                icon: Icons.add,
                namaMenu: 'New Customer',
                onTap: () => newCustomerMenu()),
            _drawerItem(
                icon: Icons.add,
                namaMenu: 'New Order',
                onTap: () => newOrderMenu()),
            _drawerItem(
                icon: Icons.list_rounded,
                namaMenu: 'List Order History',
                onTap: () => listOrderMenu()),
            // _drawerItem(
            //     icon: Icons.done_all,
            //     namaMenu: 'History Order',
            //     onTap: () => historyOrderMenu()),
            const Divider(height: 25, thickness: 1),
            _drawerItem(
                icon: Icons.logout,
                namaMenu: 'Logout',
                onTap: () => logoutMenu()),
          ],
        ),
      ),
    );
  }

  drawerHeader() {
    return UserAccountsDrawerHeader(
        currentAccountPicture: const ClipOval(
          child: Image(
              image: AssetImage('images/toko.png'),
              fit: BoxFit.cover),
        ),
        accountName: Text('$sellerName '),
        accountEmail: Text('Welcome $userName .. '));
  }

  Widget _drawerItem({icon, namaMenu, onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              namaMenu,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  newCustomerMenu() async {
    debugPrint("New Customer menu");
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCustomer()));
  }

  newOrderMenu() async {
    debugPrint("New Order menu");
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewOrder()));
  }

  listOrderMenu() async {
    debugPrint("List Order menu");
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListOrderPage()));
  }

  historyOrderMenu() async {
    debugPrint("History  menu");
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HistoryOrder()));
  }

  logoutMenu() async {
    print("Logout menu");
    Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
        );
  }
}
