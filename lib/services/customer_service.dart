import 'package:flutter/material.dart';
import 'package:seller/model/customer_model.dart';
import 'package:seller/model/response_model.dart';
import 'package:seller/repository/customer.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerService {
    final CustomerRepository repository;

    CustomerService({
        required this.repository,
    });

    Future<ResponseContentDto> save(Customer customer) async {
        debugPrint('Service : save customer');
        return repository.save(customer);
    }

    Future<List<Customer>> getByIdSeller(int sellerId) async {
        debugPrint('Service : get by id seller');

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token').toString();
        
        return repository.getByIdSeller(sellerId, token);
    }
}
