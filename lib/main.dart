import 'package:flutter/material.dart';
import 'pages/homePage.dart';
import './data/feed_data.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt locator = GetIt.instance;
  locator.registerSingleton<FeedViewModel>(FeedViewModel());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Videostream',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}


