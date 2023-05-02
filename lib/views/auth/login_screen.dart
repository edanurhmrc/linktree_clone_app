import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_clone/main.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  bool showObscureIcon = true;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome back',
                            style: GoogleFonts.dmSans(
                                fontSize: 27, fontWeight: FontWeight.w800
                            ),
                          ),
                          const Opacity(
                            opacity: .7,
                            child: Text(
                              'Welcome back! Please enter your details.',
                            ),
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              return null;
                            },
                            cursorColor: Colors.blue.shade700,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: "Email",
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
                          const SizedBox(height: 15,),
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: (){
                                    context.push('/forgotpassword');
                                  },
                                  child: Text(
                                    'Forgot Password',
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                              )
                          ),
                          const SizedBox(height: 15),
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              :
                          MaterialButton(
                            height: 50,
                            minWidth: double.infinity,
                            elevation: 0,
                            focusElevation: 0,
                            color: Colors.deepPurple,
                            disabledColor: Colors.black12,
                            disabledTextColor: Colors.black.withOpacity(.5),
                            onPressed:  (){
                              _onLoginButtonPressed();
                            },
                            child: const Text(
                                'Log in',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color:Colors.white)
                            ),
                          ),
                          const SizedBox(height: 15,),
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: (){
                                context.push('/signup');
                              },
                              child: RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Don't have an account?",
                                          style: TextStyle(color: Colors.black.withOpacity(.5))
                                      ),
                                      const TextSpan(
                                          text: " Sign up",
                                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.deepPurple)
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

  Future<void> _onLoginButtonPressed() async {
    ///email textfield validate
    if ( _formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final cognitoUser = CognitoUser(
          _emailController.text.trim(),
          userPool,
        );
        ///Using the CognitoUser class, the Cognito user to be used for authentication is created.
        final authDetails = AuthenticationDetails(
          username: _emailController.text.trim(),
          password: _passwordController.text,
        );

        ///authenticate
        final session = await cognitoUser.authenticateUser(authDetails);

        setState(() {
          _isLoading = false;
        });
        context.go('/home');
      } on CognitoUserException catch (e) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Error'),
                content: Text(e.message!),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      } on CognitoClientException catch (e) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Error'),
                content: Text(e.message!),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }
}


