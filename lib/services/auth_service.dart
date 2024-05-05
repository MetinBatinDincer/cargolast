import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kargo/services/vairable.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  var gelenveri = "veriyi almadı";

  Future<void> registerUser({
    required String email,
    required name,
    required password,
    required String phone,
  }) async {
    await userCollection.doc().set({
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
    });
  }

  Future<void> setCargo({
    required String ID,
    required String nereden,
    required String nereye,
    required String company,
    required String company_time,
    required String gondericiacikadres,
    required String aliciacikadres,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference allCargoCollection = firestore.collection('allcargo');

    await allCargoCollection.add({
      "email": Variable.variable,
      "ID": ID,
      "nereden": nereden,
      "nereye": nereye,
      "company": company,
      "company_time": company_time,
      "gondericiacikadres": gondericiacikadres,
      "aliciacikadres": aliciacikadres,
      "date": Timestamp.now()
    });
  }

  //collectionın içine collection oluşturma yapısı eğer verileri kullanıcıdan alıcaksanız üstteki gibi metodu parametreli alıp eşitlersiniz burda maile göre collectionı bulup o collectionun altına ekliyor maili değişkene atarsanız değişkende tutup b@gmail.com yerine o değişkenle deneyin
  Future<void> useraddress(
      String email, String city, String town, String fulladdress) async {
    await Firebase.initializeApp();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference usersCollection = firestore.collection('users');

    // 'b@gmail.com' isimli belgeyi bulma yerimiz
    QuerySnapshot querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference batuhanDoc = querySnapshot.docs.first.reference;

      // 'b@gmail.com' bu verinin olduğu yere 'cargowhere' alt koleksiyonunu ekleme yerimiz
      CollectionReference addressCollection = batuhanDoc.collection('address');

      // alt koleksiyona istediğimiz veriyi ekleme yerimiz
      await addressCollection.add({
        'city': city,
        'town': town,
        'fulladdress': fulladdress,
        'date': Timestamp.now(),
      });

      print("alt küme başarı ile alındı.");
    } else {
      print("Belirtilen isimde kullanıcı bulunamadı.");
    }
  }

//adress oluşturma methodu
  Future<void> addaddress({
    String? city,
    String? town,
    String? fullAddress,
  }) async {
    Map<String, dynamic> userData = {};

    // Adres bilgileri verildiyse, userData'ya ekle
    if (city != null && town != null && fullAddress != null) {
      userData["address"] = {
        "city": city,
        "town": town,
        "fullAddress": fullAddress,
      };
    }

    await userCollection.add(userData);
  }

//bu fonksiyonda veriyi yine mailden çekiyor istediğin veriyi yazdırıyor mesela burda b@gmail.comdan name verisini çekiyor yalnız future<string> olarak alıyor ona dikkat edin string almıyor.
  Future<String> veriAlma() async {
    try{
    late String userName;

    String userEmail = Variable.variable; // Kullanıcının e-posta adresi

    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('phone')) {
          userName = userData['phone']; // 'name' alanını al
          print(userName);
          Variable.personPhone = userName;
        } else {
          print('Kullanıcı verileri içinde phone alanı bulunamadı.');
        }
        if (userData != null && userData.containsKey('name')) {
          userName = userData['name']; // 'name' alanını al
          print(userName);
          Variable.personName = userName;
        } else {
          print('Kullanıcı verileri içinde name alanı bulunamadı.');
        }
        
      });
    });

    return userName; // userName değerini geri döndür
    }
    catch(e){
      return "bos olay";
    }
  }

