import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/modules/Login/loginScreen.dart';
import 'package:shopapp/shared/cubit/cubit.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onBoardingScreens {
  late final String title;
  late final String image;
  late final String body;

  onBoardingScreens(
      {required this.title, required this.body, required this.image});
}

class onBoarding_screen extends StatelessWidget {
  var onBoardingCtrl = PageController();
  bool lastpage = false;
  List<onBoardingScreens> onBoarding = [
    onBoardingScreens(
        title: 'DISCOVER',
        body: 'Explore world\'s top brands and boutique',
        image: 'asset/images/1.png'),
    onBoardingScreens(
        title: 'MAKE THE PAYMENT',
        body: 'Choose the preferable option for payment',
        image: 'asset/images/2.png'),
    onBoardingScreens(
        title: 'ENJOY YOUR SHOPPING',
        body: 'Get high quality products for the best price',
        image: 'asset/images/3.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  Container(
                    width: 90,
                    padding: EdgeInsets.only(top: 20, right: 0),
                    child: IconButton(
                      onPressed: () {
                        ShopCubit.startLogin();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => LoginScreen())));
                      },
                      icon: Text(
                        'SKIP',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: defaultColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    if (index == onBoarding.length - 1) {
                      lastpage = true;
                    } else
                      lastpage = false;
                  },
                  controller: onBoardingCtrl,
                  itemBuilder: (context, index) =>
                      onBoardingItem(onBoarding[index]),
                  itemCount: onBoarding.length,
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                      controller: onBoardingCtrl,
                      effect: JumpingDotEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 3,
                          jumpScale: 0.7,
                          verticalOffset: 20,
                          activeDotColor: defaultColor),
                      count: onBoarding.length),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (!lastpage) {
                        onBoardingCtrl.nextPage(
                            duration: Duration(milliseconds: 800),
                            curve: Curves.fastLinearToSlowEaseIn);
                      } else {
                        ShopCubit.startLogin();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => LoginScreen())));
                      }
                    },
                    backgroundColor: defaultColor,
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget onBoardingItem(onBoardingScreens model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(model.image),
          ),
        ),
        Text(
          model.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: 250,
          child: Text(
            model.body,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
