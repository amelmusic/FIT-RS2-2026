import 'package:ecommerce_desktop/layouts/master_screen.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  final String productName = "Sample Product";

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Details",
      child: Center(
        child: Container(
          child: ElevatedButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("TODO add product details")),

    )
      ),
    );
  }
}