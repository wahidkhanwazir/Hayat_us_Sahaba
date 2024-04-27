
import 'package:flutter/material.dart';
import 'package:hayat_e_sahaba/drawer/theme_changer/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {

  void _sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw ',,,,,,,Could not launch $emailLaunchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChangerProvider>(context);
    bool isLightTheme = themeChanger.isLightTheme;
    return  Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: const Color(0xffD0FCFF),
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CircleAvatar(
                  backgroundColor: Color(0xffD0FCFF),
                  radius: 45,
                  child: Image.asset('assets/icons/app icon.png'),
                ),
              ),
              const SizedBox(height: 10,),
              Text(':تعارف',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text('اسپائن ٹائمز کے ذریعہ تیار کردہ '
                  'حیات صحابہ، پیغمبر اسلام (ص) کے صحابہ (صحابہ) کی متاثر کن زندگیوں اور کہانیوں کو شیئر کرنے'
                  ' کے لئے وقف ہے۔ اس ایپ کا مقصد اپنے صارفین کو صحابہ کرام کے نیک اعمال اور گہری حکمت کے'
                  ' بارے میں روشن خیال اور تعلیم دینا ہے، اسلام کے پھیلاؤ میں ان کے کردار کے بارے میں گہری سمجھ کو فروغ دینا۔',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.end,
              ),
              Text(":ڈویلپر کا نوٹ",
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text('ایک ڈویلپر اور اسلامی تعلیمات کے پرجوش پیروکار کے طور پر، میں نے حیات صحابہ کو صحابہ کی'
                  ' زندگیوں سے علم اور اسباق کو پھیلانے کے لیے بنایا۔ میرا مقصد ان کہانیوں کو سب کے لیے قابل رسائی اور'
                  ' متاثر کن بنانا ہے، امید ہے کہ یہ ہماری روزمرہ کی زندگی میں ایمان اور سمجھ کا گہرا احساس پیدا کریں گی۔',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.end,
              ),
              Text(':رابطے کی معلومات',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              GestureDetector(
                onTap: () {
                  _sendEmail('wahidkhanhec07@gmail.com');
                },
                child: const Text('spinetimes@gmail.com.',
                  style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const Text('سپورٹ، فیڈ بیک، یا پوچھ گچھ کے لیے، براہ کرم اوپر ای میل کے ذریعے '
                  'بلا جھجھک رابطہ کریں۔ آپ کی رائے انمول ہے اور اس تعلیمی سفر کو بہتر بنانے میں مدد کرے گی۔',
                style: TextStyle(fontSize: 15,),
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 25,),
              const Padding(
                padding: EdgeInsets.only(left: 5.0,right: 5.0),
                child: Text('حیات صحابہ کو اپنے ساتھی کے طور پر منتخب کرنے کے لیے آپ کا شکریہ کہ آپ نے صحابہ'
                    ' کرام کی شاندار زندگیوں کو دریافت کیا ہے۔ ہم امید کرتے ہیں کہ یہ'
                    ' ایپ آپ کے ایمان اور اسلامی تاریخ کے بارے میں سمجھ بوجھ کو بہتر بنائے گی۔',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}

