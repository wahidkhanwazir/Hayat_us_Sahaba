import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hayat_e_sahaba/ImagesLists/images_Lists.dart';
import 'package:hayat_e_sahaba/drawer/theme_changer/theme_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {

  InterstitialAd? interstitialAd;
  bool isAdReady = false;

  Future<void> loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            interstitialAd = ad;
            isAdReady = true;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print(',,,,,,,,,,Ad failed to show.');
              ad.dispose();
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print(',,,,,,,,,,,,,,Interstitial ad failed to load: $error');
          isAdReady = false;
        },
      ),
    );
  }

  Future<void> _showInterstitialAd() async {
    if (interstitialAd == null) {
      print(',,,,,,,,,,,Interstitial ad not loaded yet.');
      return;
    }
    await interstitialAd!.show();
    isAdReady = false;
  }

  Future<void> savePdf(List<String> imagesList, String partTitle) async {
    final pdf = pw.Document();

    for (String imagePath in imagesList) {
      final ByteData imageData = await rootBundle.load(imagePath);
      final Uint8List imageUint8List = imageData.buffer.asUint8List();
      final image = pw.MemoryImage(imageUint8List);

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );
    }

    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = 'Hayat_e_Sahaba_$timestamp.pdf';
    final String downloadsPath = (await getDownloadsDirectory())!.path;
    final String filePath = '$downloadsPath/$fileName';
    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print(',,,,,,,,,,PDF saved at: $filePath');

  }

  Future<void> savePdfDialog(List<String> imagesList, String partTitle) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save $partTitle PDF:'),
          content: Container(
            height: 200,
            decoration: const BoxDecoration(
                color: Color(0xffD0FCFF),
                image: DecorationImage(
                  image: AssetImage('assets/icons/background.png'),
                  fit: BoxFit.fill,
                  opacity: 0.5,)
            ),
            child: Image.asset('assets/icons/quran.png',fit: BoxFit.fitHeight,),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                var connectivityResult = await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No internet connection. Please check your network and try again.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  await savePdf(imagesList, partTitle);
                  Navigator.pop(context);
                  if (isAdReady) {
                    await _showInterstitialAd();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('  کو کامیابی سے محفوظ کیا گیا PDF '),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadInterstitialAd();
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChangerProvider>(context);
    bool isLightTheme = themeChanger.isLightTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Books',
        style: TextStyle(color: isLightTheme ? Colors.black : Colors.black),),
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
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              savePdfDialog(ImagesLists.part1List, 'حصہ اول');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffD0FCFF),
                  borderRadius: BorderRadius.circular(15),
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
                      opacity: 0.5,)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/icons/quran.png'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('حصہ: اول',
                            style: TextStyle(fontSize: 20,color: isLightTheme ? Colors.black : Colors.black),),
                          Text('${ImagesLists.part1List.length}  :کُل صفحات ',
                            style: TextStyle(fontSize: 20,color: isLightTheme ? Colors.black : Colors.black),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              savePdfDialog(ImagesLists.part2List, 'حصہ دوم');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffD0FCFF),
                  borderRadius: BorderRadius.circular(15),
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
                      opacity: 0.5,)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/icons/quran.png'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('حصہ: دوم',
                            style: TextStyle(fontSize: 20,color: isLightTheme ? Colors.black : Colors.black),),
                          Text('${ImagesLists.part2List.length}  :کُل صفحات ',
                            style: TextStyle(fontSize: 20,color: isLightTheme ? Colors.black : Colors.black),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              savePdfDialog(ImagesLists.part3List, 'حصہ سوم');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffD0FCFF),
                  borderRadius: BorderRadius.circular(15),
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
                      opacity: 0.5,)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/icons/quran.png'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('حصہ: سوم',
                            style: TextStyle(fontSize: 20,color: isLightTheme ? Colors.black : Colors.black),),
                          Text('${ImagesLists.part3List.length}  :کُل صفحات ',
                            style:  TextStyle(fontSize: 20,color: isLightTheme ? Colors.black : Colors.black),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
