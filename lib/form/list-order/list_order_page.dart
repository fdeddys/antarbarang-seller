
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:seller/form/list-order/detail_order_page.dart';
import 'package:seller/model/screen_argument.dart';
import 'package:seller/model/transaksi_model.dart';
import 'package:seller/repository/transaksi_repository.dart';
import 'package:seller/services/transaksi_service.dart';
import 'package:seller/util/mapUtils.dart';
import 'package:seller/util/util_signature.dart';

class ListOrderPage extends StatefulWidget {
    ListOrderPage({Key? key}) : super(key: key);

    @override
    State<ListOrderPage> createState() => _ListOrderPageState();
}

class _ListOrderPageState extends State<ListOrderPage> {

    final _formKeySearchListOrder = GlobalKey<FormState>();

    TextEditingController textSearchController = TextEditingController();
    int totalRecords = 0;
    int maxRecord =10;
    int page =1;
    List<Transaksi> transaksis = [];
    DateTime selectedDate = DateTime.now();

    TransaksiService transaksiService = 
        TransaksiService(
            repository: 
                TransaksiRepository(
                    httpClient: http.Client()
                )
            );

    @override
    void initState() {
        super.initState();
        getData();
    }

    getData() async {
        var sellerName = textSearchController.text;
        var tglAntar = DateFormat('yyyy-MM-dd').format(selectedDate);
        transaksis =
            await transaksiService.getBySeller(sellerName, tglAntar);
        setState(() => {
            debugPrint("Set state :" + transaksis.length.toString())
        });
        debugPrint("done get data async!");
    }

