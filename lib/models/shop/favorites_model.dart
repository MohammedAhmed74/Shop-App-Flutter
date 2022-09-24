class FavoritesModel {
  late bool status;
  late FavoritesData data;

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = FavoritesData.fromJson(json['data']);
  }
}

class FavoritesData {
  late int current_page;
  late Favorites data;

  FavoritesData.fromJson(Map<String, dynamic> json) {
    current_page = json['current_page'];
    data = Favorites.fromJson(json['data']);
  }
}

class Favorites {
  List<FavProductInfo> FavInformations = [];
  Favorites.fromJson(List<dynamic> json) {
    json.forEach((element) {
      FavInformations.add(FavProductInfo.fromJson(element));
    });
  }
}

class FavProductInfo {
  late int id;
  late FavProductModle product;
  FavProductInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = FavProductModle.fromJson(json['product']);
  }
}

class FavProductModle {
  late int id;
  late dynamic price;
  late dynamic old_price;
  late dynamic discount;
  late String image;
  late String name;
  late String description;

  FavProductModle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    old_price = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
