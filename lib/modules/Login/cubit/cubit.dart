import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/shop/categories_model.dart';
import 'package:shopapp/models/shop/favorites_model.dart';
import 'package:shopapp/models/shop/home_model.dart';
import 'package:shopapp/models/shop/login_model.dart';
import 'package:shopapp/models/shop/profile_model.dart';
import 'package:shopapp/modules/Login/cubit/states.dart';
import 'package:shopapp/shared/network/dioHelper.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';

class Shop_Login_Cubit extends Cubit<Shop_Login_States> {
  Shop_Login_Cubit() : super(ShopInitialState());
  //*********************************** FormField
  static Shop_Login_Cubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  IconData passwordSuff = Icons.visibility_off_rounded;
  showPassword() {
    isPassword = !isPassword;
    passwordSuff =
        !isPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded;
    emit(ShowPasswordState());
  }

  void initialDio() {
    dioHelper.init();
    emit(DioInitializedState());
  }

  void userLogin({required String email, required String password}) async {
    emit(LoadingLoginState());
    dioHelper.postData('login', data: {
      'email': email,
      'password': password,
    }).then((value) {
      print(value);
      ShopLoginModel loginModle = ShopLoginModel.fromJson(value.data);
      emit(SuccessLoginState(loginModle: loginModle));
    }).catchError((error) {
      print(error);
    });
  }

  void userRegister(
      {required String email,
      required String password,
      required String name,
      required String phone}) async {
    emit(LoadingLoginState());
    dioHelper.postData('register', data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    }).then((value) {
      print(value);
      ShopLoginModel loginModle = ShopLoginModel.fromJson(value.data);
      emit(SuccessRegisterState(loginModle: loginModle));
    }).catchError((error) {
      print(error);
    });
  }

}
