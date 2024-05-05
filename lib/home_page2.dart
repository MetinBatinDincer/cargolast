import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:kargo/assets/colors.dart';
import 'package:kargo/cargoDetail.dart';
import 'package:kargo/allCargo.dart';
import 'package:kargo/services/auth_cargo.dart';
import 'package:kargo/services/auth_service.dart';
import 'package:kargo/services/vairable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Benim Uygulamam',
      theme: ThemeData(),
      home: HomePage2(),
    );
  }
}

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  static List<Map<String, dynamic>> myCargo = [
    {"id": 1, "name": ""},
    {"id": 2, "name": ""},
    {"id": 3, "name": ""},
    {"id": 4, "name": ""},

    // Diğer kargo bilgileri...
  ];

  final TextEditingController kargoIdController = TextEditingController();
  bool isSearchPressed = false;
  String neredenSonuc = "";
  String nereyeSonuc = "";
  String idSonuc = "";
  String companySonuc = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: arkaPlan(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: resimContainer(),
          ),
          Positioned(
            top: 160,
            left: (MediaQuery.of(context).size.width - 332) / 2,
            child: kargoSorgu(),
          ),
          Positioned(
            bottom: 20.0,
            left: (MediaQuery.of(context).size.width - 332) / 2,
            child: kargolarim(),
          ),
        ],
      ),
    );
  }

  Widget kargoSorgu() {
    return Container(
      width: 332,
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Container(
                child: TextField(
                  controller: kargoIdController,
                  decoration: InputDecoration(
                    hintText: "Kargo id",
                    suffixIcon: IconButton(
                      onPressed: () async {
                        setState(() {
                          isSearchPressed = true; // Arama düğmesine basıldığında değişiklik
                        });
                        try {
                          await AuthService().nereyeKargoID(kargoIdController.text.toString());
                          await AuthService().neredenKargoID(kargoIdController.text.toString());
                          await AuthService().companyKargoID(kargoIdController.text.toString());
                          await AuthService().IDKargoID(kargoIdController.text.toString());

                          setState(() {
                            idSonuc = Variable.kargoID;
                            neredenSonuc = Variable.kargoNereden;
                            nereyeSonuc = Variable.kargoNereye;
                            companySonuc = Variable.kargoCompany;
                          });
                          print("Kargo firması: $companySonuc, kargom nereden: $neredenSonuc, kargom nereye: $nereyeSonuc");
                          print(kargoIdController.text.toString());
                          print(neredenSonuc);
                        } catch (e) {
                          print("ID boş olamaz: ${e.toString()}");
                        }
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isSearchPressed,
            child: Container(
              height: 160,
              child: searchThenWidget(),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Center searchThenWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/myCargo.png",
            width: 64,
            height: 64,
          ),
          Container(
            child:  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Nereden: $neredenSonuc"),
                    Text("Nereye: $nereyeSonuc"),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("ID: $idSonuc"),
                    Text("Şirket: $companySonuc"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container kargolarim() {
    return Container(
      width: 332,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () async {
              await AuthServiceCargo().GetNeredenVeri();
              await AuthServiceCargo().GetNereyeVeri();
              await AuthServiceCargo().GetIDVeri();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllCargo(),
                ),
              );
            },
            child: Text("Tümü"),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: myCargo.map((contact) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CargoDetail(
                                        cargoId: contact["id"].toString(),
                                        cargoName: contact["name"],
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/myCargo.png",
                                      width: 64,
                                      height: 64,
                                    ),
                                    Text(
                                      contact["name"]!,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container resimContainer() {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.red,
            child: AnotherCarousel(
              images: [
                AssetImage("assets/images/cheetah2.jpg"),
                AssetImage("assets/images/cheetah3.jpg"),
              ],
              dotSize: 4,
              indicatorBgPadding: 0,
              dotIncreasedColor: ColorManager.mainColor,
              moveIndicatorFromBottom: 100,
              dotPosition: DotPosition.topRight,
            ),
          ),
        ],
      ),
    );
  }

  Container arkaPlan() {
    return Container(
      color: const Color.fromRGBO(215, 215, 215, 1),
    );
  }
}
