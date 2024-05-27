import 'package:flutter/material.dart';
import 'homepage.dart';
import 'authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool isSignIn = true;
  Authentication _authentication = Authentication();

  void signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _authentication.signIn(email, password);

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        errorMessage = 'Invalid email or password';
        emailController.text = '';
      });
    }
  }

  void signUp() async {
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _authentication.signUp(email, password);

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        errorMessage = 'Error creating an account';
        emailController.text = '';
      });
    }
  }

  void toggleScreen() {
    setState(() {
      isSignIn = !isSignIn;
      errorMessage = '';

      firstNameController.text = '';
      lastNameController.text = '';
      emailController.text = '';
      passwordController.text = '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSignIn ? 'Sign In' : 'Sign Up',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              if (!isSignIn)
                Column(
                  children: [
                    TextField(
                      controller: firstNameController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        floatingLabelStyle: const TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white70,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: "First Name",
                        labelStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: lastNameController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        floatingLabelStyle: const TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white70,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: "Last Name",
                        labelStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              TextField(
                controller: emailController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  floatingLabelStyle: const TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white70,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: "Email",
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 18),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8)),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  floatingLabelStyle: const TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white70,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: "Password",
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 18),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8)),
                ),
                style: const TextStyle(color: Colors.black),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSignIn ? signIn : signUp,
                child: Text(
                  isSignIn ? 'Sign In' : 'Sign Up',
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(145, 195, 255, 1))),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: toggleScreen,
                child: Text(
                  isSignIn
                      ? "Don't have an account? Sign Up Now!"
                      : 'Have an Account? Sign in',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
