class CheckFavoritesModel {
  late bool status;
  late String message;

  CheckFavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
