import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  String error = '';

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailC.text,
        password: passC.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? 'Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24),
              Row(children: [
                Padding(padding: EdgeInsets.only(right: 8.0), child: Icon(Icons.alternate_email, color: Colors.grey)),
                Expanded(
                    child: TextField(
                  controller: emailC,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: UnderlineInputBorder(),
                  ),
                ))
              ]),
              SizedBox(height: 16),
              Row(children: [
                Padding(padding: EdgeInsets.only(right: 8.0), child: Icon(Icons.password, color: Colors.grey)),
                Expanded(
                    child: TextField(
                  controller: passC,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: UnderlineInputBorder(),
                  ),
                  obscureText: true,
                ))
              ]),
              SizedBox(height: 24),
              if (error.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(error,
                        style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold))),
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black, // Changed text color to black
                    fontSize: 18, // Increased text size
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New user?"),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SignupScreen())), // Assuming SignupScreen exists
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.brown, // Changed text color to brown
                        decoration: TextDecoration.underline, // Underlined text
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}