
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seller/model/screen_argument.dart';
import 'package:seller/model/transaksi_model.dart';
import 'package:seller/repository/transaksi_repository.dart';
import 'package:seller/services/transaksi_service.dart';

class DetailOrderPage extends StatefulWidget {
    DetailOrderPage({Key? key}) : super(key: key);
    static const routeName = '/detailOrder';

    @override
    State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {

     TransaksiService transaksiService = 
        TransaksiService(
            repository: 
                TransaksiRepository(
                    httpClient: http.Client()
                )
            );
            

    @override
    Widget build(BuildContext context) {

        final screenArgument = ModalRoute.of(context)!.settings.arguments as ScreenArgument;

        return Scaffold(
            appBar: AppBar(
                title: const Text("Detail Page"),
            ),
            body: 
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            cardInfo(screenArgument.transaksi),
                            cardPickup(screenArgument.transaksi),
                            cardDone(screenArgument.transaksi),
                        ],
                    ),
                ),
        );
    }

    Widget cardInfo(Transaksi transaksi) {
        return
            Center(
                child: Card(
                    color: Colors.blue.shade100,
                    shadowColor: Colors.red.shade300,
                    borderOnForeground: true,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                            width: MediaQuery. of(context). size. width * 0.9 ,
                            child: 
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('ID : ${transaksi.id}'),
                                                    Text('[${transaksi.status}] ${transaksi.statusName}')
                                                ],
                                            ),
                                        ),
                                        // ignore: prefer_const_constructors
                                        Padding(
                                            padding : const EdgeInsets.all(5.0),
                                            child: const Text('Seller', 
                                                    style: TextStyle(
                                                        color: Colors.blue, fontSize: 16
                                                    ),
                                                ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20) ,  
                                            child: Text('${transaksi.sellerName} ',
                                                style: TextStyle(
                                                        color:  Colors.white, fontSize: 16
                                                    ),
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text('${transaksi.sellerHp} ',
                                                style: TextStyle(
                                                        color:  Colors.white, fontSize: 16
                                                    ),
                                            ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text('${transaksi.sellerAddress}',
                                                style: TextStyle(
                                                        color:  Colors.white, fontSize: 16
                                                    ),
                                            ),
                                        ),
                                        const SizedBox(height: 10),

                                        // ignore: prefer_const_constructors
                                        Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: const Text('Product', style: TextStyle(color: Colors.blue, fontSize: 16),),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text('${transaksi.namaProduct} ' ),
                                        ),
                                        const SizedBox(height: 10),

                                        // ignore: prefer_const_constructors
                                        Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: const Text('Customer', style: TextStyle(color: Colors.blue, fontSize: 16),),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text('${transaksi.customerName} ' ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text('${transaksi.customerAddress} ' ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text('${transaksi.customerHp} ' ),
                                        ),   
                                        const SizedBox(height: 10),

                                        // ignore: prefer_const_constructors
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Text('Info', style: TextStyle(color: Colors.blue, fontSize: 16),),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text('Antar : [ ${transaksi.tanggalRequestAntarStr} ] / [ ${transaksi.jamRequestAntar} ] ' ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text('${transaksi.keterangan} ' ),
                                        ), 
                                    ],
                                ),
                        ),
                    ),
                ),
            );
    }

    Widget cardPickup(Transaksi transaksi) {
        return
            Center(
                child: Card(
                    color: const Color.fromARGB(255, 185, 223, 186),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: SizedBox(
                            width: MediaQuery. of(context). size. width * 0.9 ,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    // ignore: prefer_const_constructors
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text('Pickup', style: TextStyle(color: Colors.green, fontSize: 16),),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Text('Tanggal : ${transaksi.tanggalAmbilStr} ' ),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            );
    }

    Widget cardDone(Transaksi transaksi) {
        return
            Center(
                child: Card(
                    color: const Color.fromARGB(255, 241, 151, 151),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: SizedBox(
                            width: MediaQuery. of(context). size. width * 0.9 ,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    // ignore: prefer_const_constructors
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text('Done', style: TextStyle(color: Colors.red, fontSize: 16),),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Text('Tanggal : ${transaksi.tanggalAmbilStr} ' ),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            );
    }

}