import 'package:flutter/material.dart';
import 'package:shopapp/modules/Login/loginScreen.dart';
import 'package:shopapp/shared/cubit/cubit.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';

void signOut(context) {
  cacheHelper.removeValue(key: 'token').then((value) {
    if (value)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
  });
  cacheHelper.setValue(key: 'logout', value: true);
  ShopCubit.get(context).currentIndex = 0;
  ShopCubit.get(context).homeModel = null;
  ShopCubit.get(context).categoryModel = null;
  ShopCubit.get(context).favoritesModel = null;
  ShopCubit.get(context).searchModel = null;
  print('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
  print('before finishedMain(): ${ShopCubit.get(context).fromMain}');
  ShopCubit.get(context).finishedMain();
  print('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
  print('before finishedMain(): ${ShopCubit.get(context).fromMain}');
}
