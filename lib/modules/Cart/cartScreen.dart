import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/shop/home_model.dart';
import 'package:shopapp/shared/cubit/cubit.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/styles/colors.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        double subtotal = 0;
        int counter = 0;
        int numberOfCartProducts = 0;
        ShopCubit.get(context).cartsProducts.forEach((element) {
          numberOfCartProducts = numberOfCartProducts +
              ShopCubit.get(context).cartsProductsNumber[counter];
          subtotal = subtotal +
              (element.price *
                  ShopCubit.get(context).cartsProductsNumber[counter]);
          counter++;
        });
        bool lightMode = cacheHelper.getValue(key: 'lightMode');
        return SafeArea(
            child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text('Shopping Cart'),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    child: ListView.separated(
                      itemBuilder: (context, index) => buildProductItem(
                        context,
                        ShopCubit.get(context).cartsProducts[index],
                        lightMode,
                        index,
                      ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemCount: ShopCubit.get(context).cartsProducts.length,
                      // itemCount: 1,
                    )),
              ),
              if (ShopCubit.get(context).cartsProducts.length == 0) Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: lightMode == false ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          'Order Summary',
                          style: TextStyle(
                              color: lightMode == true
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 0.6,
                            color: Colors.grey[300],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Subtotal',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Text(
                                  '\$',
                                  style: TextStyle(
                                    color: defaultColor,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${subtotal.round()}.00',
                                  style: TextStyle(
                                    color: lightMode == true
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Tax',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Text(
                                  '\$',
                                  style: TextStyle(
                                    color: defaultColor,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${2 * numberOfCartProducts}.00',
                                  style: TextStyle(
                                    color: lightMode == true
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                  color: lightMode == true
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 18),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Text(
                                  '\$',
                                  style: TextStyle(
                                    color: defaultColor,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  '${subtotal.round() + (2 * numberOfCartProducts)}.00',
                                  style: TextStyle(
                                    color: lightMode == true
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
                child: TextButton(
                  onPressed: () {},
                  child: Container(
                    width: double.infinity,
                    height: 30,
                    child: Center(
                      child: Text(
                        'Chechout',
                        style: TextStyle(
                          color:
                              lightMode == false ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        lightMode == true ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  Widget buildProductItem(
      BuildContext context, ProductData model, lightMode, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 400,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image(
                    image: NetworkImage(
                      model.image,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.1,
                      color: !lightMode ? darkTextcolor : lightTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Text(
                          '\$',
                          style: TextStyle(
                            color: defaultColor,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${model.price.round()}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[100],
                          child: TextButton(
                              onPressed: () {
                                ShopCubit.get(context)
                                    .decreaseProductInCarts(model);
                              },
                              child: Text(
                                '-',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            ShopCubit.get(context)
                                .cartsProductsNumber[index]
                                .toString(),
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[100],
                          child: TextButton(
                              onPressed: () {
                                ShopCubit.get(context)
                                    .increaseProductInCarts(model);
                              },
                              child: Text(
                                '+',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                  onPressed: () {
                    ShopCubit.get(context).removeFromCarts(model);
                  },
                  icon: Icon(
                    Icons.delete_outlined,
                    color: defaultColor,
                    size: 28,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
