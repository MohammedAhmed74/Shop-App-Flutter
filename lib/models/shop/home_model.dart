class HomeModel {
  late bool status;
  late HomeData data;
  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeData.fromJson(json['data']);
  }
}

class HomeData {
  List<BannerData> banners = [];
  List<ProductData> products = [];
  late String ad;
  HomeData.fromJson(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners.add(BannerData.fromJson(element));
    });
    json['products'].forEach((element) {
      products.add(ProductData.fromJson(element));
    });
    ad = json['ad'];
  }
}

class BannerData {
  late int id;
  late String image;
  late String? category;
  late String? product;
  BannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    category = json['category'];
    product = json['product'];
  }
}

class ProductData {
  late int id;
  late dynamic price;
  late dynamic old_price;
  late dynamic discount;
  late String image;
  late String name;
  late String description;
  List<String> images = [];
  late bool? in_favorites;
  late bool? in_cart;
  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    old_price = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    json['images'].forEach((element) {
      images.add(element);
    });
    in_favorites = json['in_favorites'];
    in_cart = json['in_cart'];
  }
}
