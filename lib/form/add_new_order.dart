import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:seller/dto/transaksi_dto.dart';
import 'package:seller/model/customer_model.dart';
import 'package:seller/model/response_model.dart';
import 'package:seller/model/transaksi_model.dart';
import 'package:seller/repository/customer.repository.dart';
import 'package:seller/repository/transaksi_repository.dart';
import 'package:seller/services/customer_service.dart';
import 'package:seller/services/transaksi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddNewOrder extends StatefulWidget {
  AddNewOrder({Key? key}) : super(key: key);

  @override
  State<AddNewOrder> createState() => _AddNewOrderState();
}

class _AddNewOrderState extends State<AddNewOrder> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    TextEditingController namaProductController = TextEditingController();
    TextEditingController keteranganController = TextEditingController();
    TextEditingController jamRequestController = TextEditingController();
    TextEditingController tanggalRequestController = TextEditingController();

    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0);

    late List<Customer> customerLists = [];
    String customerSelected2= "";
    int sellerId =0;

    Customer customerSelected =  Customer(0, 0, '', '', '', '', 0, '');
    @override
    void initState() {
        super.initState();
        getData();
    }

    getData() async {
        final prefs = await SharedPreferences.getInstance();
        sellerId = prefs.getInt('seller-id') ?? 0;

        CustomerService customerService = CustomerService(
            repository: CustomerRepository(httpClient: http.Client()));

        final List<Customer> result =
            await customerService.getByIdSeller(sellerId);

        print("result list customer ?");
        if (result.isNotEmpty ) {
            print("result not empty");
            // customerLists = json[result.contents] as List);
            setState(() {
                customerLists= result;
                customerSelected = customerLists[0];
                customerSelected2 = customerLists[0].id.toString();
            });
        }
    }

    addOrder() async {

        print("customer =$customerSelected2");
        print("customer =${customerSelected.id}");
         

        TransaksiService transaksiService = TransaksiService(
            repository: TransaksiRepository(httpClient: http.Client())
        );

        var tglAntar = DateFormat('yyyy-MM-dd').format(selectedDate);

        final jam = selectedTime.hour.toString().padLeft(2, '0');
        final menit = selectedTime.minute.toString().padLeft(2, '0');
        var jamAntar = '$jam:$menit:00';

        TransaksiDto transaksi =  TransaksiDto(
                0, 
                jamAntar, 
                tglAntar, 
                namaProductController.text, 
                namaProductController.text, 
                sellerId, 
                customerSelected.id);
    
        ResponseContentDto result = await transaksiService.saveNewOrder(transaksi);
        if (result.errCode == "00" ) {
            Fluttertoast.showToast(
                msg: "Save success !",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue[300],
                textColor: Colors.white70,
                fontSize: 20.0);
            
            setState(() {
                namaProductController.text="";
                keteranganController.text = "";
                customerSelected2 = customerLists[0].id.toString();
                selectedDate = DateTime.now();
                selectedTime = const TimeOfDay(hour: 9, minute: 0);
            });
            return ;
        }
        Fluttertoast.showToast(
            msg: "Save Failed !" + result.errDesc,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[300],
            textColor: Colors.white70,
            fontSize: 20.0
        );
        
       
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: const Text("New Order"),
        ),
        body: Form(
            key: _formKey,
            child: (SingleChildScrollView(
                child: panelInput(),
            ))),
        );
    }

    Widget panelInput() {
        return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    inputProductName(),
                    inputKeterangan(),
                    tanggalAntar(),
                    jamAntar(),
                    customerPanel(),
                    btnSaveOrder(),
                ],
            ),
        );
    }

    Widget customerPanel() {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    const Text("Customer "),
                    listCustomer3(),
                    // Container(
                    //     padding: const EdgeInsets.all(8.0),
                    //     width: MediaQuery.of(context).size.width / 2,
                    //     child: listCustomer()),
                ],
            ),
        );
    }

    Widget listCustomer3() {
        return
            DropdownButton2(
                isExpanded: true,
                hint: Text(
                    'Select Item',
                    style: TextStyle(
                    fontSize: 14,
                    color: Theme
                            .of(context)
                            .hintColor,
                    ),
                ),
                items: customerLists
                    .map((customer) =>
                        DropdownMenuItem<String>(
                            value: customer.id.toString(),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                    customer.nama,
                                    style: const TextStyle(
                                        fontSize: 14,
                                    ),
                                ),
                            ),
                        ))
                    .toList(),
                value: customerSelected2,
                onChanged: (value) {
                    setState(() {
                        customerSelected2 = value as String;
                    });
                },
                buttonHeight: 40,
                buttonWidth:  MediaQuery.of(context).size.width / 2,
                buttonPadding: const EdgeInsets.only(left: 8),
                itemHeight: 40,
                buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.red,
                    ),
                    color: Colors.blue.shade500,
                ).copyWith(
                    boxShadow: kElevationToShadow[3],
                ),
                dropdownElevation : 5,
            );  
    }

    Widget listCustomer() {
        return DropdownButton<Customer>(
            value: customerSelected,
            icon: const Icon(Icons.keyboard_arrow_down),
            // alignment : AlignmentDirectional.bottomEnd,
            style: const TextStyle(color: Color.fromARGB(255, 32, 147, 241) ,),
            onChanged: (Customer? newValue) {
                setState(() {
                    customerSelected = newValue!;
                });
            },
            selectedItemBuilder: (BuildContext context) {
                return customerLists.map((Customer customer) {
                    return Text(
                        customer.nama,
                        style: const TextStyle(color: Colors.red),
                    );
                }).toList();
            },
            items: customerLists.map<DropdownMenuItem<Customer>>((Customer customer) {
                return DropdownMenuItem<Customer>(
                    value: customer,
                    alignment : AlignmentDirectional.center,
                    child: Text(
                        customer.nama,
                        style:const TextStyle(
                            color:  Colors.red,
                        ),
                    ),
                );
            }).toList(),
        );
    }

    Widget inputProductName() {
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
        controller: namaProductController,
        decoration: const InputDecoration(
            labelText: "Name Barang",
            fillColor: Colors.black87,
            icon: Icon(Icons.account_circle)),
        );
    }

    Widget inputKeterangan() {
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
        controller: keteranganController,
        decoration: const InputDecoration(
            labelText: "Keterangan",
            fillColor: Colors.black87,
            icon: Icon(Icons.account_circle)),
        );
    }

    Widget tanggalAntar() {
        return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    const Text("Tanggal Antar "), 
                    btnTanggalAntar()
                ],
            ),
        );
    }

    Widget btnTanggalAntar() {
        return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blue.shade500,
        child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
            pickDate(context);
            },
            child: Text(
            "${getTextTanggalAntar()} ",
            textAlign: TextAlign.center,
            style:
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
        ),
        );
    }

    Future pickDate(BuildContext context) async {
        final initialDate = DateTime.now();
        // final firstDate = DateTime(DateTime.now().year -0);
        final lastDate = DateTime(DateTime.now().year + 1);
        final newDate = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: initialDate,
            lastDate: lastDate);
        if (newDate == null) return;
        setState(() {
            selectedDate = newDate;
        });
    }

    String getTextTanggalAntar() {
        if (selectedDate == null) {
            return 'Select Tanggal Antar';
        }
        // return '${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}';
        return DateFormat('dd-MMM-yyyy').format(selectedDate);
    }

    Widget jamAntar() {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [const Text("Jam Antar "), btnJamAntar()],
            ),
        );
    }

    Widget btnJamAntar() {
        return Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blue.shade500,
            child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width / 2,
                padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                    pickTime(context);
                },
                child: Text(
                    "${getTextJamAntar()} ",
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
            ),
        );
    }

    Future pickTime(BuildContext context) async {
        // final initialTime = TimeOfDay(hour: 9, minute: 0);
        final newTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (context, child) {
            return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container(),
            );
        },
        );
        if (newTime == null) return;
        setState(() {
        selectedTime = newTime;
        });
    }

    String getTextJamAntar() {
        if (selectedTime == null) {
            return 'Select Jam Antar';
        }
        final jam = selectedTime.hour.toString().padLeft(2, '0');
        final menit = selectedTime.minute.toString().padLeft(2, '0');
        return '$jam : $menit ';
        // return TimeOfDayFormat.values ('dd-MMM-yyyy').format(selectedTime);
    }

    Widget btnSaveOrder() {
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
                        addOrder();
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
