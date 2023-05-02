import 'dart:convert';
import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_clone/main.dart';
import 'package:linktree_clone/models/Link.dart';
import 'package:linktree_clone/views/link_card.dart';
import 'package:linktree_clone/views/preview_screen.dart';
import 'package:linktree_clone/models/Linktree.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _email = "";

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  ///get current user e mail from Cognito
  Future<void> _getUserEmail() async {
    try {
      final userAttributes = await userPool.getCurrentUser();
      final email = userAttributes?.username;
      setState(() {
        _email = email!;
      });
      print('User email: $_email');
      try {
        await downloadToLocalFile('profile-photo/${_email}-profilephoto');
      } catch (e) {
        print('Could not get profile photo : ${e}');
      }
    } on AuthException catch (e) {
      print('Could not get user email: ${e.message}');
    }
  }

  ///image is defined in file type
  File? image;

  Future<void> downloadToLocalFile(String key) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + '/${_email}-profile-photo';
    try {
      final result = await Amplify.Storage.downloadFile(
        key: key,
        localFile: AWSFile.fromPath(
            filepath), //specifies the path to the local file of the dowloaded file
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;

      final imageTemporary = File(filepath);
      setState(() => this.image = imageTemporary);

      safePrint('Downloaded file is located at: ${result.localFile.path}');
    } on StorageException catch (e) {
      safePrint(e.message);
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
          'Links',
          style: GoogleFonts.inter(
              fontSize: 23, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                context.pushNamed('profile');
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],

                ///get user pp from db if user has profile photo
                backgroundImage: image != null
                    ? FileImage(image!) as ImageProvider<Object>
                    : AssetImage("assets/user.png") as ImageProvider<Object>,
                //backgroundImage: NetworkImage(emoji),
              ),
            ),
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
                MaterialButton(
                  onPressed: () {
                    context.pushNamed('addlink');
                  },
                  color: Colors.deepPurple,
                  height: 60,
                  minWidth: double.infinity,
                  elevation: 0,
                  focusElevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'Add New Link',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                ///list of Link field get from Datastore
                Expanded(
                    child: FutureBuilder<Linktree?>(
                        future: Amplify.DataStore.query(Linktree.classType,
                                where: Linktree.ID.eq(_email))
                            .then(
                                (list) => list.isNotEmpty ? list.first : null),
                        builder: (BuildContext context,
                            AsyncSnapshot<Linktree?> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data?.link != null &&
                              snapshot.data?.link?.isNotEmpty == true) {
                            return ListView.separated(
                              itemBuilder: (context, index) {
                                dynamic response =
                                    jsonDecode(snapshot.data!.link![index]);
                                if (response is List) {
                                  return const Center(
                                    child: Text('No Links'),
                                  );
                                } else {
                                  Map<String, dynamic> map = response;
                                  Link link = Link(map['name'], map['url']);
                                  return LinkCard(urll: link);
                                }
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 18,
                                );
                              },
                              itemCount: snapshot.data!.link!.length,
                            );
                          } else {
                            return const Center(
                              child: Text('No Links'),
                            );
                          }
                        }))
              ],
            ),
          )),
          if (size >= 600) const VerticalDivider(),
        ],
      ),
      floatingActionButton: size < 600
          ? FloatingActionButton.extended(
              backgroundColor: Colors.grey.withOpacity(.6),
              elevation: 0,
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PreviewScreen(
                    backgroundurl: "background-picture/background-1-min",
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ));
              },
              label: const Text(
                'Preview',
              ),
              icon: const Icon(Icons.remove_red_eye_outlined),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
