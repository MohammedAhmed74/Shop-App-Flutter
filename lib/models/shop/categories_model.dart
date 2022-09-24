class CategoriesModel {
  late bool status;
  late CategoriesData data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoriesData.fromJson(json['data']);
  }
}

class CategoriesData {
  late int current_page;
  List<Category> Categories = [];

  CategoriesData.fromJson(Map<String, dynamic> json) {
    current_page = json['current_page'];
    json['data'].forEach((element) {
      Categories.add(Category.fromJson(element));
    });
  }
}

class Category {
  late int id;
  late String name;
  late String image;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
