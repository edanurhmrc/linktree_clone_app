// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_clone/main.dart';
import 'package:linktree_clone/models/Linktree.dart';
import 'package:linktree_clone/models/Profile.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:file_picker/file_picker.dart';
import 'package:linktree_clone/views/preview_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'auth/ResetPasswordPage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _email = "";
  late String _twitterurl = "twitter";
  late String _facebookurl = "facebook";
  late String _instagramurl = "instagram";
  late String _linkedinurl = "linkedin";
  late String _customurl = "linktree.ee/";

  bool showTrailing = true;

  TextEditingController titleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    emailController.dispose();
  }

  String email = "";

  @override
  void initState() {
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
      await _getProfileLink(email);
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

  Future<void> _getProfileLink(email) async {
    try {
      final profile = await Amplify.DataStore.query(Profile.classType,
          where: Profile.ID.eq(email));
      print('email bu: $email');
      if (profile.isEmpty) {
        print('No Profile found with Name: $email');
        return;
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

  File? image;

  Future<void> downloadToLocalFile(String key) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + '/${_email}-profile-photo';
    try {
      final result = await Amplify.Storage.downloadFile(
        key: key,
        localFile: AWSFile.fromPath(filepath),
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

  Future<void> uploadImage() async {
    // Select a file from the device
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: false,
      // Ensure to get file stream for better performance
      withReadStream: true,
      allowedExtensions: ['jpg', 'png', 'gif'],
    );
    if (result == null) {
      safePrint('No file selected');
      return;
    }
    //Upload file with its filename as the key
    final platformFile = result.files.single;
    try {
      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(
          platformFile.readStream!,
          size: platformFile.size,
        ),
        key: 'profile-photo/${_email}-profilephoto',
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;
      safePrint('Successfully uploaded file: ${result.uploadedItem.key}');
      await downloadToLocalFile('profile-photo/${_email}-profilephoto');
    } on StorageException catch (e) {
      safePrint('Error uploading file: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = _email;
    String twitter = _twitterurl;
    String instagram = _instagramurl;
    String facebook = _facebookurl;
    String linkedin = _linkedinurl;
    if (_email.isNotEmpty) {
      String username = _email.substring(0, _email.indexOf("@"));
      setState(() {
        _customurl = 'linktree.ee/$username';
      });
    }
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
              fontSize: 23, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              context.go("/home");
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
            )),
      ),
      body: Row(
        children: [
          Expanded(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: image != null
                            ? FileImage(image!) as ImageProvider<Object>
                            : AssetImage("assets/user.png")
                                as ImageProvider<Object>,
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: TextButton(
                              onPressed: () => uploadImage(),
                              child: Text(
                                'Change Picture',
                                style: GoogleFonts.inter(
                                    color: Colors.blue.shade600,
                                    fontWeight: FontWeight.w600),
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Transform.rotate(
                                      angle:
                                          135 * (3.14159265358979323846 / 180),
                                      child: const Icon(
                                        Icons.link,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Expanded(
                                        child: Text(
                                      _customurl,
                                      //'linktree.ee/$username',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    )),
                                    TextButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: _customurl))
                                              .then((value) => ScaffoldMessenger
                                                      .of(context)
                                                  .showSnackBar(snackBar(
                                                      'Url is copied to the clipboard',
                                                      context,
                                                      Colors.green)));
                                        },
                                        child: Text(
                                          'Copy',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue.shade600),
                                        ))
                                  ],
                                ),
                              ),
                              ExpansionTile(
                                title: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.purple.shade100
                                          .withOpacity(.7),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      'Social Icons',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                ),
                                children: [
                                  ListTile(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("E mail adress"),
                                              content: TextField(
                                                controller: emailController,
                                                decoration: InputDecoration(
                                                  hintText: 'example@gmail.com',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {},
                                                    child: const Text('SUBMIT'))
                                              ],
                                            );
                                          });
                                    },
                                    contentPadding: const EdgeInsets.all(0),
                                    horizontalTitleGap: 0,
                                    leading: SvgPicture.asset(
                                      'assets/mail2.svg',
                                      height: 30,
                                    ),
                                    title: Text(
                                      'Email',
                                      style: GoogleFonts.inter(),
                                    ),
                                    subtitle: Text(
                                      email,
                                      style: GoogleFonts.inter(),
                                    ),
                                    trailing: null,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Facebook"),
                                              content: TextField(
                                                controller: facebookController,
                                                onTap: () {},
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      'https://facebook. . .',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      updateFacebook(
                                                          facebookController
                                                              .text);
                                                      context
                                                          .pushNamed('profile');
                                                    },
                                                    child: const Text('SUBMIT'))
                                              ],
                                            );
                                          });
                                    },
                                    contentPadding: const EdgeInsets.all(0),
                                    horizontalTitleGap: 0,
                                    leading: SvgPicture.asset(
                                      'assets/facebook2.svg',
                                      height: 30,
                                    ),
                                    title: Text(
                                      'Facebook',
                                      style: GoogleFonts.inter(),
                                    ),
                                    subtitle: Text(
                                      facebook,
                                      style: GoogleFonts.inter(),
                                    ),
                                    trailing: showTrailing == true
                                        ? const Icon(
                                            Icons.edit,
                                            size: 18,
                                          )
                                        : null,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Instagram"),
                                              content: TextField(
                                                controller: instagramController,
                                                onTap: () {},
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      'https://instagram. . .',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      updateInstagram(
                                                          instagramController
                                                              .text);
                                                      context
                                                          .pushNamed('profile');
                                                    },
                                                    child: const Text('SUBMIT'))
                                              ],
                                            );
                                          });
                                    },
                                    contentPadding: const EdgeInsets.all(0),
                                    horizontalTitleGap: 0,
                                    leading: SvgPicture.asset(
                                      'assets/instagram2.svg',
                                      height: 30,
                                    ),
                                    title: Text(
                                      'Instagram',
                                      style: GoogleFonts.inter(),
                                    ),
                                    subtitle: Text(
                                      instagram,
                                      style: GoogleFonts.inter(),
                                    ),
                                    trailing: showTrailing == true
                                        ? const Icon(
                                            Icons.edit,
                                            size: 18,
                                          )
                                        : null,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Twitter"),
                                              content: TextField(
                                                controller: twitterController,
                                                onTap: () {},
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      'https://twitter. . .',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      updateTwitter(
                                                          twitterController
                                                              .text);
                                                      context
                                                          .pushNamed('profile');
                                                    },
                                                    child: const Text('SUBMIT'))
                                              ],
                                            );
                                          });
                                    },
                                    contentPadding: const EdgeInsets.all(0),
                                    horizontalTitleGap: 0,
                                    leading: SvgPicture.asset(
                                      'assets/twitter2.svg',
                                      height: 30,
                                    ),
                                    title: Text(
                                      'Twitter',
                                      style: GoogleFonts.inter(),
                                    ),
                                    subtitle: Text(
                                      twitter,
                                      style: GoogleFonts.inter(),
                                    ),
                                    trailing: showTrailing == true
                                        ? const Icon(
                                            Icons.edit,
                                            size: 18,
                                          )
                                        : null,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Linkedin"),
                                              content: TextField(
                                                controller: linkedinController,
                                                onTap: () {},
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'https://linkedIn. . .',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      updateLinkedin(
                                                          linkedinController
                                                              .text);
                                                      context
                                                          .pushNamed('profile');
                                                    },
                                                    child: const Text('SUBMIT'))
                                              ],
                                            );
                                          });
                                    },
                                    contentPadding: const EdgeInsets.all(0),
                                    horizontalTitleGap: 0,
                                    leading: SvgPicture.asset(
                                      'assets/linkedin2.svg',
                                      height: 30,
                                    ),
                                    title: Text(
                                      'linkedin',
                                      style: GoogleFonts.inter(),
                                    ),
                                    subtitle: Text(
                                      linkedin,
                                      style: GoogleFonts.inter(),
                                    ),
                                    trailing: showTrailing == true
                                        ? const Icon(
                                            Icons.edit,
                                            size: 18,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.purple.shade100
                                          .withOpacity(.7),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      'Background options',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                ),
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PreviewScreen(
                                                    backgroundurl:
                                                        "background-picture/background-2-min",
                                                  )));
                                    },
                                    contentPadding: const EdgeInsets.all(0),
                                    horizontalTitleGap: 0,
                                    leading: Icon(
                                      Icons.wb_cloudy,
                                      size: 26,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    title: Text(
                                      'Spring',
                                      style: GoogleFonts.inter(),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PreviewScreen(
                                                    backgroundurl:
                                                        "background-picture/background-3-min",
                                                  )));
                                    },
                                    contentPadding: const EdgeInsets.all(0),
                                    horizontalTitleGap: 0,
                                    leading: Icon(
                                      Icons.sunny,
                                      size: 26,
                                      color: CupertinoColors.systemYellow,
                                    ),
                                    title: Text(
                                      'Summer',
                                      style: GoogleFonts.inter(),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PreviewScreen(
                                                    backgroundurl:
                                                        "background-picture/background-1-min",
                                                  )));
                                    },
                                    contentPadding: const EdgeInsets.all(0),
                                    horizontalTitleGap: 0,
                                    leading: Icon(
                                      Icons.ac_unit,
                                      size: 26,
                                      color: Colors.grey,
                                    ),
                                    title: Text(
                                      'Winter',
                                      style: GoogleFonts.inter(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ListTile(
                                onTap: () async {
                                  try {
                                    final cognitoUser =
                                        CognitoUser(_email, userPool);
                                    await cognitoUser.forgotPassword();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResetPasswordPage(
                                            user: cognitoUser),
                                      ),
                                    );
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                leading: Icon(
                                  Icons.key,
                                  color: Colors.black87,
                                  size: 22,
                                ),
                                title: Text(
                                  "Reset Password",
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text("Forgot your password? Reset."),
                                horizontalTitleGap: 0,
                                contentPadding: const EdgeInsets.all(0),
                              ),
                              ListTile(
                                onTap: () async {
                                  await Amplify.Auth.signOut();
                                  context.go('/');

                                  /// go to login page
                                },
                                leading: Icon(
                                  Icons.logout,
                                  color: Colors.red.shade500,
                                  size: 22,
                                ),
                                title: Text(
                                  "Logout",
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(" "),
                                horizontalTitleGap: 0,
                                contentPadding: const EdgeInsets.all(0),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          )),
          if (size >= 600) const VerticalDivider(),
        ],
      ),
    );
  }

  Future<void> updateTwitter(String url) async {
    try {
      final profile = await Amplify.DataStore.query(Profile.classType,
          where: Profile.ID.eq(_email));

      if (profile.isEmpty) {
        print('No Profile found with Name: $_email');
        Profile profil = Profile(id: _email, twitter: url);
        await Amplify.DataStore.save(profil);
        print('Link twitter updated successfully');
        await updateLink();
      }
      Profile profil = Profile(
          id: _email,
          twitter: url,
          facebook: profile.first.facebook,
          instagram: profile.first.instagram,
          linkedin: profile.first.linkedin);
      await Amplify.DataStore.save(profil);
      print('Link twitter updated successfully');
      await updateLink();
    } catch (e) {
      print('Error updating link: $e');
    }
  }

  Future<void> updateFacebook(String url) async {
    try {
      final profile = await Amplify.DataStore.query(Profile.classType,
          where: Profile.ID.eq(_email));

      if (profile.isEmpty) {
        print('No Profile found with Name: $_email');
        Profile profil = Profile(id: _email, facebook: url);
        await Amplify.DataStore.save(profil);
        print('Link facebook updated successfully');
        await updateLink();
      }

      Profile profil = Profile(
          id: _email,
          linkedin: profile.first.linkedin,
          facebook: url,
          instagram: profile.first.instagram,
          twitter: profile.first.twitter);
      await Amplify.DataStore.save(profil);
      print('Link facebook updated successfully');
      await updateLink();
    } catch (e) {
      print('Error updating link: $e');
    }
  }

  Future<void> updateInstagram(String url) async {
    try {
      final profile = await Amplify.DataStore.query(Profile.classType,
          where: Profile.ID.eq(_email));

      if (profile.isEmpty) {
        print('No Profile found with Name: $_email');
        Profile profil = Profile(id: _email, instagram: url);
        await Amplify.DataStore.save(profil);
        print('Link instagram updated successfully');
        await updateLink();
      }

      Profile profil = Profile(
          id: _email,
          linkedin: profile.first.linkedin,
          facebook: profile.first.facebook,
          instagram: url,
          twitter: profile.first.twitter);
      await Amplify.DataStore.save(profil);
      print('Link instagram updated successfully');
      await updateLink();
    } catch (e) {
      print('Error updating link: $e');
    }
  }

  Future<void> updateLinkedin(String url) async {
    try {
      final profile = await Amplify.DataStore.query(Profile.classType,
          where: Profile.ID.eq(_email));

      if (profile.isEmpty) {
        print('No Profile found with Name: $_email');
        Profile profil = Profile(id: _email, linkedin: url);
        await Amplify.DataStore.save(profil);
        print('Link linkedin updated successfully');
        await updateLink();
      }

      Profile profil = Profile(
          id: _email,
          linkedin: url,
          facebook: profile.first.facebook,
          instagram: profile.first.instagram,
          twitter: profile.first.twitter);
      await Amplify.DataStore.save(profil);
      print('Link linkedin updated successfully');
      await updateLink();
    } catch (e) {
      print('Error updating link: $e');
    }
  }

  Future<void> updateLink() async {
    try {
      // Linktree nesnesini oku
      final linkTree = await Amplify.DataStore.query(Linktree.classType,
          where: Linktree.ID.eq(_email));

      if (linkTree.isEmpty) {
        print('No Linktree found with Name: $_email');
        return;
      }

      final updatedLinkTree = linkTree.first.copyWith(linktreeProfilId: _email);
      await Amplify.DataStore.save(updatedLinkTree);
      print('Link with ID Linktree updated successfully');
    } catch (e) {
      print('Error updating link: $e');
    }
  }

  Text textFieldTitle(title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
    );
  }

  snackBar(String content, BuildContext context, Color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content), backgroundColor: Color));
  }
}
