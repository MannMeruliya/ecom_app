import 'dart:convert';

import 'package:ecom_app/model/ecom_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EcomProvider extends ChangeNotifier {
  Product? productmodel;
  List<ProductElement> productList = [];

  Future<Product?> getallProduct() async {
    Uri url = Uri.parse("https://dummyjson.com/products");
    var response = await http.get(url);
    print("${response.statusCode}");
    if (response.statusCode == 200) {
      productmodel = Product.fromJson(json.decode(response.body));
      productList.addAll(productmodel?.products! as Iterable<ProductElement>);
      print("List :: $productList");
    }
    return productmodel;
  }
}
