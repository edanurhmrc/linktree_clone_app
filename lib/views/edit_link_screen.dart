// ignore_for_file: use_build_context_synchronously


import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_clone/main.dart';
import 'package:linktree_clone/models/Link.dart';
import 'package:linktree_clone/models/Linktree.dart';

import 'add_link_screen.dart';

class EditLinkScreen extends StatefulWidget {
  Link url;
  EditLinkScreen({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<EditLinkScreen> createState() => _EditLinkScreenState();
}

class _EditLinkScreenState extends State<EditLinkScreen> {
  late String _email;
  bool isLoading = false;
  TextEditingController linkTitleController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  @override
  void initState() {
    linkTitleController.text = widget.url.linkName;
    linkController.text = widget.url.linkURL;
    super.initState();
    _getUserEmail();
  }

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Edit Link',
          style: GoogleFonts.inter(
              fontSize: 23, fontWeight: FontWeight.w700, color: Colors.black
          ),
        ),
        leading: IconButton(
            onPressed: (){
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87,)
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton.icon(
                  onPressed: ()async{
                    deleteLinkByName(widget.url.linkName);
                    context.go("/home");
                  },
                  icon: const Icon(Icons.delete, color: Colors.red,),
                  label: Text(
                    'Delete Link',
                    style: GoogleFonts.inter(
                        color: Colors.red
                    ),
                  )
              )
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinkTextField(controller: linkTitleController, hintText: 'Github Page',),
                    const SizedBox(height: 20,),
                    LinkTextField(controller: linkController, hintText: 'https://. . . '),
                    const SizedBox(height: 20,),
                    MaterialButton(
                      onPressed: isLoading ? null : ()async{
                        if (linkTitleController.text == "" || linkController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('All fields are required'),backgroundColor: Colors.red,));
                        }
                        else{
                          setState(() {
                            isLoading = true;
                          });
                          //Buraya update komutu eklenecek
                          updateLinkByName(widget.url.linkName, linkTitleController.text ,linkController.text);
                          setState(() {
                            isLoading = false;
                          });
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
                        'Edit Link',
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
          if(size >= 600)
            const VerticalDivider(),
        ],
      ),
    );

  }
  Future<void> deleteLinkByName(String name) async {
    try {
      // Linktree nesnesini oku
      final linkTree = await Amplify.DataStore.query(
          Linktree.classType,
          where: Linktree.ID.eq(_email)
      );

      if (linkTree.isEmpty) {
        print('No Linktree found with ID: $_email');
        return;
      }
      // JSON dizisini parçala ve istenen id numarasına sahip veriyi sil
      List<Map<String, dynamic>> links = (linkTree.first.link ?? [])
          .map((link) => json.decode(link))
          .cast<Map<String, dynamic>>()
          .toList();
      int indexToDelete = -1;
      for (int i = 0; i < links.length; i++) {
        if (links[i]['name'] == name) {
          indexToDelete = i;
          break;
        }
      }

      if (indexToDelete == -1) {
        print('No link found with Name: $name');
        return;
      }

      links.removeAt(indexToDelete);

      // Linktree nesnesini güncelle
      final updatedLinkTree = linkTree.first.copyWith(link: links.map((link) => json.encode(link)).toList());
      await Amplify.DataStore.save(updatedLinkTree);
      print('Link with Name $name deleted successfully');
    } catch (e) {
      print('Error deleting link: $e');
    }
  }

  Future<void> updateLinkByName(String name, String changename, String url) async {
    try {
      // Linktree nesnesini oku
      final linkTree = await Amplify.DataStore.query(
          Linktree.classType,
          where: Linktree.ID.eq(_email)
      );

      if (linkTree.isEmpty) {
        print('No Linktree found with Name: $_email');
        return;
      }
      // JSON dizisini parçala ve istenen isimdeki veriyi güncelle
      List<Map<String, dynamic>> links = (linkTree.first.link ?? [])
          .map((link) => json.decode(link))
          .cast<Map<String, dynamic>>()
          .toList();
      int indexToUpdate = -1;
      for (int i = 0; i < links.length; i++) {
        if (links[i]['name'] == name) {
          indexToUpdate = i;
          break;
        }
      }

      if (indexToUpdate == -1) {
        print('No link found with Name: $name');
        return;
      }

      links[indexToUpdate]['name'] = changename;
      links[indexToUpdate]['url'] = url;

      // Linktree nesnesini güncelle
      final updatedLinkTree = linkTree.first.copyWith(link: links.map((link) => json.encode(link)).toList());
      await Amplify.DataStore.save(updatedLinkTree);
      print('Link with Name $name updated successfully');
    } catch (e) {
      print('Error updating link: $e');
    }
  }
}