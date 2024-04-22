
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
        title: Text('About this App',style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLightTheme ? Colors.black : Colors.black),),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              const CircleAvatar(
                backgroundColor: Color(0xffD0FCFF),
                radius: 50,
                child: FlutterLogo(size: 80,),
              ),
              const SizedBox(height: 10,),
              const Text('Hayate Sahaba',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),
              const Padding(
                padding: EdgeInsets.only(top: 8.0,left: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('● Introduction',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.blue),),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 5.0,right: 5.0),
                child: Text('Hayate Sahaba, developed by Spine Times, is dedicated to sharing the inspiring'
                    ' lives and stories of the companions (Sahaba) of the Prophet Muhammad (PBUH). This'
                    ' app aims to enlighten and educate its users about the virtuous deeds and profound'
                    ' wisdom of the Sahaba, fostering a deeper understanding of their roles in the spread of Islam.',
                style: TextStyle(fontSize: 16),),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0,left: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("● Developer's Note",
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.blue),),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 5.0,right: 5.0),
                child: Text('As a developer and a passionate follower of Islamic teachings, I created Hayate'
                    ' Sahaba to spread the knowledge and lessons from the lives of the Sahaba. My goal is to make'
                    ' these stories accessible and inspirational to all, hoping they instill a deeper sense of'
                    ' faith and understanding in our daily lives.',
                  style: TextStyle(fontSize: 16),),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0,left: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('● Contact Information',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.blue),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _sendEmail('wahidkhanhec07@gmail.com');
                          },
                          child: const Text('spinetimes@gmail.com.',
                            style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    const Text('For support, feedback, or inquiries, please feel free to reach out via above'
                        ' email. Your feedback is invaluable and will help improve this educational journey.',
                      style: TextStyle(fontSize: 16,),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25,),
              const Padding(
                padding: EdgeInsets.only(left: 5.0,right: 5.0),
                child: Text('"Thank you for choosing Hayate Sahaba as your companion in discovering the remarkable lives of'
                    ' the Prophet’s companions. We hope this app enriches your faith and understanding of Islamic history."',
                  style: TextStyle(fontSize: 16),),
              ),
              const SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}