//kargo idsinden veri çekme
  Future<String> intcargoID(int ID) async {
    late String kargoinfo=ID.toString();//burada hata mevcut

    await FirebaseFirestore.instance
        .collection('cargo')
        .where('ID', isEqualTo: ID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('fromwhere')) {
          kargoinfo = userData['fromwhere']; // 'name' alanını al
          print(kargoinfo);
        } else {
          print('Kullanıcı verileri içinde phone alanı bulunamadı.');
        }
      });
    });

    return kargoinfo;
  }

  Future<List<dynamic>> cargoList(int ID) async {
    List<dynamic> kargoinfo = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cargo')
        .where('ID', isEqualTo: ID)
        .get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('fromwhere')) {
        kargoinfo.add(userData['fromwhere']);
        kargoinfo.add(userData['towhere']);

        print("listenin 1. elemanı: " + kargoinfo[0]);
        print("listenin 2. elemanı: " + kargoinfo[1]);
      } else {
        print('Kullanıcı verileri içinde fromwhere alanı bulunamadı.');
      }
    });

    return kargoinfo;
  }

  Future<List<dynamic>> cargomaillist() async {
    String email = Variable.variable;
    List<dynamic> kargoinfo = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cargo')
        .where('email', isEqualTo: email)
        .get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('fromwhere')) {
        kargoinfo.add(userData['fromwhere']);
        kargoinfo.add(userData['towhere']);

        print("listenin 1. elemanı: " + kargoinfo[0]);
        print("listenin 2. elemanı: " + kargoinfo[1]);
      } else {
        print('Kullanıcı verileri içinde fromwhere alanı bulunamadı.');
      }
    });

    return kargoinfo;
  }
//ID üstünden verileri çeken fonksiyonlar
  Future<String> neredenKargoID(String ID) async {
   try{
     late String kargoinfo;

    await FirebaseFirestore.instance
        .collection('allcargo')
        .where('ID', isEqualTo: ID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('nereden')) {
          kargoinfo = userData['nereden'];
          Variable.kargoNereden = kargoinfo;
          
        } else {
          print('Kullanıcı verileri içinde phone alanı bulunamadı.');
        }
      });
    });
    return kargoinfo;
   }catch(e){
    return "boş olay";

   }
  }

  Future<String> nereyeKargoID(String ID) async {
    try{
      late String kargoinfo;

    await FirebaseFirestore.instance
        .collection('allcargo')
        .where('ID', isEqualTo: ID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('nereye')) {
          kargoinfo = userData['nereye'];
          Variable.kargoNereye = kargoinfo;
        } else {
          print('Kullanıcı verileri içinde phone alanı bulunamadı.');
        }
      });
    });
    return kargoinfo;
    }catch(e){
      return "boş olay";
    }
  }

  Future<String> companyKargoID(String ID) async {
    try{
      late String kargoinfo;

    await FirebaseFirestore.instance
        .collection('allcargo')
        .where('ID', isEqualTo: ID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('company')) {
          kargoinfo = userData['company'];
          Variable.kargoCompany = kargoinfo;
        } else {
          print('Kullanıcı verileri içinde phone alanı bulunamadı.');
        }
      });
    });
    return kargoinfo;
    }catch(e){
      return "boş olay";
    }
  }

  Future<String> IDKargoID(String ID) async {
    try{
      late String kargoinfo;

    await FirebaseFirestore.instance
        .collection('allcargo')
        .where('ID', isEqualTo: ID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('ID')) {
          kargoinfo = userData['ID'];
          Variable.kargoID = kargoinfo;
        } else {
          print('Kullanıcı verileri içinde phone alanı bulunamadı.');
        }
      });
    });
    return kargoinfo;
    }catch(e){
      return "boş olay";
    }
  }

  Future<String> getterAddressKargoID(String ID) async {

    try{
      late String kargoinfo;

    await FirebaseFirestore.instance
        .collection('allcargo')
        .where('ID', isEqualTo: ID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('aliciacikadres')) {
          kargoinfo = userData['aliciacikadres'];
          Variable.getadres = kargoinfo;
        } else {
          print('Kullanıcı verileri içinde phone alanı bulunamadı.');
        }
      });
    });
    return kargoinfo;
    }catch(e){
      return "boş olay";
    }
  }

  Future<String> setterAddressKargoID(String ID) async {

    try{
      late String kargoinfo;

    await FirebaseFirestore.instance
        .collection('allcargo')
        .where('ID', isEqualTo: ID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('gondericiacikadres')) {
          kargoinfo = userData['gondericiacikadres'];
          Variable.setadres = kargoinfo;
        } else {
          print('Kullanıcı verileri içinde phone alanı bulunamadı.');
        }
      });
    });
    return kargoinfo;
    }catch(e){
      return "boş olay";
    }
  }

  
}
