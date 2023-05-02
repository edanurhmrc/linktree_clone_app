// ignore_for_file: use_build_context_synchronously


import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_clone/main.dart';
import 'package:linktree_clone/views/auth/VerificationScreen.dart';
import 'package:linktree_clone/views/auth/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
///signup
Future<void> signUp(String email, String password) async {
  final userAttributes = [
    new AttributeArg(name: 'email', value: email),
  ];

  try {
    ///signup the user
    await userPool.signUp(email, password, userAttributes: userAttributes);
  } catch (e) {
    print('Failed to sign up user: $e');
  }
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool obscureText = true;
  bool showObscureIcon = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: 550
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create an account',
                            style: GoogleFonts.dmSans(
                                fontSize: 27, fontWeight: FontWeight.w800
                            ),
                          ),
                          const Opacity(
                            opacity: .7,
                            child: Text(
                              'Start by creating your account',
                            ),
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email address';
                              }
                              return null;
                            },
                            cursorColor: Colors.blue.shade700,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "E mail",
                              labelStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black.withOpacity(.5)
                              ),
                              floatingLabelStyle: TextStyle(color: Colors.blue.shade700),
                              filled: true,
                              fillColor: Colors.blue.shade100.withOpacity(.19),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue.shade700, width: 1.7)
                              ),

                            ),
                          ),
                          const SizedBox(height: 15,),
                          TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              if (value.length < 6) {
                                return 'Password should be at least 6 characters';
                              }
                              return null;
                            },
                            cursorColor: Colors.blue.shade700,
                            obscureText: obscureText,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              suffixIcon: showObscureIcon == true ? IconButton(
                                  onPressed: (){
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  icon: obscureText ?
                                  const Icon(Icons.visibility, color: Colors.grey,) :
                                  const Icon(Icons.visibility_off, color: Colors.grey,)
                              ) : null,
                              labelText: "Password",
                              labelStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black.withOpacity(.5)
                              ),
                              floatingLabelStyle: TextStyle(color: Colors.blue.shade700),
                              filled: true,
                              fillColor: Colors.blue.shade100.withOpacity(.19),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue.shade700, width: 1.7)
                              ),

                            ),
                          ),
                          const SizedBox(height: 15),
                          MaterialButton(
                            height: 50,
                            minWidth: double.infinity,
                            elevation: 0,
                            color: Colors.deepPurple,
                            disabledColor: Colors.black12,
                            disabledTextColor: Colors.black.withOpacity(.5),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await signUp(_emailController.text, _passwordController.text);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => VerificationScreen(email: _emailController.text)));
                                } catch (e) {
                                  print('Failed to sign up user: $e');
                                }
                              }
                            },
                            child: const Text(
                                'Sign up',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color:Colors.white)
                            ),
                          ),
                          const SizedBox(height: 15,),
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                context.go('/'); ///go to login page
                              },
                              child: RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Already have an account?",
                                          style: TextStyle(color: Colors.black.withOpacity(.5))
                                      ),
                                      const TextSpan(
                                          text: " Log in",
                                          style: TextStyle(fontWeight: FontWeight.w500, color:Colors.deepPurple)
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if(size >= 600)
            Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: const Image(image: AssetImage('assets/socials.jpg'),fit: BoxFit.cover,),
                )
            )
        ],
      ),
    );
  }
}