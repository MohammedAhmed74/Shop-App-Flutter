import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/shop/home_model.dart';
import 'package:shopapp/shared/cubit/cubit.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';
import 'package:shopapp/shared/styles/colors.dart';

class ProductInfo extends StatelessWidget {
  ProductInfo({required this.productId});
  late int productId;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        builder: ((context, state) {
          ShopCubit cubit = ShopCubit.get(context);
          late ProductData? productData;
          cubit.homeModel!.data.products.forEach((element) {
            if (element.id == productId) {
              productData = element;
            }
          });
          return SafeArea(
            child: Scaffold(
              body: ConditionalBuilder(
                condition: productData != null && cubit.favorites != null,
                builder: (context) => buildProductInfo(productData!, context,
                    cubit.favorites!, cacheHelper.getValue(key: 'lightMode')),
                fallback: ((context) =>
                    Center(child: CircularProgressIndicator())),
              ),
            ),
          );
        }),
        listener: ((context, state) {}));
  }

  Widget buildProductInfo(ProductData productData, BuildContext context,
      Map<int, bool?> favoraties, bool lightMode) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          CarouselSlider(
            items: productData.images
                .map((e) => Container(
                    height: 250,
                    color: Colors.white,
                    width: double.infinity,
                    child: Image(image: NetworkImage(e))))
                .toList(),
            options: CarouselOptions(
              height: 250.0,
              viewportFraction: 0.6,
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
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  productData.name,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: !lightMode ? darkTextcolor : lightTextColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${productData.price.round()}',
                      style: TextStyle(
                        color: defaultColor,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (productData.discount != 0)
                      Text(
                        '${productData.old_price.round()}',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 5),
                      child: IconButton(
                          onPressed: () {
                            ShopCubit.get(context)
                                .changeFavorites(productData.id);
                          },
                          icon: Icon(
                            favoraties[productData.id] == true
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: favoraties[productData.id] == true
                                ? defaultColor
                                : Colors.grey,
                            size: 30,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 15, 61, 98),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            )),
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(color: Colors.white),
                            ))),
                    Container(
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 23, 98, 160),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              topRight: Radius.circular(30),
                            )),
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Buy Now',
                              style: TextStyle(color: Colors.white),
                            )))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: !lightMode ? darkTextcolor : lightTextColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  productData.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                    color: !lightMode ? darkTextcolor : Colors.black87,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
