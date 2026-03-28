import 'package:ecommerce_desktop/layouts/master_screen.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Product List",
      child: Center(
        child: Container(
          child: ElevatedButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("TODO add product list")),
    )
      ),
    );
  }
}