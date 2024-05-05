import 'package:flutter/material.dart';
import 'package:kargo/assets/colors.dart';
import 'package:kargo/home_page.dart';
import 'package:kargo/login_home_page.dart';
import 'package:kargo/qr_code.dart';
import 'package:kargo/services/auth_cargo.dart';
import 'package:kargo/services/auth_service.dart';
import 'package:kargo/services/vairable.dart';
import 'package:kargo/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyColor,
      appBar: AppBar(backgroundColor: ColorManager.greyColor,),
      body: Container(
        
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              logInContainer(),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    _signIn(); // Context'i parametre olarak eklemeye gerek yok
                  AuthServiceCargo().GetNeredenVeri();
                  AuthServiceCargo().GetNereyeVeri();
                  AuthServiceCargo().GetIDVeri();
                  AuthService().veriAlma();
                  },
                  child: Text("Giriş"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 44),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  child: Text("Üye Ol"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 44),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding logInContainer() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          color: ColorManager.mainColor,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80,),
            textField("Mail Adresi", _emailController),
            textField("Şifre", _passwordController),
          ],
        ),
      ),
    );
  }

  Padding textField(String write, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: write == "Şifre", // Şifre alanını gizle
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

  Future<void> _signIn() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (!_isValidEmail(email)) {
      _showErrorDialog("Geçersiz e-posta adresi");
      return;
    } else if (password.length < 6) {
      _showErrorDialog("Şifre en az 6 karakter olmalıdır");
      return;
    } else {
      try {
        final UserCredential userResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
          
        );
        print(userResult.user!.email);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginHomePage()),
        );
        Variable.variable=email;
      } catch (e) {
        print("Giriş başarısız. Hata: ${e.toString()}");
        _showErrorDialog("Şifre veya mail yanlış");
      }
      _emailController.clear();
      _passwordController.clear();
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hata"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Tamam"),
            ),
          ],
        );
      },
    );
  }
}
