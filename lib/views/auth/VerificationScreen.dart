import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linktree_clone/main.dart';
import 'package:linktree_clone/views/auth/signup_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  VerificationScreen({required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

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
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
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
                  child: ConstrainedBox(constraints: const BoxConstraints(
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
                              'Verification Email',
                              style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600,color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              'Please enter the verification code sent to ${widget.email}',
                            ),
                            const SizedBox(height: 30,),
                            TextFormField(
                              controller: _codeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter verification code';
                                }
                                return null;
                              },
                              cursorColor: Colors.blue.shade700,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: "Enter verification code",
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
                            MaterialButton(
                              height: 50,
                              minWidth: double.infinity,
                              elevation: 0,
                              focusElevation: 0,
                              color: Colors.deepPurple,
                              disabledColor: Colors.black12,
                              disabledTextColor: Colors.black.withOpacity(.5),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final cognitoUser = CognitoUser(widget.email, userPool);
                                    await cognitoUser.confirmRegistration(_codeController.text);
                                    /// navigate to home screen
                                    context.go('/home');
                                  } catch (e) {
                                    print('Failed to confirm sign up: $e');
                                  }
                                }
                              },
                              child: const Text(
                                  'Submit',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color:Colors.white)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}