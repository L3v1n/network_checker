import 'package:flutter/material.dart';
import 'package:network_checker/home/home_view.dart';

class NetworkCheckerApp extends MaterialApp {
  const NetworkCheckerApp({super.key})
    : super(
        debugShowCheckedModeBanner: false,
        title: 'Network Checker', 
        home: const HomeView(),
      );
}
