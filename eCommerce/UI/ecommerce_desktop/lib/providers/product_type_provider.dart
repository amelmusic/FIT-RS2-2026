import 'dart:convert';

import 'package:ecommerce_desktop/models/product_type.dart';
import 'package:ecommerce_desktop/models/search_result.dart';
import 'package:ecommerce_desktop/providers/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';


class ProductTypeProvider extends BaseProvider<ProductType> {
  ProductTypeProvider() : super("ProductTypes");

  @override
  ProductType fromJson(data) {
    return ProductType.fromJson(data);
  }
}