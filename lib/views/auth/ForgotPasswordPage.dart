import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:linktree_clone/views/auth/ResetPasswordPage.dart';
import 'package:linktree_clone/views/auth/login_screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  final CognitoUserPool userPool;

  ForgotPasswordPage({required this.userPool});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}


class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87,)
        ),
      ),
      body: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: 550
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 10,),
                          const Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600,color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          const Text(
                            'Please enter your e-mail.',
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.blue.shade700,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: "Enter your email",
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },

                          ),
                          SizedBox(height: 16.0),
                          MaterialButton(
                            height: 50,
                            minWidth: double.infinity,
                            elevation: 0,
                            focusElevation: 0,
                            color: Colors.deepPurple,
                            disabledColor: Colors.black12,
                            disabledTextColor: Colors.black.withOpacity(.5),
                            child: _isLoading
                                ? SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text('Send Code', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color:Colors.white)
                            ),
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      try {
                                        final cognitoUser = CognitoUser(
                                            _emailController.text.trim(),
                                            widget.userPool);
                                        await cognitoUser.forgotPassword();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ResetPasswordPage(user: cognitoUser),
                                          ),
                                        );
                                      } catch (e) {
                                        print(e);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Error'),
                                              content: Text(
                                                  'Failed to send reset code. Please try again.'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      } finally {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
