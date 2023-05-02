import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linktree_clone/views/auth/login_screen.dart';

class ResetPasswordPage extends StatefulWidget {
  final CognitoUser user;

  ResetPasswordPage({required this.user});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  final _formKey = GlobalKey<FormState>();
  final _newPassword = TextEditingController();
  final _codeController = TextEditingController();
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
                        children: [
                          const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600,color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          const Text(
                            'Please enter your new password and the code sent to your e-mail.',
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _newPassword,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            cursorColor: Colors.blue.shade700,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "Enter your password",
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
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _codeController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your code';
                              }
                              return null;
                            },
                            cursorColor: Colors.blue.shade700,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "Enter your code",
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
                          const SizedBox(height: 20,),
                          MaterialButton(height: 50, minWidth: double.infinity, elevation: 0, focusElevation: 0, color: Colors.deepPurple, disabledColor: Colors.black12, disabledTextColor: Colors.black.withOpacity(.5),
                            onPressed:
                              _isLoading ? null : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  bool passwordConfirmed = false;
                                  print(passwordConfirmed);
                                  try {
                                    passwordConfirmed = await widget.user.confirmPassword(
                                        _codeController.text, _newPassword.text);
                                    print(passwordConfirmed);
                                    context.go('/home');
                                  } catch (e) {
                                    print(e);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text('Failed to reset password. Please try again.'),
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
                            child: const Text(
                                'Reset Password',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color:Colors.white)
                            ),
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