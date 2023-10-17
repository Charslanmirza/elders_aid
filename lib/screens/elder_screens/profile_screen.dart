import 'package:elders_aid_project/widgets/constants.dart';
import 'package:elders_aid_project/widgets/rides_model.dart';
import 'package:elders_aid_project/widgets/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  static const String idScreen = "create";
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      fAuth.currentUser != null
          ? AssistantMethods.readCurrentOnlineUserInfo()
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfffD5DEEF),
        appBar: AppBar(
          backgroundColor: Color(0xff3E4685),
          title: Text(
            "Profile",
            style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //name
            Text(
              userModelCurrentInfo!.name!,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.black, fontSize: 50)),
            ),

            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                height: 2,
                thickness: 2,
              ),
            ),

            const SizedBox(
              height: 38.0,
            ),

            //phone
            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo!.phone!,
              iconData: Icons.phone_iphone,
            ),

            //email
            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo!.email!,
              iconData: Icons.email,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoDesignUIWidget extends StatefulWidget {
  String? textInfo;
  IconData? iconData;

  InfoDesignUIWidget({this.textInfo, this.iconData});

  @override
  State<InfoDesignUIWidget> createState() => _InfoDesignUIWidgetState();
}

class _InfoDesignUIWidgetState extends State<InfoDesignUIWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff3E4685),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.white,
        ),
        title: Text(
          widget.textInfo!,
          style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
