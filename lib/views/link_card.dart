import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_clone/models/Link.dart';

class LinkCard extends StatelessWidget {
  const LinkCard({
    super.key,
    required this.urll,
  });

  final Link urll;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        context.pushNamed('editlink',params: {
          'name': urll.linkName,
          'url': urll.linkURL,
        });
      },
      contentPadding: const EdgeInsets.all(10),
      horizontalTitleGap: 0,
      tileColor: Colors.white,
      leading: const Icon(
          Icons.more_vert
      ),
      title: Text(
        urll.linkName,
        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        urll.linkURL,
        style: GoogleFonts.inter(),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
    );
  }
}