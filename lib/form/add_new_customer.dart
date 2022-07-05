import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller/model/customer_model.dart';
import 'package:seller/model/response_model.dart';
import 'package:seller/repository/customer.repository.dart';
import 'package:seller/services/customer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddCustomer extends StatefulWidget {
  AddCustomer({Key? key}) : super(key: key);

  @override
  State<AddCustomer> createState() => _CustomerState();
}

class _CustomerState extends State<AddCustomer> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textNameController = TextEditingController();
  TextEditingController textHpController = TextEditingController();
  TextEditingController textAddressController = TextEditingController();

  CustomerService customerService = CustomerService(
      repository: CustomerRepository(httpClient: http.Client()));

  loginPress() async {
    final prefs = await SharedPreferences.getInstance();
    final int sellerId = (prefs.getInt('seller-id') ?? 0);

    Customer customer = Customer(0, sellerId, textNameController.text,
        textHpController.text, textAddressController.text, "", 0, "");

    ResponseContentDto response = await customerService.save(customer);

    if (response.errCode == '00'){
        Fluttertoast.showToast(
            msg: "Save success !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white70,
            fontSize: 20.0);
        return;
    } else {
      Fluttertoast.showToast(
            msg: "Save Failed !" + response.contents,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[300],
            textColor: Colors.white70,
            fontSize: 20.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New customer")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [space(), panelInput()],
          ),
        ),
      ),
    );
  }

  Widget space() {
    return const SizedBox(height: 10);
  }

  Widget panelInput() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          inputNameCustomer(),
          inputHpCustomer(),
          inputAddressCustomer(),
          space(),
          btnSave()
        ],
      ),
    );
  }

  Widget inputNameCustomer() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      maxLines: 1,
      style: const TextStyle(
        color: Colors.black87,
      ),
      autofocus: true,
      maxLength: 50,
      controller: textNameController,
      decoration: const InputDecoration(
          labelText: "Name",
          fillColor: Colors.black87,
          icon: Icon(Icons.account_circle)),
    );
  }

  Widget inputHpCustomer() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      maxLines: 1,
      style: const TextStyle(
        color: Colors.black87,
      ),
      autofocus: true,
      maxLength: 30,
      controller: textHpController,
      decoration: const InputDecoration(
          labelText: "Hp", fillColor: Colors.black87, icon: Icon(Icons.phone)),
    );
  }

  Widget inputAddressCustomer() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      maxLines: 4,
      style: const TextStyle(
        color: Colors.black87,
      ),
      autofocus: true,
      maxLength: 200,
      controller: textAddressController,
      decoration: const InputDecoration(
          labelText: "Address",
          fillColor: Colors.black87,
          icon: Icon(Icons.home)),
    );
  }

  Widget btnSave() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(22.0),
        color: Colors.blue.shade900,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width - 40,
          padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              loginPress();
            }
          },
          child: const Text(
            "Save",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
