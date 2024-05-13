import 'package:flutter/material.dart';
import 'package:hayat_e_sahaba/drawer/About/about_app.dart';
import 'package:hayat_e_sahaba/drawer/Settings/settingUi.dart';
import 'package:hayat_e_sahaba/drawer/theme_changer/theme_provider.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';


class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

  final nowDate = DateFormat('MMMM d, yyyy').format(DateTime.now());
  final nowDay = DateFormat('EEEE').format(DateTime.now());

  final InAppReview inAppReview = InAppReview.instance;


  void _launchURL() async {
    final url = Uri.parse('https://privacypolicy09876.blogspot.com/2024/04/privacy-policy.html');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void showCenteredSnackBar(BuildContext context, String message) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(message,
            style: const TextStyle(color: Colors.white,fontSize: 15),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }


  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChangerProvider>(context);
    bool isLightTheme = themeChanger.isLightTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(nowDate.toString(),
              style: const TextStyle(fontSize: 27,fontWeight: FontWeight.w400),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(nowDay,
                style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showCenteredSnackBar(context, 'Premium not available yet');
                },
                child: Container(
                  height: 43,
                  width: 273,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xffD0FCFF),
                    boxShadow: [
                      BoxShadow(
                          color: isLightTheme ? Colors.black45 : Colors.grey.shade500,
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: const Offset(0, 4)
                      ),
                    ],
                      image: const DecorationImage(
                        image: AssetImage('assets/icons/background.png'),
                        fit: BoxFit.fill,
                        opacity: 1,)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/Premium.png',scale: 3.8,),
                      const SizedBox(width: 10,),
                      Text('Premium',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isLightTheme ? Colors.black : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
             Divider(indent: 10,endIndent: 10,thickness: 0.8,height: 3,color: isLightTheme ? Colors.black : Colors.white,),
             Divider(indent: 10,endIndent: 10,thickness: 0.8,height: 3,color: isLightTheme ? Colors.black : Colors.white,),
            const SizedBox(height: 10),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0,left: 15.0,bottom: 7.0),
                child: Row(
                  children: [
                    isLightTheme
                        ? const Icon(Icons.brightness_2)
                        : const Icon(Icons.brightness_7),
                    const SizedBox(width: 20,),
                    const Text('Theme',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              onTap: (){
                setState(() {
                  themeChanger.setTheme(isLightTheme ? ThemeMode.dark : ThemeMode.light);
                });
              },
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0,left: 15.0,bottom: 8.0),
                child: Row(
                  children: [
                    Image.asset('assets/icons/setting.png',scale: 3.5,
                    color: isLightTheme ? Colors.black : Colors.white,),
                    const SizedBox(width: 20,),
                    const Text('Settings',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> const SettingPage()));
              },
            ),
            const SizedBox(height: 10),
             Divider(indent: 10,endIndent: 10,thickness: 0.8,height: 3,color: isLightTheme ? Colors.black : Colors.white,),
             Divider(indent: 10,endIndent: 10,thickness: 0.8,height: 3,color: isLightTheme ? Colors.black : Colors.white,),
            const SizedBox(height: 10),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0,left: 15.0,bottom: 8.0),
                child: Row(
                  children: [
                    Image.asset('assets/icons/review.png',scale: 3.5,
                      color: isLightTheme ? Colors.black : Colors.white,),
                    const SizedBox(width: 20,),
                    const Text('Review',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              onTap: () async {
                if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
                }
                //   _launchReview();
              },
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0,left: 15.0,bottom: 8.0),
                child: Row(
                  children: [
                    Image.asset('assets/icons/Share.png',scale: 3.8,
                      color: isLightTheme ? Colors.black : Colors.white,),
                    const SizedBox(width: 20,),
                    const Text('Share',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              onTap: () async {
                Share.share('hello this is local sharing,,,,,,,');
              },
            ),
            const SizedBox(height: 10),
             Divider(indent: 10,endIndent: 10,thickness: 0.8,height: 3,color: isLightTheme ? Colors.black : Colors.white,),
             Divider(indent: 10,endIndent: 10,thickness: 0.8,height: 3,color: isLightTheme ? Colors.black : Colors.white,),
            const SizedBox(height: 10),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0,left: 15.0,bottom: 8.0),
                child: Row(
                  children: [
                    Image.asset('assets/icons/privacy.png',scale: 3.5,
                      color: isLightTheme ? Colors.black : Colors.white,),
                    const SizedBox(width: 20,),
                    const Text('Privacy Policy',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              onTap: _launchURL,
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0,left: 15.0,bottom: 8.0),
                child: Row(
                  children: [
                    Image.asset('assets/icons/about.png',scale: 3.5,
                      color: isLightTheme ? Colors.black : Colors.white,),
                    const SizedBox(width: 20,),
                    const Text('About',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> const AboutSection()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
