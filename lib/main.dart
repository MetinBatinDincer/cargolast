import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kargo/assets/colors.dart';
import 'package:kargo/detail_page.dart';
import 'package:kargo/home_page.dart';
import 'package:kargo/profile.dart';
import 'package:kargo/qr_code.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
persistenceEnabled: true
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
  //  DetailPage(),
    QRCode(), // Placeholder for "add" page
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(215, 215, 215, 1),
        appBar: appBarMenu(),
        body: _pages[_pageIndex],
        bottomNavigationBar: bottomMenu(),
      ),
    );
  }

  CurvedNavigationBar bottomMenu() {
    return CurvedNavigationBar(
      backgroundColor: const Color.fromRGBO(215, 215, 215, 1),
      buttonBackgroundColor: ColorManager.mainColor,
      color: ColorManager.mainColor,
      animationDuration: const Duration(milliseconds: 300),
      items: const <Widget>[
        Icon(Icons.home, size: 26, color: Colors.white),
   //     Icon(Icons.send, size: 26, color: Colors.white),
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
        icon: Icon(Icons.add),
      ),
    ],
  ),
    );

  }
}
