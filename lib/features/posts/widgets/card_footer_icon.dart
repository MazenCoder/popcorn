import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';



class CardFooterIcon extends StatelessWidget {
  final Icon icon;
  final String text;
  final VoidCallback onTap;
  const CardFooterIcon({Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          Text(text,
            style: GoogleFonts.notoSans(
                fontSize: 11
            ),
          )
        ],
      ),
    );
  }
}
