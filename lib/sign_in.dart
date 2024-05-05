import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kargo/assets/colors.dart';
import 'package:kargo/services/auth_service.dart';
import 'package:kargo/services/vairable.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;

  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.mainColor,
      appBar: AppBar(
        leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white), // Geri tuşunun rengi beyaz
    onPressed: () {
      Navigator.pop(context); // Geri tuşuna basıldığında önceki sayfaya dön
    },
  ),
  backgroundColor: ColorManager.mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: Container(
                    width: double.infinity,
                    color: ColorManager.mainColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 80,
                        ),
                        textField("Ad, Soyad", _nameController),
                        textField("Telefon", _phoneController),
                        textField("Mail Adresi", _emailController),
                        passwordField("Şifre", _passwordController),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.cyan.shade200,
     minimumSize: Size(120,44)
  ),
                
                onPressed: () async {
                  final String? errorMessage = _validateInput();
                  if (errorMessage == null) {
                    // No error, print email and password
                    final String email = _emailController.text.trim();
                    final String password = _passwordController.text.trim();
                    final String name = _nameController.text.trim();
                    final String phone = _phoneController.text.trim();

                    final Map<String, dynamic> address = {
                      'city': "",
                      'town': "",
                      'fulladdress': "",
                    };

                    print("Email: $email");
                    print("Şifre: $password");
                    _showSuccessDialog(context);
                    _emailController.clear();
                    _passwordController.clear();

                    try {
                      var userResult =
                          await firebaseAuth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      print(userResult.user!.uid);
                      //ek

                      AuthService().registerUser(
                        email: email,
                        name: name,
                        password: password,
                        phone: phone,
                      );

                      //ek
                    } catch (e) {
                      print(e.toString());
                    }
                  } else {
                    // Error, show error message in a dialog
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
                },
                child: Text(
                  "ÜYE OL",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding textField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorManager.greyColor,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Padding passwordField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorManager.greyColor,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  String? _validateInput() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      return "E-posta adresi boş olamaz";
    }

    if (!isValidEmail(email)) {
      return "Geçersiz e-posta adresi";
    }

    if (password.length < 6) {
      return "Şifre en az 6 karakter olmalıdır";
    }

    return null; // No error
  }

  bool isValidEmail(String email) {
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Başarılı"),
          content: Text("Kayıt başarıyla tamamlandı."),
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
