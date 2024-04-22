import 'package:flutter/material.dart';
import 'package:hayat_e_sahaba/drawer/theme_changer/theme_provider.dart';
import 'package:provider/provider.dart';

class AboutOwner extends StatefulWidget {
  const AboutOwner({super.key});

  @override
  State<AboutOwner> createState() => _AboutOwnerState();
}

class _AboutOwnerState extends State<AboutOwner> {
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChangerProvider>(context);
    bool isLightTheme = themeChanger.isLightTheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: const Color(0xffD0FCFF),
            boxShadow: [
              BoxShadow(
                  color: isLightTheme ? Colors.black45 : Colors.grey.shade300,
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 4)
              )
            ],
              image: const DecorationImage(
                image: AssetImage('assets/icons/background.png'),
                fit: BoxFit.fill,
                opacity: 1,)
          ),
        ),
        title: Text('Author',style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLightTheme ? Colors.black : Colors.black),),
      ),
      body: const Center(child: Text('Wahid Wazir')),
    );
  }
}
