import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kargo/services/vairable.dart';

class AuthServiceCargo {
  final userCollection = FirebaseFirestore.instance.collection("cargo");

  Future<void> registerUser({required String email}) async {
    // Belirtilen e-posta adresine sahip kullanıcıyı kontrol et
    QuerySnapshot querySnapshot = await userCollection.where('email', isEqualTo: email).get();
  
    // Eğer belirtilen e-posta adresine sahip bir kullanıcı yoksa
    if (querySnapshot.docs.isEmpty) {
      // Kullanıcıyı kaydet
      await userCollection.doc().set({
        "email": email,
      });
    }
  }

  Future<void> altkume(String email,String send_city,String send_town,String send_fullAddress,String cargoName,String cargoPrice,String cargoTime,String get_city,String get_town,String get_fullAddress) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference usersCollection = firestore.collection('cargo');

  // 'email' alanına sahip belgeyi bulma
  QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: email).get();
  
  if (querySnapshot.docs.isNotEmpty) {
    DocumentReference userDoc = querySnapshot.docs.first.reference;

    // 'email' alanına sahip belgenin alt koleksiyonunu oluşturma
    CollectionReference emailCollection = userDoc.collection('email');

    // Yeni veriyi alt koleksiyona ekleme
    DocumentReference newDocRef = emailCollection.doc(); // Döküman adını "batuhan" olarak ayarla

    await newDocRef.set({
       'sender_address': {
         'city': send_city,
         'town': send_town,
         'fulladdress': send_fullAddress,
       },
       'getter_address': {
         'city': get_city,
         'town': get_town,
         'fulladdress': get_fullAddress,
       },
       'cargo_info': {
         'company': cargoName,
         'price': cargoName,
         'estimated_arrival':cargoTime
       },
       'date': Timestamp.now(),
    });

    print("Alt koleksiyon başarı ile oluşturuldu ve veri eklendi.");
  } else {
    print("Belirtilen e-posta adresine sahip kullanıcı bulunamadı.");
  }
}


Future<List<Map<String, dynamic>>?> getVeri() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference emailCollection = firestore.collection('cargo').doc(Variable.variable).collection('email');

  // Tüm belgeleri al
  QuerySnapshot querySnapshot = await emailCollection.get();

  if (querySnapshot.docs.isNotEmpty) {
    // Belirtilen e-posta adresine sahip olan tüm belgelerin verilerini alırız
    List<Map<String, dynamic>> userDataList = [];
    querySnapshot.docs.forEach((doc) {
      var data = doc.data();
      if (data != null && data is Map<String, dynamic>) {
        if (data.containsKey('cargo_info')) {
          var cargoInfo = data['cargo_info'];
          if (cargoInfo is Map<String, dynamic> && cargoInfo.containsKey('company')) {
            userDataList.add(cargoInfo);
            var companyValue = cargoInfo['company'];
            print("Company: $companyValue");
          } else {
            print("Belirtilen belgede company alanı bulunamadı.");
          }
        } else {
          print("Belgede cargo_info haritası bulunamadı.");
        }
      } else {
        print("Belgeden veri alınamadı veya uygun türde değil.");
      }
    });

    Variable.CargoInfo.addAll(userDataList); // Tüm belgeleri ekleyin
    return userDataList;
  } else {
    print("Belirtilen e-posta adresine sahip kullanıcı bulunamadı.");
    return null;
  }
}



Future<List<String>?> GetNeredenVeri() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference allCargoCollection = firestore.collection('allcargo');

  try {
    QuerySnapshot querySnapshot = await allCargoCollection.where('email', isEqualTo: Variable.variable).get();

    List<String> neredenList = [];

    querySnapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>?; // Veriyi Map<String, dynamic> olarak belirtiyoruz
      if (data != null && data.containsKey('nereden') && data['nereden'] is String) {
        neredenList.add(data['nereden'] as String);
      }
    });
    

    for (int i = 0; i < neredenList.length; i++) {
    if (!Variable.cargoNereden.contains(neredenList[i])) {
    Variable.cargoNereden.add(neredenList[i]);
    }
      }



    print(neredenList.toString());

    
    return neredenList;
  } catch (e) {
    print("Nereden veri getirme işlemi başarısız oldu: $e");
    return null;
  }
}

Future<List<String>?> GetNereyeVeri() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference allCargoCollection = firestore.collection('allcargo');

  try {
    QuerySnapshot querySnapshot = await allCargoCollection.where('email', isEqualTo: Variable.variable).get();

    List<String> nereyeList = [];

    querySnapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>?; // Veriyi Map<String, dynamic> olarak belirtiyoruz
      if (data != null && data.containsKey('nereye') && data['nereye'] is String) {
        nereyeList.add(data['nereye'] as String);
      }
    });
   for (int i = 0; i < nereyeList.length; i++) {
    if (!Variable.cargoNereye.contains(nereyeList[i])) {
    Variable.cargoNereye.add(nereyeList[i]);
    }
      }





    
    print(nereyeList.toString());
    
    return nereyeList;
  } catch (e) {
    print("nereye veri getirme işlemi başarısız oldu: $e");
    return null;
  }
}

Future<List<String>?> GetIDVeri() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference allCargoCollection = firestore.collection('allcargo');

  try {
    QuerySnapshot querySnapshot = await allCargoCollection.where('email', isEqualTo: Variable.variable).get();

    List<String> IDList = [];

    querySnapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>?; // Veriyi Map<String, dynamic> olarak belirtiyoruz
      if (data != null && data.containsKey('ID') && data['ID'] is String) {
        IDList.add(data['ID'] as String);
      }
    });
   for (int i = 0; i < IDList.length; i++) {
  if (!Variable.cargoID.contains(IDList[i])) {
    Variable.cargoID.add(IDList[i]);
  }
}

    print(IDList.toString());
    
    return IDList;
  } catch (e) {
    print("ID veri getirme işlemi başarısız oldu: $e");
    return null;
  }
}












}
