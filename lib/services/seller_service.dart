
import 'package:flutter/foundation.dart';
import 'package:seller/model/login_model.dart';
import 'package:seller/model/login_result_model.dart';
import 'package:seller/model/seller_model.dart';
import 'package:seller/repository/seller.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerService {
    final SellerRepository repository;

    SellerService({
        required this.repository,
    });

    Future<LoginResultDto> loginSeller(LoginDto loginDto) async {
        debugPrint('Service : Login seller');

        final prefs = await SharedPreferences.getInstance();
        LoginResultDto loginResult = await repository.login(loginDto);
        if (loginResult.errCode == "00") {
            debugPrint("service: login success, save preference");
            await prefs.setString('seller-code', loginDto.kode);
            await prefs.setString('token', loginResult.token.toString());
        }
        return loginResult;
    }

    getByCode() async {
        debugPrint('Service : get seller by code');

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token').toString();
        final sellerCode = prefs.getString('seller-code').toString();

        Seller seller = await repository.getByCode(token, sellerCode);

        if (seller.id != 0) {
            prefs.setString('seller-alamat', seller.alamat);
            prefs.setString('seller-hp', seller.hp);
            prefs.setString('seller-kode', seller.kode);
            prefs.setString('seller-nama', seller.nama);
            prefs.setInt('seller-id', seller.id);
            prefs.setInt('seller-status', seller.status);
        }
        
        return "ok";

    }

}
