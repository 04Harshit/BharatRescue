import 'dart:async';
import 'package:flutter/material.dart';
import 'master_screen.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MasterScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bharat Rescue'),
      ),
      body: const Center(
        child:
          Image(image: AssetImage('assets/images/br-logo-mobile-01.png'))
        //  SvgPicture.asset(
        //  "assets/images/br-logo-01.svg",
        //   height: 64,
        // ),
      ),
    );
  }
}