import 'package:flutter/material.dart';
import 'package:hayat_e_sahaba/drawer/Settings/download.dart';
import 'package:hayat_e_sahaba/drawer/Settings/favourites.dart';
import 'package:hayat_e_sahaba/drawer/theme_changer/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChangerProvider>(context);
    bool isLightTheme = themeChanger.isLightTheme;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: const Color(0xffD0FCFF),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                  color: isLightTheme ? Colors.black45 : Colors.grey.shade500,
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
        title: Text('Settings',
          style: TextStyle(fontWeight: FontWeight.w500,color: isLightTheme ? Colors.black : Colors.black),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.settings,size: 25,color: isLightTheme ? Colors.black : Colors.black),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 20,),
                  Image.asset('assets/icons/favourite.png',scale: 4,
                  color: isLightTheme ? Colors.black : Colors.white,),
                  const SizedBox(width: 20,),
                  const Text('Favourite',
                    style: TextStyle(fontSize: 18),),
                ],
              ),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const FavouritePage()));
            },
          ),
          const SizedBox(height: 10,),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 20,),
                  Image.asset('assets/icons/downloadPDF.png',scale: 4,
                    color: isLightTheme ? Colors.black : Colors.white,),
                  const SizedBox(width: 20,),
                  const Text('Download PDF',
                    style: TextStyle(fontSize: 18),),
                ],
              ),
            ),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> const DownloadPage()));
            },
          ),
        ],
      ),
    );
  }
}
