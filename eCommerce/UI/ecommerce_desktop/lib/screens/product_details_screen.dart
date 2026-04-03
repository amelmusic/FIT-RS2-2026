import 'package:ecommerce_desktop/layouts/master_screen.dart';
import 'package:ecommerce_desktop/models/product.dart';
import 'package:ecommerce_desktop/models/product_type.dart';
import 'package:ecommerce_desktop/models/search_result.dart';
import 'package:ecommerce_desktop/models/unit_of_measure.dart';
import 'package:ecommerce_desktop/providers/product_provider.dart';
import 'package:ecommerce_desktop/providers/product_type_provider.dart';
import 'package:ecommerce_desktop/providers/unit_of_measure_provider.dart';
import 'package:ecommerce_desktop/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initalValue = {};

  late ProductProvider _productProvider;
  late ProductTypeProvider _productTypeProvider;
  late UnitOfMeasureProvider _unitOfMeasureProvider;

  bool isLoading = true;

  SearchResult<UnitOfMeasure>? unitsOfMeasureResult;
  SearchResult<ProductType>? productTypesResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initalValue = {
      'name': widget.product?.name,
      'price': widget.product?.price.toString(),
      'productTypeId': widget.product?.productTypeId,
      'unitOfMeasureId': widget.product?.unitOfMeasureId
    };

    _productProvider = context.read<ProductProvider>();
    _productTypeProvider = context.read<ProductTypeProvider>();
    _unitOfMeasureProvider = context.read<UnitOfMeasureProvider>();

    initForm();
  }

  Future initForm() async {
    try {
      var productTypes = await _productTypeProvider.get(filter: {});
      var unitsOfMeasure = await _unitOfMeasureProvider.get(filter: {});

      setState(() {
        productTypesResult = productTypes;
        unitsOfMeasureResult = unitsOfMeasure;
        isLoading = false;
      });
      

    } on Exception catch (e) {
      alertBox(context, "Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: widget.product == null ? "New Product" : "Update product",
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildForm(),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState?.save();
                
                    try {
                      if (_formKey.currentState!.validate()) {
                        if (widget.product != null) {
                          Map<String, dynamic> request = Map.of(
                            _formKey.currentState!.value,
                          );
                
                          request['id'] = widget.product?.id;
                
                          var price = double.parse(
                            _formKey.currentState!.value['price'],
                          );
                
                          request['price'] = price;
                          print(request);

                          print(widget.product!.productTypeId);
                          print(_formKey.currentState!.value['productTypeId']);
                
                          await _productProvider.update(widget.product!.id!, request);
                
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Product successfully modified"),
                            ),
                          );
                
                          Navigator.pop(context, 'reload');
                        } else {
                          Map<String, dynamic> request = Map.of(
                            _formKey.currentState!.value,
                          );
                
                          var price = double.parse(
                            _formKey.currentState!.value['price'],
                          );
                
                          request['price'] = price;
                
                          await _productProvider.insert(request);
                
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Product successfully added")),
                          );
                
                          Navigator.pop(context, 'reload');
                        }
                      }
                    } on Exception catch (e) {
                      alertBox(context, "Error", e.toString());
                    }
                  },
                  child: Text("Save", style: const TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return FormBuilder(
      key: _formKey,
      initialValue: _initalValue,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return mField;
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(label: Text("Name")),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FormBuilderTextField(
                  name: 'price',
                  validator: (value) {
                    if (value == null) {
                      return mField;
                    } else if (double.tryParse(value) == null) {
                      return numericField;
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(label: Text("Price")),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: FormBuilderDropdown(
                name: "unitOfMeasureId",
                decoration: InputDecoration(labelText: "Unit of Measure"),
                items: unitsOfMeasureResult?.items
                        ?.map((e) => DropdownMenuItem(
                            value: e.id, child: Text(e.name!)))
                        .toList() ??
                    [],
              )),
              Expanded(
                  child: FormBuilderDropdown(
                name: "productTypeId",
                decoration: InputDecoration(labelText: "Product Type"),
                items: productTypesResult?.items
                        ?.map((e) => DropdownMenuItem(
                            value: e.id, child: Text(e.name!)))
                        .toList() ??
                    [],
              ))
            ],
          )
        ],
      ),
    );
  }
}
