import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:linktree_clone/amplifyconfiguration.dart';
import 'package:linktree_clone/routes/app_routes.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'models/ModelProvider.dart';

final userPool = CognitoUserPool(
  '', // User Pool ID
  '', // Client ID
);

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final datastorePlugin = AmplifyDataStore(modelProvider: ModelProvider.instance);
      await Amplify.addPlugin(datastorePlugin);
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.addPlugin(AmplifyStorageS3());
      await Amplify.addPlugin(AmplifyAPI());
      await Amplify.configure(
        amplifyconfig,
      );
      print('Successfully configured Amplify.');
    } catch (e) {
      print('Could not configure Amplify: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{ return false;},
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routerConfig: AppRouter().router,    ),
    );
  }
}

