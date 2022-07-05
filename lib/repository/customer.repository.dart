
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seller/constant/constanta.dart';
import 'package:http/http.dart' as http;
import 'package:seller/model/customer_model.dart';
import 'package:seller/model/response_model.dart';
import 'package:seller/util/util_signature.dart';

class CustomerRepository {

    final _baseURL = serverIP;
    final http.Client httpClient;

    CustomerRepository({
        required this.httpClient,
    }) : assert(httpClient != null);

    Future<ResponseContentDto> save(Customer customer ) async {
        final _loginUrl = _baseURL + 'api/customer';
        var requestHeaders = Utilities.setSignature();
        var bodyJson = json.encode(customer);
        var response = await httpClient.post(
            Uri.parse(_loginUrl),
            headers: requestHeaders, 
            body: bodyJson
        );

        String responseBody = utf8.decoder.convert(response.bodyBytes);
        debugPrint('service utf8 : ' + responseBody);
        final jsonObj = json.decode(responseBody) as Map<String, dynamic>;
        return ResponseContentDto(jsonObj['errCode'], jsonObj['errDesc'], jsonObj['contents']);
    
    }

    Future<List<Customer>> getByIdSeller(int sellerId, String token) async {
        final _loginUrl = _baseURL + 'api/customer/seller-id/$sellerId';
        var response = await httpClient.get(
            Uri.parse(_loginUrl),
            headers: {
                    'Authorization': 'Bearer $token',
                    'content-type': 'application/json',
                }, 
        );

        String responseBody = utf8.decoder.convert(response.bodyBytes);
        debugPrint('service utf8 : ' + responseBody);
        final jsonObj = json.decode(responseBody) as Map<String, dynamic>;

        if (jsonObj['errCode']!="00") {
            return [];
        }

        if (jsonObj['contents'] == []) {
            return [];
        }

        List<Customer> custs = (jsonObj['contents'] as List).map((e) => Customer.fromJson(e)).toList();

        return custs;
        // return ResponseContentDto(jsonObj['errCode'], jsonObj['errDesc'], jsonObj['contents']);
    }
  
}
