import 'package:flutter/material.dart';
import 'package:kargo/assets/colors.dart';

class QRCode extends StatelessWidget {
  const QRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(child: Column(children: [
        
        qrOpen(),
        qrScreen()
        
      ],),),
    );
  }

  Padding qrOpen() {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
         boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // gölge konumu, y ekseninde 3 birim aşağı
          ),
        ],
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(15.0), // Kenarları yumuşat
      ),
      child: Column(
        children: [
          Icon(Icons.qr_code, size: 60,),
          Container(
            color: ColorManager.greyColor,
            width: 240,
            height: 240,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Galeriden Seç", style: TextStyle(color: Colors.black),),
          ),
          SizedBox(height: 0,)
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    ),
  );
}



Padding qrScreen() {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
         boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // gölge konumu, y ekseninde 3 birim aşağı
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0), // Kenarları yumuşat
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.qr_code, size: 80,),
              Column(
                children: [
                  Text("Kargo Kodunuz"),
                  Text("15584254458")
                ],
              )
            ],
          ),
          SizedBox(height: 24,),
          Container(
            color: ColorManager.greyColor,
            width: 240,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Açık Adres:"),
            ),
          ),
          SizedBox(height: 24,),
          Container(
            color: ColorManager.greyColor,
            width: 240,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Aras Kargo"),
            ),
          ),
          SizedBox(height: 24,),
          Container(
            color: ColorManager.greyColor,
            width: 240,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Tahmini varış süresi 3 Gün"),
            ),
          ),
          SizedBox(height: 24,),
          ElevatedButton(
            onPressed: () {},
            child: Text("Kargolarıma Ekle", style: TextStyle(color: Colors.black),),
          ),
          SizedBox(height: 20,),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    ),
  );
}


  
}