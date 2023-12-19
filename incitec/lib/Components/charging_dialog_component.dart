import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogsHelp{
  static void chargingLoading({String? nombre}){
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 130.0,
            width: 20.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10.0,),
                Text(nombre ?? 'Cargando...'),
              ],
            ),
          ),
        )
      )
    );
  }

  static void closeDialog(){
    if(Get.isDialogOpen!){
      Get.back();
    }
  }
}