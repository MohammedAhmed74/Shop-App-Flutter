import 'package:shopapp/models/shop/login_model.dart';

abstract class Shop_Login_States {}

class ShopInitialState extends Shop_Login_States {}

class DioInitializedState extends Shop_Login_States {}

class ShowPasswordState extends Shop_Login_States {}

class SuccessLoginState extends Shop_Login_States {
  late ShopLoginModel loginModle;
  SuccessLoginState({required this.loginModle});
}

class SuccessRegisterState extends Shop_Login_States {
  late ShopLoginModel loginModle;
  SuccessRegisterState({required this.loginModle});
}

class LoadingLoginState extends Shop_Login_States {}
