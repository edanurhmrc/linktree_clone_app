// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_clone/main.dart';
import 'package:linktree_clone/views/home_screen.dart';
import 'package:linktree_clone/models/Linktree.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

import '../models/Link.dart';

class AddLinkScreen extends StatefulWidget {
  AddLinkScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddLinkScreen> createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends State<AddLinkScreen> {
  late String _email = "";
  List<String> list = [];

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  /// get current user's email from db
  Future<void> _getUserEmail() async {
    try {
      final userAttributes = await userPool.getCurrentUser();
      final email = userAttributes?.username;
      setState(() {
        _email = email!;
      });
      print('User email: $_email');
    } on AuthException catch (e) {
      print('Could not get user email: ${e.message}');
    }
  }

  bool isLoading = false;
  TextEditingController linkTitleController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    linkTitleController.dispose();
    linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Add Link',
          style: GoogleFonts.inter(
              fontSize: 23, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
            )),
      ),
      body: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinkTextField(
                  controller: linkTitleController,
                  hintText: 'Github Page',
                ),
                const SizedBox(
                  height: 20,
                ),
                LinkTextField(
                    controller: linkController, hintText: 'https://. . . '),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    if (linkTitleController.text == "" ||
                        linkController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('All fields are required'),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      create();
                      context.go("/home");
                    }
                  },
                  color: Colors.black87,
                  disabledColor: Colors.grey.withOpacity(.5),
                  disabledTextColor: Colors.black.withOpacity(.5),
                  height: 60,
                  minWidth: double.infinity,
                  elevation: 0,
                  focusElevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Add New Link',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          )),
          if (size >= 600) const VerticalDivider(),
        ],
      ),
    );
  }

  void create() async {
    Link link = Link(linkTitleController.text, linkController.text);
    Map<String, dynamic> map = {'name': link.linkName, 'url': link.linkURL};
    final rawJson = jsonEncode(map);
    final linkTree = await readById();
    linkTree?.forEach((e) {
      Map<String, dynamic> map = {'name': e.linkName, 'url': e.linkURL};
      final rawJson = jsonEncode(map);
      list.add(rawJson);
    });
    list.add(rawJson);
    final user = Linktree(email: _email, id: _email, link: list);

    try {
      await Amplify.DataStore.save(user);
      print("Saved");
    } catch (e) {
      print(e);
    }
  }

  void readAll() async {}
  Future<List<Link>?> readById() async {
    try {
      final linkTrees = await Amplify.DataStore.query(Linktree.classType,
          where: Linktree.ID.eq(_email));
      if (linkTrees.isEmpty) {
        print("No objects with ID: $_email");
        return [];
      }

      final linkTree = linkTrees.first.link?.map((rawJson) {
        final map = jsonDecode(rawJson) as Map<String, dynamic>;
        return Link(map['name'], map['url']);
      }).toList();
      return linkTree;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void update() async {}
  void delete() async {}
}

class LinkTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  LinkTextField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      decoration: InputDecoration(
        hoverColor: Colors.white,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
