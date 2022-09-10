import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_app/constnats/strings.dart';
import '../../business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import '../../constnats/my_colors.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  Widget buildDrawerHeader(context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
          decoration:
              BoxDecoration(shape: BoxShape.rectangle, color: Colors.blue[100]),
          child: Image.asset(
            "assets/images/msa.jpg",
            fit: BoxFit.cover,
          ),
        ),
        const Text(
          'mohimadba',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        BlocProvider<PhoneAuthCubit>(
          create: (context) {
            return phoneAuthCubit;
          },
          child: Text(
            '${phoneAuthCubit.getLoggedInUser().phoneNumber}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDrawerListItem(
      {required IconData leadingIcon,
      required String title,
      Widget? trailing,
      Function()? onTap,
      Color? color}) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: color ?? MyColors.blue,
      ),
      title: Text(title),
      trailing: trailing ??= const Icon(
        Icons.arrow_right,
        color: MyColors.blue,
      ),
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemsDivider() {
    return const Divider(
      height: 0,
      thickness: 1,
      endIndent: 24,
      indent: 18,
    );
  }

//final Uri _url = Uri.parse('https://flutter.dev');

  void _launchURL(String uri) async {
    final Uri url = Uri.parse(uri);
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not launch $url';
  }

  Widget buildIcon(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Icon(
        icon,
        color: MyColors.blue,
        size: 35,
      ),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0.0, 0.0, 16.0),
      child: Row(
        children: [
          buildIcon(
            FontAwesomeIcons.facebook,
            'https://www.facebook.com/m.s.a.oma',
          ),
          const SizedBox(
            width: 15,
          ),
          buildIcon(
            FontAwesomeIcons.youtube,
            'https://www.youtube.com/watch?v=3oBN3kL3iDs',
          ),
          const SizedBox(
            width: 20,
          ),
          buildIcon(
            FontAwesomeIcons.telegram,
            'https://t.me/OmarX14',
          ),
        ],
      ),
    );
  }

  Widget buildLogoutBlocProvider(context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: BlocProvider<PhoneAuthCubit>(
        create: (context) => phoneAuthCubit,
        child: buildDrawerListItem(
          leadingIcon: Icons.logout,
          title: 'Logout',
          onTap: () async {
            await phoneAuthCubit.logOut();
            Navigator.of(context).pushReplacementNamed(loginScreen);
          },
          color: Colors.red,
          trailing: const SizedBox(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
              height: 270,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue[100]),
                child: buildDrawerHeader(context),
              )),
          buildDrawerListItem(leadingIcon: Icons.person, title: 'My Profile'),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.history,
            title: 'Places History',
            onTap: () {},
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(leadingIcon: Icons.settings, title: 'Settings'),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(leadingIcon: Icons.help, title: 'Help'),
          buildDrawerListItemsDivider(),
          buildLogoutBlocProvider(context),
          const SizedBox(
            height: 100,
          ),
          ListTile(
            leading: Text(
              'Follow us :',
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }
}
