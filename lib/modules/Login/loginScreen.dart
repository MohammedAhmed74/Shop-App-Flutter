import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopapp/Layout/ShopLayout/shopLayout.dart';
import 'package:shopapp/main.dart';
import 'package:shopapp/models/shop/home_model.dart';
import 'package:shopapp/modules/Login/cubit/cubit.dart';
import 'package:shopapp/modules/Login/cubit/states.dart';
import 'package:shopapp/modules/Login/registerScreen.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Shop_Login_Cubit(),
      child: BlocConsumer<Shop_Login_Cubit, Shop_Login_States>(
        listener: (context, state) {
          if (state is SuccessLoginState) {
            if (state.loginModle.status == true) {
              cacheHelper.setValue(
                  key: 'token', value: state.loginModle.data!.token);
              print(cacheHelper.getValue(key: 'token'));
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => shopLayout()));
            } else {
              Fluttertoast.showToast(
                  msg: state.loginModle.message,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        },
        builder: (context, state) {
          Shop_Login_Cubit cubit = Shop_Login_Cubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Login now to browse our hot offers',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black45),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          defaultFormField(
                              txtcon1: emailCtrl,
                              lable: 'Email',
                              type: TextInputType.emailAddress,
                              color: Colors.black,
                              warningMsg: 'Email can\'t be empty',
                              pre: Icon(Icons.email_outlined)),
                          SizedBox(
                            height: 20,
                          ),
                          defaultFormField(
                            txtcon1: passwordCtrl,
                            lable: 'Password',
                            type: TextInputType.visiblePassword,
                            color: Colors.black,
                            pre: Icon(Icons.lock),
                            onFieldSubmitted: (text) {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                  email: emailCtrl.text,
                                  password: passwordCtrl.text,
                                );
                              }
                            },
                            warningMsg: 'Password is too short or empty',
                            suff: Shop_Login_Cubit.get(context).passwordSuff,
                            isPassword:
                                Shop_Login_Cubit.get(context).isPassword,
                            suffOnPressed: () {
                              Shop_Login_Cubit.get(context).showPassword();
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(
                            condition: state is! LoadingLoginState,
                            builder: (context) => defaultButton(
                                text: 'LOGIN',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userLogin(
                                      email: emailCtrl.text,
                                      password: passwordCtrl.text,
                                    );
                                  }
                                }),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.black, fontSize: 15),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                  },
                                  child: Text(
                                    'REGISTER',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
