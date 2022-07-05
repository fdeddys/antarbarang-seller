import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:seller/constant/constanta.dart';

class Utilities {
    static setSignature() {
        DateTime now = DateTime.now();
        DateFormat formatter = DateFormat('ddMMyyyy');
        String tanggal = formatter.format(now);

        String secretKey = SecretKey;
        var key = utf8.encode(secretKey);
        var bytes = utf8.encode("{}&$tanggal&$secretKey");

        var hmacSha512 = Hmac(sha512, key); // HMAC-SHA256
        var digest = hmacSha512.convert(bytes);

        Map<String, String> requestHeaders = {
            'Content-type': 'application/json',
            'timestamp': '$tanggal',
            'signature': '$digest'
        };
        return requestHeaders;
    }

    static bool isNumeric(String s) {
        if(s == null) {
            return false;
        }
        return double.tryParse(s) != null;
    }
}
