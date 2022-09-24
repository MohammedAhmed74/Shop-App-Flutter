import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shopapp/models/shop/categories_model.dart';
import 'package:shopapp/models/shop/home_model.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';
import 'package:shopapp/modules/Product%20Info/ProductInfoScreen.dart';
import 'package:shopapp/shared/cubit/cubit.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/styles/colors.dart';

class productsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.homeModel != null &&
                cubit.categoryModel != null &&
                cubit.favoritesModel != null,
            builder: (context) {
              print(cubit.favoritesModel);
              return SliderBuilder(
                  cubit.homeModel,
                  cubit.categoryModel,
                  cubit.favorites!,
                  context,
                  cacheHelper.getValue(key: 'lightMode'));
            },
            fallback: (context) {
              cacheHelper.getValue(key: 'logout') == true
                  ? cubit.reGetAllData().then((value) {
                      cubit.isReady();
                      cacheHelper.setValue(key: 'logout', value: false);
                      print('logout :::: ');
                      print(cacheHelper.getValue(key: 'logout'));
                    })
                  : print('OpenHome');
              return Center(
                child: new CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 10.0,
                  animation: true,
                  animationDuration: 6000,
                  percent: 1,
                  center: new Text(
                    "100%",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: !cacheHelper.getValue(key: 'lightMode')
                          ? darkTextcolor
                          : lightTextColor,
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: defaultColor,
                ),
              );
            });
      }),
    );
  }

  Widget SliderBuilder(HomeModel? homeModel, CategoriesModel? categoriesModel,
      Map<int, bool?> favoraties, BuildContext context, bool lightMood) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: homeModel!.data.banners
                .map((e) => Image(
                      image: NetworkImage(e.image),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ))
                .toList(),
            options: CarouselOptions(
              height: 250.0,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayInterval: Duration(seconds: 3),
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'CATEGORIES',
              style: TextStyle(
                  fontSize: 20,
                  color: !lightMood ? darkTextcolor : lightTextColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 110,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ListView.separated(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) => buildCategoryItem(
                    categoriesModel!.data.Categories[index], lightMood)),
                separatorBuilder: ((context, index) => SizedBox(
                      width: 10,
                    )),
                itemCount: categoriesModel!.data.Categories.length),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'PRODUCTS',
              style: TextStyle(
                  fontSize: 20,
                  color: !lightMood ? darkTextcolor : lightTextColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: !lightMood ? darkBackground : Colors.grey[300],
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.55,
              children: List.generate(
                  homeModel.data.products.length,
                  (index) => buildGridProduct(homeModel.data.products[index],
                      favoraties, context, lightMood)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCategoryItem(Category category, bool lightMood) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(category.image),
            height: 110,
            width: 110,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.7),
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      !lightMood ? Radius.circular(0) : Radius.circular(10),
                  bottomRight:
                      !lightMood ? Radius.circular(0) : Radius.circular(10),
                )),
            width: 110,
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildGridProduct(ProductData model, Map<int, bool?> favoraties,
      BuildContext context, bool lightMood) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ProductInfo(productId: model.id))));
      },
      child: Container(
        color: !lightMood ? HexColor('#181818') : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  height: 200,
                  color: Colors.white,
                  child: Image(
                    image: NetworkImage(
                      model.image,
                    ),
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                if (model.discount != 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          'DISCOUNT',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
              child: Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.1,
                  color: !lightMood ? darkTextcolor : lightTextColor,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${model.price.round()}',
                    style: TextStyle(
                      color: defaultColor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  if (model.discount != 0)
                    Text(
                      '${model.old_price.round()}',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        ShopCubit.get(context).changeFavorites(model.id);
                      },
                      icon: Icon(
                        favoraties[model.id] == true
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: favoraties[model.id] == true
                            ? defaultColor
                            : Colors.grey,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
