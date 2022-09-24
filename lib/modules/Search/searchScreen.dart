import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/shop/home_model.dart';
import 'package:shopapp/models/shop/search_model.dart';
import 'package:shopapp/modules/Product%20Info/ProductInfoScreen.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/cubit/cubit.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/styles/colors.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchCtrl = TextEditingController();

  var searchCtrl2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        builder: ((context, state) {
          double height = MediaQuery.of(context).size.height;
          ShopCubit cubit = ShopCubit.get(context);
          bool lightMood = cacheHelper.getValue(key: 'lightMode');
          return Scaffold(
              appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: !cacheHelper.getValue(key: 'lightMode')
                            ? darkTextcolor
                            : lightTextColor,
                      ))),
              body: ConditionalBuilder(
                  condition: cubit.beforeSearch == true,
                  builder: ((context) => Container(
                        height: height / 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Spacer(),
                            Text(
                              'RazeApp',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color:
                                    !lightMood ? darkTextcolor : lightTextColor,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: defaultFormField(
                                    txtcon1: searchCtrl,
                                    borderRadius: 30,
                                    color: !lightMood
                                        ? darkTextcolor
                                        : lightTextColor,
                                    pre: Icon(Icons.search),
                                    lable: 'Search',
                                    onTap: () {
                                      cubit.startSearch();
                                    })),
                          ],
                        ),
                      )),
                  fallback: ((context) => Column(
                        children: [
                          SizedBox(
                            height: 2,
                          ),
                          if (state is LoadingSearchState)
                            LinearProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: defaultFormField(
                              lable: 'Search',
                              autoFocus: true,
                              txtcon1: searchCtrl2,
                              borderRadius: 30,
                              color:
                                  !lightMood ? darkTextcolor : lightTextColor,
                              pre: Icon(Icons.search),
                              onChange: (value) {
                                if (value.isEmpty) {
                                  cubit.searchModel = null;
                                  cubit.endSearch();
                                }
                              },
                              onFieldSubmitted: (value) {
                                print(searchCtrl2.text);
                                cubit.searchForProduct(text: value);
                                print(searchCtrl2.text);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          if (cubit.searchModel != null)
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        buildProduct(
                                            cubit.searchModel!.data
                                                .products[index],
                                            cubit.favorites!,
                                            context,
                                            cacheHelper.getValue(
                                                key: 'lightMode')),
                                    separatorBuilder: ((context, index) =>
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: Container(
                                            height: 0.3,
                                            color: Colors.grey,
                                          ),
                                        )),
                                    itemCount: cubit
                                        .searchModel!.data.products.length),
                              ),
                            )
                        ],
                      ))));
        }),
        listener: ((context, state) {}));
  }

  Widget buildProduct(ProductData model, Map<int, bool?> favoraties,
      BuildContext context, bool lightMood) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ProductInfo(productId: model.id))));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 120,
              height: 120,
              child: Image(
                image: NetworkImage(
                  model.image,
                ),
                width: 120,
                height: 120,
              ),
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
                        model.name,
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
                          SizedBox(
                            width: 2,
                          ),
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
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                ShopCubit.get(context)
                                    .changeFavorites(model.id);
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

// {
//                                     cubit.searchForProduct(text: text);
//                                     if (text.isNotEmpty)
//                                       cubit.emptySearchText = false;
//                                     else {
//                                       cubit.emptySearchText = true;
//                                       cubit.searchModel = null;
//                                     }
//                                   }