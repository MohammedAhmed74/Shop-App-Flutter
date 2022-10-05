import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopapp/models/shop/categories_model.dart';
import 'package:shopapp/models/shop/checkFavorites_model.dart';
import 'package:shopapp/models/shop/favorites_model.dart';
import 'package:shopapp/models/shop/home_model.dart';
import 'package:shopapp/models/shop/profile_model.dart';
import 'package:shopapp/models/shop/search_model.dart';
import 'package:shopapp/modules/Categories/categoriesScreen.dart';
import 'package:shopapp/modules/Favorites/favouriesScreen.dart';
import 'package:shopapp/modules/Product%20Info/ProductInfoScreen.dart';
import 'package:shopapp/modules/Products/productsScreen.dart';
import 'package:shopapp/modules/Settings/settingsScreen.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';
import 'package:shopapp/shared/network/dioHelper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(InitialNewsState());
  static ShopCubit get(context) => BlocProvider.of(context);

  // textDirection == TextDirection.ltr
  //     ? textDirection = TextDirection.rtl
  //     : textDirection = TextDirection.ltr;
  late bool isChanged;
  Future changeThemeMode() async {
    switch (cacheHelper.getValue(key: 'lightMode')) {
      case true:
        cacheHelper.setValue(key: 'lightMode', value: false);
        break;
      case false:
        cacheHelper.setValue(key: 'lightMode', value: true);
        break;
      case null:
        cacheHelper.setValue(key: 'lightMode', value: true);
        break;
    }
    print('change lightMode');
    print(cacheHelper.getValue(key: 'lightMode'));
    setFormFeildColor();
    emit(ChangeThemeState());
  }

  bool fromMain = true;
  finishedMain() {
    fromMain = false;
  }

  List<Widget> Screens = [
    productsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  List<BottomNavigationBarItem> BottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Categories'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourites'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  int currentIndex = 0;
  void changeBottomNav(index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  void startSearching() {
    emit(ChangeSearchState());
  }

  Color textFormColor = Colors.black;
  void setFormFeildColor() {
    textFormColor = cacheHelper.getValue(key: 'lightMode') == true
        ? Colors.black
        : Colors.white;
    emit(ChangeSearchState());
  }

  bool beforeSearch = true;

  startSearch() {
    beforeSearch = false;
    emit(EmptySearchState());
  }

  endSearch() {
    beforeSearch = true;
    emit(EmptySearchState());
  }

  static startLogin() {
    cacheHelper.setValue(key: 'onBoarding', value: false);
  }

  HomeModel? homeModel;

  Future getHomeData() async {
    emit(LoadingHomeDataState());
    await dioHelper
        .getData(
      'home',
      token: cacheHelper.getValue(key: 'token'),
    )
        .then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print(cacheHelper.getValue(key: 'token'));
      print('home done');
      emit(SuccessHomeDataState());
      getFavorites();
    }).catchError((error) {
      print(error);
      emit(FailedHomeDataState());
    });
  }

  CategoriesModel? categoryModel;

  Future getCategoriesData() async {
    await dioHelper
        .getData(
      'categories',
      token: cacheHelper.getValue(key: 'token'),
    )
        .then((value) {
      categoryModel = CategoriesModel.fromJson(value.data);
      print('cat done');
      emit(SuccessCategoriesDataState());
    }).catchError((error) {
      print(error);
      emit(FailedCategoriesDataState());
    });
  }

  Map<int, bool?>? favorites = {};

  void getFavorites() {
    homeModel!.data.products.forEach((element) {
      favorites!.addAll({element.id: element.in_favorites});
      emit(GetFavoritesDataState());
    });
  }

  late CheckFavoritesModel checkFavoritesModel;

  Future changeFavorites(int productId) async {
    favorites![productId] = favorites![productId] == false ? true : false;
    emit(SuccessFavoritesDataState());
    await dioHelper
        .postData('favorites', data: {'product_id': productId}).then((value) {
      checkFavoritesModel = CheckFavoritesModel.fromJson(value.data);
      getFavoritesProducts();
      print(checkFavoritesModel.message);
      if (!checkFavoritesModel.status) {
        favorites![productId] = favorites![productId] == false ? true : false;
        Fluttertoast.showToast(
            msg: checkFavoritesModel.message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        emit(SuccessCheckFavoritesDataState());
      }
    }).catchError((error) {
      print(error);
      favorites![productId] = favorites![productId] == false ? true : false;
      emit(FailedCheckFavoritesDataState());
    });
  }

  FavoritesModel? favoritesModel;
  Future getFavoritesProducts() async {
    await dioHelper.getData('favorites').then((value) {
      print(value);
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(SuccessFavoritesDataState());
    }).catchError((error) {
      print(error);
      emit(FailedFavoritesDataState());
    });
  }

  late ProfileModel? profileModel;
  Future getProfileData() async {
    await dioHelper
        .getData(
      'profile',
      token: cacheHelper.getValue(key: 'token'),
    )
        .then((value) {
      profileModel = ProfileModel.fromJson(value.data);
      emit(SuccessProfilesDataState());
    }).catchError((error) {
      print(error);
      emit(FailedProfilesDataState());
    });
  }

  late ProfileModel? updatedProfileModel;
  Future updateProfile({
    String? email,
    String? name,
    String? phone,
  }) async {
    emit(LoadingUpdateProfilesDataState());
    await dioHelper.putData('update-profile', data: {
      'email': email == null ? profileModel!.data!.email : email,
      'name': name == null ? profileModel!.data!.name : name,
      'phone': phone == null ? profileModel!.data!.phone : phone,
    }).then((value) {
      updatedProfileModel = ProfileModel.fromJson(value.data);
      getProfileData();
      if (!updatedProfileModel!.status) {
        Fluttertoast.showToast(
            msg: updatedProfileModel!.message!,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        emit(FailedUpdateProfilesDataState());
      } else {
        Fluttertoast.showToast(
            msg: updatedProfileModel!.message!,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        emit(SuccessUpdateProfilesDataState());
      }
    }).catchError((error) {
      print(error);
      emit(FailedUpdateProfilesDataState());
    });
  }

  bool emptySearchText = true;
  SearchModel? searchModel;
  Future searchForProduct({required String text}) async {
    emit(LoadingSearchState());
    await dioHelper
        .postData('products/search', data: {'text': text}).then((value) {
      print(value.data);
      searchModel = SearchModel.fromJson(value.data);
      emit(SuccessSearchState());
    }).catchError((error) {
      print(error);
      emit(FailedSearchState());
    });
  }

  Future reGetAllData() async {
    await dioHelper
        .getData(
      'home',
      token: cacheHelper.getValue(key: 'token'),
    )
        .then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print(cacheHelper.getValue(key: 'token'));
      print('home done');

      homeModel!.data.products.forEach((element) {
        favorites!.addAll({element.id: element.in_favorites});
        //    get fav
      });
    }).catchError((error) {
      print(error);
    });
    //          home

    await dioHelper
        .getData(
      'categories',
      token: cacheHelper.getValue(key: 'token'),
    )
        .then((value) {
      categoryModel = CategoriesModel.fromJson(value.data);
      print('cat done');
    }).catchError((error) {
      print(error);
    });
    //             category

    await dioHelper.getData('favorites').then((value) {
      print(value);
      favoritesModel = FavoritesModel.fromJson(value.data);
      print('Fav done');
    }).catchError((error) {
      print(error);
    });
    //                getFavoritesProducts

    await dioHelper
        .getData(
      'profile',
      token: cacheHelper.getValue(key: 'token'),
    )
        .then((value) {
      profileModel = ProfileModel.fromJson(value.data);
      print('profile done');
    }).catchError((error) {
      print(error);
    });
  }

  isReady() {
    emit(SuccessHomeDataState());
  }

  List<ProductData> cartsProducts = [];
  List<int> cartsProductsNumber = [];

  void addToCarts(ProductData product) {
    cartsProducts.add(product);
    cartsProductsNumber.add(1);
    emit(AddingProductToCartState());
  }

  void removeFromCarts(ProductData product) {
    for (int i = 0; i < cartsProducts.length; i++) {
      if (product.id == cartsProducts[i].id) {
        cartsProductsNumber.removeAt(i);
      }
    }
    cartsProducts.remove(product);
    emit(RemovingProductFromCartState());
  }

  void increaseProductInCarts(ProductData product) {
    for (int i = 0; i < cartsProducts.length; i++) {
      if (product.id == cartsProducts[i].id) {
        cartsProductsNumber[i]++;
      }
    }
    emit(IncreasingProductInCartState());
  }

  void decreaseProductInCarts(ProductData product) {
    for (int i = 0; i < cartsProducts.length; i++) {
      if (product.id == cartsProducts[i].id) {
        if (cartsProductsNumber[i] > 1) {
          cartsProductsNumber[i]--;
        } else {
          removeFromCarts(product);
        }
      }
    }
    emit(DecreasingProductInCartState());
  }
}
