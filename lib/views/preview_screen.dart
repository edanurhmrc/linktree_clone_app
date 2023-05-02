// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_clone/main.dart';
import 'package:linktree_clone/models/Profile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:linktree_clone/models/Link.dart';

import '../models/Linktree.dart';

class PreviewScreen extends StatefulWidget {
  final String backgroundurl;
  const PreviewScreen({Key? key, required this.backgroundurl})
      : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late String _email = "";
  late String _twitterurl = "twitter";
  late String _facebookurl = "facebook";
  late String _instagramurl = "instagram";
  late String _linkedinurl = "linkedin";
  File? image;
  File? background;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Preview",
          style: GoogleFonts.inter(
              fontSize: 23, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: background != null
                ? FileImage(background!) as ImageProvider<Object>
                : AssetImage("assets/default.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: FutureBuilder(
          future: _getProfileLink(_email),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          CircleAvatar(
                            radius: 30,
                            foregroundColor: Colors.grey[700],
                            backgroundImage: image != null
                                ? FileImage(image!) as ImageProvider<Object>
                                : AssetImage("assets/user.png")
                                    as ImageProvider<Object>,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (_twitterurl != '' ||
                                    _twitterurl != 'twitter')
                                  sociallogo(
                                      'assets/twitter2.svg', _twitterurl),
                                if (_email != '')
                                  emaillogo('assets/mail2.svg', _email),
                                if (_facebookurl != '' ||
                                    _facebookurl != 'facebook')
                                  sociallogo(
                                      'assets/facebook2.svg', _facebookurl),
                                if (_instagramurl != '' ||
                                    _instagramurl != 'instagram')
                                  sociallogo(
                                      'assets/instagram2.svg', _instagramurl),
                                if (_linkedinurl != '' ||
                                    _linkedinurl != 'linkedin')
                                  sociallogo(
                                      'assets/linkedin2.svg', _linkedinurl),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          FutureBuilder<Linktree?>(
                            future: Amplify.DataStore.query(Linktree.classType,
                                    where: Linktree.ID.eq(_email))
                                .then((list) =>
                                    list.isNotEmpty ? list.first : null),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data != null &&
                                    snapshot.data?.link != null &&
                                    snapshot.data?.link?.isNotEmpty == true) {
                                  return ListView.separated(
                                    primary: true,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.link!.length,
                                    itemBuilder: (context, index) {
                                      dynamic response = jsonDecode(
                                          snapshot.data!.link![index]);
                                      Map<String, dynamic> map = response;
                                      Link url = Link(map['name'], map['url']);
                                      return InkWell(
                                        onTap: () async {
                                          final link = Uri.parse(url.linkURL);
                                          if (await canLaunchUrl(link)) {
                                            //await launchUrl(link);
                                            launch(url.linkURL,
                                                forceSafariVC: true);
                                          } else {
                                            throw Exception(
                                                'Could not launch $link');
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              url.linkName,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 15,
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: Text(
                                      'no links',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }
                              }
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 420,
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

  Future<void> downloadToLocalFile(String key) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + '/${_email}-profile-photo';
    try {
      final result = await Amplify.Storage.downloadFile(
        key: key,
        localFile: AWSFile.fromPath(filepath),
        onProgress: (progress) {
          safePrint(
              'Fraction completed profile-photo: ${progress.fractionCompleted}');
        },
      ).result;

      final imageTemporary = File(filepath);
      setState(() => this.image = imageTemporary);

      safePrint('Downloaded file is located at: ${result.localFile.path}');
    } on StorageException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> downloadToLocalBackground(String key) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + '/${_email}-background';

    print('Key anahtarı : $key');
    try {
      final result = await Amplify.Storage.downloadFile(
        key: key,
        localFile: AWSFile.fromPath(filepath),
        onProgress: (progress) {
          safePrint(
              'Fraction completed background: ${progress.fractionCompleted}');
        },
      ).result;

      final imageTemporary = File(filepath);
      setState(() => this.background = imageTemporary);

      safePrint('Downloaded file is located at: ${result.localFile.path}');
    } on StorageException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> _getProfileLink(email) async {
    try {
      final profile = await Amplify.DataStore.query(Profile.classType,
          where: Profile.ID.eq(email));
      print('email bu: $email');
      if (profile.isEmpty) {
        print('No Profile found with Name: $email');
        return;
      }
      try {
        await downloadToLocalFile('profile-photo/${_email}-profilephoto');
      } catch (e) {
        print('Could not get profile photo : ${e}');
      }
      try {
        await downloadToLocalBackground(widget.backgroundurl);
      } catch (e) {
        print('Could not get profile photo : ${e}');
      }

      setState(() {
        _twitterurl = profile.first.twitter ?? "twitter";
        _facebookurl = profile.first.facebook ?? "facebook";
        _instagramurl = profile.first.instagram ?? "instagram";
        _linkedinurl = profile.first.linkedin ?? "linkedin";
      });
    } catch (e) {
      print('Could not get user email: ${e}');
    }
  }

  InkWell sociallogo(svg, url) {
    return InkWell(
      onTap: () async {
        final link = Uri.parse(url);
        if (await canLaunchUrl(link)) {
          launch(url, forceSafariVC: true);
        } else {
          throw Exception('Could not launch $link');
        }
      },
      child: SvgPicture.asset(
        svg,
        height: 30,
        color: Colors.white,
      ),
    );
  }

  InkWell emaillogo(svg, path) {
    return InkWell(
      onTap: () async {
        String? encodeQueryParameters(Map<String, String> params) {
          return params.entries
              .map((MapEntry<String, String> e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
              .join('&');
        }

        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: path,
          query: encodeQueryParameters(<String, String>{
            'subject': 'Example Subject & Symbols are allowed!',
          }),
        );

        if (await canLaunchUrl(emailLaunchUri)) {
          launch(emailLaunchUri.toString());
        } else {
          throw Exception('Not supported');
        }
      },
      child: SvgPicture.asset(
        svg,
        height: 30,
        color: Colors.white,
      ),
    );
  }
}
