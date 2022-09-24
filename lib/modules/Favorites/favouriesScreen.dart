import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/shop/favorites_model.dart';
import 'package:shopapp/models/shop/home_model.dart';
import 'package:shopapp/modules/Product%20Info/ProductInfoScreen.dart';
import 'package:shopapp/shared/cubit/cubit.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/styles/colors.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        if (cubit.favoritesModel != null) {
          return Container(
            width: double.infinity,
            child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => buildFavProduct(
                    cubit.favoritesModel!.data.data.FavInformations[index],
                    cubit.favorites!,
                    context,
                    cacheHelper.getValue(key: 'lightMode')),
                separatorBuilder: ((context, index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        height: 0.3,
                        color: Colors.grey,
                      ),
                    )),
                itemCount:
                    cubit.favoritesModel!.data.data.FavInformations.length),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildFavProduct(FavProductInfo model, Map<int, bool?> favoraties,
      BuildContext context, bool lightMood) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) =>
                    ProductInfo(productId: model.product.id))));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image(
                    image: NetworkImage(
                      model.product.image,
                    ),
                  ),
                ),
                if (model.product.discount != 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
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
            Expanded(
              child: Container(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.1,
                          color: !lightMood ? darkTextcolor : lightTextColor,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            '${model.product.price.round()}',
                            style: TextStyle(
                              color: defaultColor,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          if (model.product.discount != 0)
                            Text(
                              '${model.product.old_price.round()}',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                ShopCubit.get(context)
                                    .changeFavorites(model.product.id);
                              },
                              icon: Icon(
                                favoraties[model.product.id] == true
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                color: favoraties[model.product.id] == true
                                    ? defaultColor
                                    : Colors.grey,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
