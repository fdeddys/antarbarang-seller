import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:seller/constant/constanta.dart';
import 'package:http/http.dart' as http;
import 'package:seller/model/login_model.dart';
import 'package:seller/model/login_result_model.dart';
import 'package:seller/model/seller_model.dart';
import 'package:seller/util/util_signature.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerRepository {
    final _baseURL = serverIP;
    final http.Client httpClient;

    SellerRepository({
        required this.httpClient,
    }) : assert(httpClient != null);

    Future<LoginResultDto> login(LoginDto loginDto) async {
        final _loginUrl = _baseURL + 'api/seller/login';
        final prefs = await SharedPreferences.getInstance();

        var requestHeaders = Utilities.setSignature();
        var bodyJson = json.encode(loginDto);
        var response = await httpClient.post(Uri.parse(_loginUrl),
            headers: requestHeaders, body: bodyJson);

        String responseBody = utf8.decoder.convert(response.bodyBytes);
        debugPrint('service utf8 : ' + responseBody);
        final jsonObj = json.decode(responseBody) as Map<String, dynamic>;

        return LoginResultDto(jsonObj['token'], jsonObj['errCode'], jsonObj['errDesc']);
        // if (jsonObj['errCode'] != '00') {
        //     return LoginResultDto(jsonObj['token'], jsonObj['errCode'], jsonObj['errDesc']);
        // }
        // await prefs.setString('seller-code', loginDto.kode);
        // return LoginResultDto(jsonObj['token'], jsonObj['errCode'], jsonObj['errDesc']);
    }

    Future<Seller> getByCode(String token, String sellerCode) async {
       
        var _loginUrl = _baseURL + 'api/seller/code/$sellerCode';
        var response =
            await httpClient.get(
                    Uri.parse(_loginUrl), 
                    headers: {
                        'Authorization': 'Bearer $token',
                        'content-type': 'application/json',
                    }
                );

        String responseBody = utf8.decoder.convert(response.bodyBytes);
        debugPrint('service utf8 : ' + responseBody);

        final jsonObj = json.decode(responseBody) as Map<String, dynamic>;
        if (jsonObj['errCode'] != '00') {
            return Seller(0, "", "", "", "", 0, "");
        }
        Seller seller = Seller.fromJson(jsonObj['contents']);
        return seller;
       
    }
}
