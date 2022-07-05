import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller/dto/transaksi_dto.dart';
import 'package:seller/model/response_model.dart';
import 'package:seller/model/transaksi_model.dart';
import 'package:seller/repository/transaksi_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransaksiService {
    final TransaksiRepository repository;

    TransaksiService({
        required this.repository,
    });

    Future<ResponseContentDto> saveNewOrder(TransaksiDto transaksi) async {
        debugPrint('Service : Login seller');

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token').toString();
        ResponseContentDto result = await repository.saveNewOrder(transaksi, token);

        return result;
    }

    getBySeller(String sellerName, String tgl1) async {
        final prefs = await SharedPreferences.getInstance();

        final token = prefs.getString('token').toString();
        final String? driverId = prefs.getString('driver-id');
        debugPrint('Service : get transaksi by date, driver code');

        var now =  DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        // String tgl1 = formatter.format(now);
        
        var status = '0';
        List<Transaksi> transaksis = await repository.getBySellerDate(sellerName, driverId.toString(), tgl1, tgl1, status,  token);
        debugPrint("done transaksi-services get by req-antar date today");
        return transaksis;
    }
}
