import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercandidateinterviewapp/widget/screens/userimagepicker.dart';

final _firbaseAuth = FirebaseAuth.instance;

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login_Screen> {
  final formKey = GlobalKey<FormState>();

  var isLoggedIn = true;
  var emailState = '';
  var passwordState = '';

  void _submit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    try {
      if (isLoggedIn) {
        final userCredentials = await _firbaseAuth.signInWithEmailAndPassword(
          email: emailState,
          password: passwordState,
        );
        print('Logged in:: $userCredentials');
      } else {
        final userCredentials = await _firbaseAuth
            .createUserWithEmailAndPassword(
              email: emailState,
              password: passwordState,
            );
        print('SignUp in:: $userCredentials');
      }
    } on FirebaseAuthException catch (errorException) {
      if (errorException.code == 'email alreayd in use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorException.message ?? 'Authentication failed !'),
        ),
      );
    }
    print(emailState);
    print(passwordState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                color: Colors.amberAccent,
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isLoggedIn) UserImagepicker(),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (updatedEmail) => {
                            emailState = updatedEmail!,
                          },
                          textCapitalization: TextCapitalization.none,
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          onSaved: (updatedPassword) => {
                            passwordState = updatedPassword!,
                          },
                          validator: (value) {
                            if (value == null || value.trim().length < 3) {
                              return 'Password must be atleast 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [userSignUpButton(), userLoginTextButton()],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget userEmailInputField() {
  //   return TextFormField(
  //     decoration: InputDecoration(labelText: 'Email'),
  //     keyboardType: TextInputType.emailAddress,
  //     textInputAction: TextInputAction.next,
  //     autocorrect: false,
  //     onSaved: (newValue) => {},
  //     textCapitalization: TextCapitalization.none,
  //   );
  // }

  // Widget userPasswordInputTextField() {
  //   return TextFormField(
  //     decoration: InputDecoration(labelText: 'Password'),
  //     obscureText: true,
  //   );
  // }

  Widget userSignUpButton() {
    return MaterialButton(
      onPressed: () => {
        setState(() {
          isLoggedIn = !isLoggedIn;
        }),
      },
      textColor: Theme.of(context).colorScheme.primary,
      color: Colors.deepPurple.shade200,
      child: Text(
        isLoggedIn ? 'Create an Account' : 'I already have an account',
      ),
    );
  }

  Widget userLoginTextButton() {
    return TextButton(
      onPressed: _submit,
      child: Text(
        isLoggedIn ? 'Login' : 'Sign up',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
