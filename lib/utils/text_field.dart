import 'package:flutter/material.dart';
//import 'package:Twara/localization/app_translations.dart';
import 'package:flutter/services.dart';



Widget text_field({
  required TextEditingController controller,
  required FocusNode focusNode,
  required String label,
  required String requiredMsg,
  required String hint,
  required double width,
  required bool obscureText,
  required int maxlength,
  required int minlength,
  required Icon prefixIcon,
  required Text suffixIcon,
  required String keyboardType,
  required TextInputFormatter mask,
  required Function(String) locationCallback, required TextEditingController TextEditingController,
}) {
  return Container(

      /*decoration: new BoxDecoration(
        //color: Colors.white,
        boxShadow: [
          //background color of box
          BoxShadow(
            color: Colors.black,
            blurRadius: 1.0, // soften the shadow
            //spreadRadius: 5.0, //extend the shadow
            offset: Offset(
              1.0, // Move to right 10  horizontally
              1.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
       */
    child: TextFormField(
      onChanged: (value) {
        locationCallback(value);
      },
      validator: (value) {
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color:Color.fromARGB(255, 179, 102,1),
            width: 2,
          ),
        );
        if (value=='') {
          return requiredMsg;
        }
        return null;
      },
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      maxLength: maxlength ,
      //inputFormatters:[mask]!=null?[mask]:'',
      keyboardType:(keyboardType=='email')?TextInputType.emailAddress:(keyboardType=='number')?TextInputType.number:(keyboardType=='datetime')?TextInputType.datetime:TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: label,
        filled: true,
        fillColor: Colors.transparent,
         enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),


        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),

        contentPadding: const EdgeInsets.all(15),
        hintText: hint,
      ),
    ),
  );
}
