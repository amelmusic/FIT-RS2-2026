import 'dart:convert';

import 'package:ecommerce_desktop/models/product_type.dart';
import 'package:ecommerce_desktop/models/search_result.dart';
import 'package:ecommerce_desktop/models/unit_of_measure.dart';
import 'package:ecommerce_desktop/providers/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';


class UnitOfMeasureProvider extends BaseProvider<UnitOfMeasure> {
  UnitOfMeasureProvider() : super("UnitOfMeasures");

  @override
  UnitOfMeasure fromJson(data) {
    return UnitOfMeasure.fromJson(data);
  }
}