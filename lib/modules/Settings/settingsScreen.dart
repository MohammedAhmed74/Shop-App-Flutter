import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/cubit/cubit.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/styles/colors.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';

class SettingsScreen extends StatelessWidget {
  var emailCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();
  var nameCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        nameCtrl.text = cubit.profileModel!.data!.name;
        emailCtrl.text = cubit.profileModel!.data!.email;
        phoneCtrl.text = cubit.profileModel!.data!.phone;
        bool lightMood = cacheHelper.getValue(key: 'lightMode');
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  if (state is LoadingUpdateProfilesDataState)
                    LinearProgressIndicator(),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: defaultFormField(
                      txtcon1: nameCtrl,
                      lable: 'Name',
                      type: TextInputType.name,
                      warningMsg: 'Name shouldn\'t be empty',
                      color: !lightMood ? darkTextcolor : lightTextColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: defaultFormField(
                      txtcon1: emailCtrl,
                      lable: 'Email',
                      type: TextInputType.emailAddress,
                      warningMsg: 'Email shouldn\'t be empty',
                      color: !lightMood ? darkTextcolor : lightTextColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: defaultFormField(
                      txtcon1: phoneCtrl,
                      lable: 'Phone',
                      type: TextInputType.phone,
                      warningMsg: 'Phone shouldn\'t be empty',
                      color: !lightMood ? darkTextcolor : lightTextColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: defaultButton(
                        text: 'UPDATE',
                        onPressed: () {
                          cubit.updateProfile(
                              name: nameCtrl.text,
                              phone: phoneCtrl.text,
                              email: emailCtrl.text);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: defaultButton(
                        text: 'SIGN OUT',
                        onPressed: () {
                          signOut(context);
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
