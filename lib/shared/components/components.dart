import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//String imageUrl, String title, String time
String imageUrl = '';
bool getImageUrl(article, int index) {
  try {
    imageUrl = '${article[index]['urlToImage']}';
  } catch (e) {
    return false;
  }
  if (article[index]['urlToImage'] == null) return false;
  return true;
}

Widget defaultFormField({
  required TextEditingController txtcon1,
  Function(String)? onChange,
  Function()? onTap,
  required String lable,
  Color color = Colors.white,
  Color focusColor = Colors.blue,
  Icon? pre,
  String? warningMsg,
  bool isPassword = false,
  bool autoFocus = false,
  double borderRadius = 16.0,
  IconData? suff,
  TextInputType? type,
  Function(String)? onFieldSubmitted,
  Function()? suffOnPressed,
}) =>
    TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChange,
      autofocus: autoFocus,
      onTap: onTap != null ? onTap : () {},
      // textDirection: TextDirection.rtl,
      style: TextStyle(
        color: color,
      ),
      controller: txtcon1,
      validator: (txt) {
        if (txt!.isEmpty) {
          return warningMsg;
        }
      },
      obscureText: isPassword,
      keyboardType: type != null ? type : TextInputType.text,
      decoration: InputDecoration(
        labelText: lable,
        focusColor: focusColor,
        labelStyle: TextStyle(fontSize: 18, color: color),
        prefixIcon: pre != null ? pre : SizedBox(),
        suffixIcon: suff != null
            ? IconButton(
                onPressed: suffOnPressed,
                icon: Icon(suff),
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: focusColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: color,
          ),
        ),
      ),
    );

Widget defaultButton({
  required String text,
  required Function onPressed,
  Color backgroundColor = Colors.blue,
  Color textColor = Colors.white,
}) {
  return TextButton(
      child: Container(
        height: 50,
        width: double.infinity,
        color: Colors.blue,
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
      onPressed: () {
        onPressed();
      });
}
