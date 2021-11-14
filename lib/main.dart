import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:innopolis_hack/screens/create_sunflower_sample_screen.dart';
import 'screens/sunflower_main_catalog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScreenUtilInit(
        designSize: Size(360, 640),
        builder: () => SunflowerMainCatalog(),
      ),
    );
  }
}
