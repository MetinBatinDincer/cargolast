import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kargo/allCargo.dart';
import 'package:kargo/assets/colors.dart';
import 'package:kargo/cargoDetail.dart';
import 'package:kargo/detail_page.dart';
import 'package:kargo/home_page.dart';
import 'package:kargo/home_page2.dart';
import 'package:kargo/login_profile.dart';
import 'package:kargo/qr_code.dart';

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({Key? key}) : super(key: key);

  @override
  State<LoginHomePage> createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {
  int _pageIndex = 0;

  

  final List<Widget> _pages = [
    HomePage2(), // İlk sayfa burada
    DetailPage(),
    QRCode(), // "ekle" sayfası için yer tutucu
    LoginProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         resizeToAvoidBottomInset: false,
      bottomNavigationBar: bottomMenu(),
      appBar: appBarMenu(),
      body: _pages[_pageIndex],
    );
  }

  AppBar appBarMenu() {
    return AppBar(
      
      centerTitle: true,
      backgroundColor: ColorManager.mainColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
          Icon(Icons.add),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.abc),
          ),
        ],
      ),
    );
  }

  CurvedNavigationBar bottomMenu() {
    return CurvedNavigationBar(
      backgroundColor: const Color.fromRGBO(215, 215, 215, 1),
      buttonBackgroundColor: ColorManager.mainColor,
      color: ColorManager.mainColor,
      animationDuration: const Duration(milliseconds: 300),
      index: _pageIndex,
      items: const <Widget>[
        Icon(Icons.home, size: 26, color: Colors.white),
         Icon(Icons.send, size: 26, color: Colors.white),
        Icon(Icons.qr_code, size: 26, color: Colors.white),
        Icon(Icons.person, size: 26, color: Colors.white),
      ],
      onTap: (index) {
        setState(() {
          _pageIndex = index;
        });
      },
    );
  }
}
