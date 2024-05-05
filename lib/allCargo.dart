import 'package:flutter/material.dart';
import 'package:kargo/assets/colors.dart';
import 'package:kargo/cargoDetail.dart';
import 'package:kargo/services/auth_cargo.dart';
import 'package:kargo/services/auth_service.dart';
import 'package:kargo/services/vairable.dart';

class AllCargo extends StatelessWidget {
  AllCargo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> contacts = [];
    
    for (int i = 0; i < Variable.cargoID.length; i++) {
      // Boş olmayan ID, fromWhere ve toWhere alanları olanları ekleyelim
      
      if (Variable.cargoID[i].isNotEmpty &&
          Variable.cargoNereden[i].isNotEmpty &&
          Variable.cargoNereye[i].isNotEmpty) {
        contacts.add({
          "id": Variable.cargoID[i],
          "fromWhere": Variable.cargoNereden[i],
          "toWhere": Variable.cargoNereye[i],
        });
      }
    }
  

    return FutureBuilder<String>(
      future: dondur(), // FutureBuilder ile dondur fonksiyonunu çağırıyoruz
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Veri bekleniyorsa
          return CircularProgressIndicator(); // Yükleme göstergesi göster
        } else if (snapshot.hasError) {
          // Hata varsa
          return Text('Hata: ${snapshot.error}');
        } else {
          // Veri geldiyse
          final fromCargo = contacts.length;
          return Scaffold(
            backgroundColor: const Color.fromRGBO(215, 215, 215, 1),
            appBar: AppBar(
              title: Text("Kargolarım",style: TextStyle(color: Colors.white),),
              centerTitle: true,
              backgroundColor: ColorManager.mainColor,
            ),
            body: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    color: Colors.amber.shade100,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CargoDetail(cargoId: 
                      contacts[index]["id"].toString(), cargoName: contacts[1].toString()),));
                      },
                      child: itemContactWidget(
                        contacts[index]["id"]!,
                        contacts[index]["fromWhere"]!,
                        contacts[index]["toWhere"]!,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<String> dondur() async {
    // Örnek bir asenkron işlem, gerektiği gibi değiştirilebilir
    return await AuthService().intcargoID(1001) as String;
  }

  ListTile itemContactWidget(dynamic id, String fromWhere, String toWhere) {
    return ListTile(
      leading: Image.asset(
        "assets/images/myCargo.png",
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Text("ID: " + id.toString())],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Nereden: " + fromWhere.toString()),
          Text("Nereye: " + toWhere.toString()),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios_sharp),
    );
  }
}
