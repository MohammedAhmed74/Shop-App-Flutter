import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Layout/ShopLayout/shopLayout.dart';
import 'package:shopapp/modules/Login/loginScreen.dart';
import 'package:shopapp/modules/onBoarding/onBoardingScreen.dart';
import 'package:shopapp/shared/bloc_observer.dart';
import 'package:shopapp/shared/cubit/cubit.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';
import 'package:shopapp/shared/network/dioHelper.dart';
import 'package:shopapp/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dioHelper.init();
  Bloc.observer = MyBlocObserver();
  await cacheHelper.init();
  bool? startLogin = cacheHelper.getValue(key: 'onBoarding');
  late Widget startScreen;
  if (startLogin != null) {
    if (cacheHelper.getValue(key: 'token') != null)
      startScreen = shopLayout();
    else
      startScreen = LoginScreen();
  } else
    startScreen = onBoarding_screen();
    
  if (cacheHelper.getValue(key: 'lightMode') == null)
    cacheHelper.setValue(key: 'lightMode', value: true);
  runApp(MyApp(startScreen));
}

class MyApp extends StatelessWidget {
  Widget startScreen;
  MyApp(this.startScreen);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => ShopCubit()
        ..getHomeData()
        ..getCategoriesData()
        ..getFavoritesProducts()
        ..getProfileData()),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: cacheHelper.getValue(key: 'lightMode') == false
                  ? darkTheme
                  : lightTheme,
              home: startScreen);
        },
      ),
    );
  }
}
