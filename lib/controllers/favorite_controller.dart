import 'package:get/get.dart';
import 'package:flutter/material.dart';



class TestController extends GetxController {
  int count = 0;

  void increment(){
    count ++;
    update();
  }
}


