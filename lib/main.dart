import 'package:flutter/material.dart';
import 'package:flutter_mmnes/pages/home.dart';
import 'package:flutter_mmnes/pages/home_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// 任务管理器显示的标题
      title: "Flutter Demo",

      /// 右上角显示一个debug的图标
      debugShowCheckedModeBanner: false,

      /// 主页
//      home: NesHomePage(),
      home: XianyuHomePage(),
    );
  }
}
