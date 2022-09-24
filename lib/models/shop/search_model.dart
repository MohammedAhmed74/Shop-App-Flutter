import 'package:shopapp/models/shop/home_model.dart';

class SearchModel {
  late bool status;
  late SearchDataModel data;
  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = SearchDataModel.fromJson(json['data']);
  }
}

class SearchDataModel {
  late int current_page;
  List<ProductData> products = [];

  SearchDataModel.fromJson(Map<String, dynamic> json) {
    current_page = json['current_page'];
    json['data'].forEach((element) {
      products.add(ProductData.fromJson(element));
    });
  }
}
