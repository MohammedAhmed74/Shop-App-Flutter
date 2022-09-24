import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/shop/categories_model.dart';
import 'package:shopapp/shared/cubit/cubit.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/styles/colors.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShopCubit cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
        builder: ((context, state) {
          if (cubit.categoryModel != null) {
            return ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: ((context, index) => buildCategoryItem(
                    cubit.categoryModel!.data.Categories[index],
                    cacheHelper.getValue(key: 'lightMode'))),
                separatorBuilder: ((context, index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        height: 0.3,
                        color: Colors.grey,
                      ),
                    )),
                itemCount: cubit.categoryModel!.data.Categories.length);
          } else
            return Column();
        }),
        listener: ((context, state) {}));
  }

  Widget buildCategoryItem(Category category, bool lightMood) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          children: [
            Container(
              height: 120,
              width: 120,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image(
                image: NetworkImage(category.image),
                height: 120,
                width: 120,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 170,
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: !lightMood ? darkTextcolor : lightTextColor,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: !lightMood ? darkTextcolor : lightTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