    searchPress() async {

        debugPrint('Search : Search press');
        getData();
        Fluttertoast.showToast(
            msg: "Search  !" ,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[300],
            textColor: Colors.white70,
            fontSize: 20.0);
        return;
    
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text("List Order")),
            body:  
                Form(
                    key: _formKeySearchListOrder,
                    child:
                        Padding(
                            padding: 
                                const EdgeInsets.all(8.0),
                                child: Column(
                                    children: [
                                        panelSearch(),
                                        // btnSearch(),
                                        panelList(),
                                    ],
                                ),
                        ),
                )
        );
    }


    Widget panelSearch(){
        return
            Card(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        children: [
                            panelTglAntar(),
                            const SizedBox(
                                height: 10,
                            ),
                            btnSearch()
                        ],
                    ),
                ),
            );
    }

    Widget panelTglAntar(){
        return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    const Text("Tanggal Transaksi "), 
                    btnTanggalAntar()
                ],
            ),
        );
    }

    Widget btnTanggalAntar() {
        return Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
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
                        const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                ),
        );
    }

    String getTextTanggalAntar() {
        if (selectedDate == null) {
            return 'Select Tanggal Antar';
        }
        // return '${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}';
        return DateFormat('dd-MMM-yyyy').format(selectedDate);
    }

    Future pickDate(BuildContext context) async {
        // final initialDate = DateTime.now();
        final firstDate = DateTime(DateTime.now().year -2);
        final lastDate = DateTime(DateTime.now().year + 1);
        final newDate = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: firstDate,
            lastDate: lastDate);
        if (newDate == null) return;
        setState(() {
            selectedDate = newDate;
        });
    }
    

    Widget textSearch(){
        return TextFormField(
            // validator: (value) {
            //     if (value == null || value.isEmpty) {
            //         return 'Please enter some text';
            //     }
            //         return null;
            // },
            maxLines: 1,
            style: const TextStyle(
                color: Colors.black87,
            ),
            // autofocus: true,
            maxLength: 100,
            controller: textSearchController,
            decoration: const InputDecoration(
                labelText: "Seller name",
                fillColor: Colors.black87,
                icon: Icon(Icons.account_circle)),
        );
    }

    Widget panelList(){
        return
            Expanded(
                child: ListView.builder(
                    controller: ScrollController(),
                    itemCount: transaksis.length ,
                    itemBuilder: (context, position) {
                        final transaksi = transaksis[position];
                        return Card(
                            child: 
                                Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: itemPanel(transaksi),
                                ),
                        );
                    }
                ),
            );
    }

    Widget itemPanel(Transaksi transaksi){
        return ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0,8,0,8),
              child:
                titlePanel(transaksi.sellerName, transaksi.sellerHp, transaksi.sellerAddress) 
            ),
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    namaCustomer(transaksi.customerName),
                    namaProduct(transaksi.namaProduct),
                    jamAntar(transaksi.jamRequestAntar, transaksi.tanggalRequestAntarStr),
                    keterangan(transaksi.keterangan),
                    statusName(transaksi.statusName),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            btnProses(transaksi),
                            btnOpenMap(transaksi),
                        ],
                    )
                ],
            ),
        );
    }

    Widget btnProses2(Transaksi transaksi){
        return ElevatedButton(
            onPressed: (){
                Navigator.pushNamed(
                    context, 
                    DetailOrderPage.routeName,
                    arguments: ScreenArgument(transaksi)
                );
            }, 
            child: const Text("Process...!")
        );
    }

     Widget btnProses(Transaksi transaksi){
        return 
            FloatingActionButton.extended(
                label: const Text('Proses..'), 
                backgroundColor: Colors.blue.shade400,
                icon: const Icon( 
                    Icons.power_rounded,
                    size: 12.0,
                ),
                foregroundColor: Colors.white,
                onPressed: () async {
                    Navigator.pushNamed(
                    context, 
                    DetailOrderPage.routeName,
                    arguments: ScreenArgument(transaksi)
                );
                },
            );
    }

    Widget btnOpenMap(Transaksi transaksi) {
        return
            FloatingActionButton.extended(
                label: const Text('Open Map'), 
                backgroundColor: Colors.red.shade400,
                icon: const Icon( 
                    Icons.map_rounded,
                    size: 12.0,
                ),
                foregroundColor: Colors.white,
                onPressed: () async {
                    if (Utilities.isNumeric(transaksi.custLat) && Utilities.isNumeric(transaksi.custLng) ) {

                        final lat = double.parse(transaksi.custLat);
                        final lng = double.parse(transaksi.custLng);    
                        if (_formKeySearchListOrder.currentState!.validate()) {
                            MapUtils.openMap( lat, lng);
                            // MapUtils.openMap(-6.175299,106.826965);
                        }
                    }
                },
            );
    }


    Widget titlePanel(String sellerName, String sellerHp, String sellerAddress){
        return
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    // const Text("Seller", style: const TextStyle(fontSize: 20, color: Colors.pinkAccent),),
                    namaSeller(sellerName, sellerHp )
                ],
            );
    }

    Widget namaSeller(String sellerName, String sellerHp) {
        return
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [ 
                    Text("$sellerName", style: const TextStyle(fontSize: 20, color: Colors.redAccent)),
                    Text("$sellerHp", style: const TextStyle(fontSize: 20, color: Colors.redAccent)),
                ],
            );
    }

    Widget namaCustomer(String customerName){
        return
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                    const Text("Customer", style: const TextStyle(fontSize: 16, color: Colors.green)),
                    Text("${customerName}", style: const TextStyle(fontSize: 16, color: Colors.greenAccent))
                ],
            );
    }

    Widget namaProduct(String nama){
        return
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                    const Text("Product"),
                    Text("${nama}")
                ],
            );
    }

    Widget jamAntar(String jam, String tanggal){
        return
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                    const Text("Waktu antar "),
                    Text("${tanggal} / ${jam}")
                ],
            );
    }
    
    Widget keterangan(String keterangan){
        return
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                    const Text("Keterangan"),
                    Text("${keterangan}")
                ],
            );
    }

    Widget statusName(String statusName){
        return
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                    const Text("Status"),
                    Text("${statusName}")
                ],
            );
    }

    Widget btnSearch() {
        return
            SizedBox(
                width: MediaQuery.of(context).size.width * 2 / 3,
                child: FloatingActionButton.extended(
                    label: const Text('Search'), 
                    backgroundColor: Colors.blue.shade400,
                    icon: const Icon( 
                        Icons.search_rounded,
                        size: 14.0,
                    ),
                    foregroundColor: Colors.white,
                    onPressed: () async {
                        if (_formKeySearchListOrder.currentState!.validate()) {
                        searchPress();
                    }
                        
                    },
                ),
            );
    }

    Widget btnSearchX() {
        return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(22.0),
                color: Colors.blue.shade400,
                child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width - 40,
                padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                    if (_formKeySearchListOrder.currentState!.validate()) {
                        searchPress();
                    }
                },
                child: const Text(
                    "Search",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                ),
            ),
        );
    }




}