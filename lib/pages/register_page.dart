import 'package:chat_messengerapp/components/my_button.dart';
import 'package:chat_messengerapp/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  //Sign up User
  Future<void> signUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //if password match
    if (passwordController.text != confirmpasswordController.text) {
      // pop loading circle
      Navigator.pop(context);
      //show error to user
      displayMessage("Passwords don't match!");
      return;
    }
    //try creating the user
    try {
      //creat new user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // after creating the new user, create a new document in cloud firestore called Users
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
            'username' : emailController.text.split('@')[0], //inital username
            'bio' : 'This user is Shy..' // initally empaty bio
            // add any additional fields as needed
          });

      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //Show error to user
      displayMessage(e.code);
    }
  }

  //display a dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 0),
                  //Logo
                  const Icon(
                    Icons.person,
                    size: 100,
                    color: Color.fromARGB(157, 0, 0, 0),
                  ),
                  const SizedBox(height: 110),
                  //Create an account
                  const Text(
                    "Let's get you signed up",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  //Email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  //Password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Insert password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  //Confired Password textfield
                  MyTextField(
                    controller: confirmpasswordController,
                    hintText: 'Re-type password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  //Sign up button
                  MyButton(onTap: signUp, text: 'Sign Up'),
                  const SizedBox(height: 50),
                  //Already registere? Login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already registere?'),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            color: Color.fromARGB(225, 7, 29, 66),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
