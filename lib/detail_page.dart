import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kargo/services/auth_cargo.dart';
import 'package:kargo/services/auth_service.dart';
import 'package:kargo/services/vairable.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int? _selectedRadio = 0;
  bool _isVisible = false;
  String cargoName = "";
  String cargoTime = "";
  String cargoPrice = "";

  final TextEditingController aliciIlController = TextEditingController();
  final TextEditingController aliciIlceController = TextEditingController();
  final TextEditingController aliciAdresController = TextEditingController();

  final TextEditingController gonderenIlController = TextEditingController();
  final TextEditingController gonderenIlceController = TextEditingController();
  final TextEditingController gonderenAdresController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: cargoBilgi("Alıcı", aliciIlController, aliciIlceController, aliciAdresController),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: cargoBilgi("Gönderen", gonderenIlController, gonderenIlceController, gonderenAdresController),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isVisible = true;
                });
              },
              child: Text("Onay"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 44),
              ),
            ),
          ),
          SizedBox(height: 10),
          if (_isVisible) cargoCompony(),
          SizedBox(height: 10),
          if (_isVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () async {
                  String aliciIl = aliciIlController.text;
                  String aliciIlce = aliciIlceController.text;
                  String aliciAdres = aliciAdresController.text;

                  String gonderenIl = gonderenIlController.text;
                  String gonderenIlce = gonderenIlceController.text;
                  String gonderenAdres = gonderenAdresController.text;

                  if (aliciIl.isEmpty ||
                      aliciIlce.isEmpty ||
                      aliciAdres.isEmpty ||
                      gonderenIl.isEmpty ||
                      gonderenIlce.isEmpty ||
                      gonderenAdres.isEmpty) {
                    // Eğer bir veya daha fazla textfield boş ise
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Uyarı"),
                          content: Text("Lütfen tüm alanları doldurunuz."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Tamam"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Tüm textfield'lar dolu ise
                    // Kargo adını güncelleyin
                    if (_selectedRadio == 0) {
                      cargoName = "Aras Kargo";
                      cargoPrice = "886";
                      cargoTime = "08.04.2024";
                    } else if (_selectedRadio == 1) {
                      cargoName = "Yurtiçi Kargo";
                      cargoPrice = "886";
                      cargoTime = "08.08.2024";
                    } else if (_selectedRadio == 2) {
                      cargoName = "Velihan Pazarlama";
                      cargoTime = "08.04.2032";
                      cargoPrice = "3640";
                    }

                    // Kullanıcıyı kaydedin ve altküme oluşturun
                    // Buradaki işlemler asenkron olduğu için await kullanılabilir
                    await AuthServiceCargo().registerUser(email: Variable.variable);
                    await AuthServiceCargo().altkume(Variable.variable, gonderenIl, gonderenIlce, gonderenAdres, cargoName, cargoPrice, cargoTime,aliciIl, aliciIlce, aliciAdres,);
                    /*
                    await AuthServiceCargo().altkume(Variable.variable, gonderenIl, gonderenIlce, gonderenAdres, cargoName, cargoPrice, cargoTime);
                    */

                    // Kargo adını yazdır "ID" =
                    Variable.cargoNereden.add(gonderenIl);
                    Variable.cargoNereye.add(aliciIl);
                    int randomNumber = generateRandomNumber();
                    String randomID = randomNumber.toString();
                    print(randomID);

                    await AuthService().setCargo(ID: randomID, nereden: Variable.cargoNereden.last, nereye: Variable.cargoNereye.last, company: cargoName, company_time: cargoTime, gondericiacikadres: gonderenAdres, aliciacikadres: aliciAdres);
                    await AuthServiceCargo().GetNeredenVeri();
                    await AuthServiceCargo().GetNereyeVeri();

                    // Mesaj kutusunu göster
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Bilgi"),
                          content: Text("${randomID} ID'li Kargonuz Gönderildi."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Tamam"),
                            ),
                          ],
                        );
                      },
                    );

                    print("KARGO ADI: " + cargoName + cargoPrice + cargoTime);
                    aliciIlController.clear();
                    aliciIlceController.clear();
                    aliciAdresController.clear();
                    gonderenIlController.clear();
                    gonderenIlceController.clear();
                    gonderenAdresController.clear();
                  }
                },
                child: Text("Gönder"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 44),
                ),
              ),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Padding cargoCompony() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
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
          children: [
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Aras Kargo"),
                  ),
                  Text("18 iş günü, fiyat 886"),
                  Radio(
                    value: 0,
                    groupValue: _selectedRadio,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedRadio = value;
                      });
                    },
                  )
                ],
              ),
            ),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Yurtiçi Kargo"),
                  ),
                  Text("8 iş günü, fiyat 886"),
                  Radio(
                    value: 1,
                    groupValue: _selectedRadio,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedRadio = value;
                      });
                    },
                  )
                ],
              ),
            ),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Velihan Pazarlama"),
                  ),
                  Text("55 iş günü, fiyat 3640"),
                  Radio(
                    value: 2,
                    groupValue: _selectedRadio,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedRadio = value;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container cargoBilgi(String title, TextEditingController ilController, TextEditingController ilceController, TextEditingController adresController) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          textField("İl", ilController),
          textField("İlçe", ilceController),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: adresController,
              minLines: 5,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: "Açık Adres",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding textField(String write, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          hintText: write,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  int generateRandomNumber() {
    Random random = Random();
    String randomNumber = '';
    for (int i = 0; i < 10; i++) {
      randomNumber += random.nextInt(10).toString();
    }
    return int.parse(randomNumber);
  }
}
