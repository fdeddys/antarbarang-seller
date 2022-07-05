
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:seller/constant/constanta.dart';
import 'package:seller/dto/transaksi_dto.dart';
import 'package:seller/model/response_model.dart';
import 'package:seller/model/transaksi_model.dart';

class TransaksiRepository {

    final _baseURL = serverIP;
    final http.Client httpClient;

    TransaksiRepository({
        required this.httpClient,
    }) : assert(httpClient != null);

    Future<ResponseContentDto> saveNewOrder(TransaksiDto transaksi, String token ) async {
        final apiUrl = _baseURL + 'api/transaksi/new';
        // var requestHeaders = Utilities.setSignature();

        var bodyJson = json.encode(transaksi);
        var response = await httpClient.post(
            Uri.parse(apiUrl),
            headers: {
                        'Authorization': 'Bearer $token',
                        'content-type': 'application/json',
                    }, 
            body: bodyJson
        );

        String responseBody = utf8.decoder.convert(response.bodyBytes);
        debugPrint('service utf8 : ' + responseBody);
        final jsonObj = json.decode(responseBody) as Map<String, dynamic>;
        return ResponseContentDto(jsonObj['errCode'], jsonObj['errDesc'], jsonObj['contents']);
    
    }

    Future<List<Transaksi>> getBySellerDate(String sellerName, String driverId, String tgl1, String tgl2, String status, String token) async {
        
        var _transaksiUrl = _baseURL + 'api/transaksi/page/1/count/100';
        // var requestHeaders = Utilities.setSignature(token);
        List<Transaksi> result=[];

        var transaksiRequest = {
            "tgl1": tgl1,
            "tgl2": tgl2,
            "driverId": driverId,
            "status": status,
            "sellerName": sellerName
        };
        var bodyJson = json.encode(transaksiRequest);
         
        var response =
            await httpClient.post(Uri.parse(_transaksiUrl), body: bodyJson, headers: {
                'Authorization': 'Bearer $token',
                'content-type': 'application/json',
            });

        String responseBody = utf8.decoder.convert(response.bodyBytes);

        final jsonObj = json.decode(responseBody) as Map<String, dynamic>;
        if (jsonObj['totalRow'].toString() == "0" ) {
            debugPrint("data < 1 !!" );    
            return result;
        }

        debugPrint("data lebih dari 0");

        if  (jsonObj['contents'] != []) {
            debugPrint("convert !!");
            result = (jsonObj['contents'] as List).map((i) => Transaksi.fromJson(i)).toList();
        }
        debugPrint("done...!");

        return result;
    }

}
