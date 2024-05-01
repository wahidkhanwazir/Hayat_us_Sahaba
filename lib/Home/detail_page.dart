import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hayat_e_sahaba/ImagesLists/images_Lists.dart';
import 'package:hayat_e_sahaba/Local_Data_Saver/local_storage.dart';
import 'package:hayat_e_sahaba/drawer/theme_changer/theme_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

class DetailPage extends StatefulWidget {
 final String part;
 final int page;
  const DetailPage({super.key,
    required this.part,
    required this.page,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  List<String> currentImageList = [];
  String? part;
  int? page;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  final int _maxFailedLoadAttempts = 3;
  Timer? _adTimer;
  InterstitialAd? interstitialAd;
  bool isAdReady = false;

  @override
  void initState() {
    super.initState();
    page = widget.page;
    part = widget.part;
    switch (widget.part) {
      case ' اول':
        currentImageList = ImagesLists.part1List;
        break;
      case ' دوم':
        currentImageList = ImagesLists.part2List;
        break;
      case ' سوم':
        currentImageList = ImagesLists.part3List;
        break;
      default:
        currentImageList = [];
    }
    _createInterstitialAd();
    _adTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _showInterstitialAd();
    });
    loadSaveInterstitialAd();
  }

  Future<void> _createInterstitialAd() async {
    // Check for internet connectivity
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection. Unable to load ads.');
      return;
    }

    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print(',,,,,,,,,,,,,,Interstitial Ad Loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print(',,,,,,,,,,,,,,Interstitial Ad Failed to Load: $error');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < _maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print(',,,,,,,,,,,,,,Trying to show before ad is loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print(',,,,,,,,,,,Ad dismissed');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print(',,,,,,,,,,,,Ad failed to show.');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  Future<void> loadSaveInterstitialAd() async {
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
              loadSaveInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print(',,,,,,,,,,Save Ad failed to show.');
              ad.dispose();
              loadSaveInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print(',,,,,,,,,,,,,,Save Interstitial ad failed to load: $error');
          isAdReady = false;
        },
      ),
    );
  }

  Future<void> showSaveInterstitialAd() async {
    if (interstitialAd == null) {
      print(',,,,,,,,,,,Save Interstitial ad not loaded yet.');
      return;
    }
    await interstitialAd!.show();
    isAdReady = false;
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    _interstitialAd?.dispose();
    interstitialAd?.dispose();
    super.dispose();
  }

  Future<void> savePdf() async {
      final pdf = pw.Document();

      final ByteData imageData = await rootBundle.load(
          currentImageList[page!.toInt()]);
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

      final String? direction = (await getDownloadsDirectory())?.path;
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String path = '$direction/Hayat_e_Sahaba_$timestamp.pdf';
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());

  }

  @override
  Widget build(BuildContext context) {
    final storageProvider = Provider.of<StorageProvider>(context);
    final themeChanger = Provider.of<ThemeChangerProvider>(context);
    bool isLightTheme = themeChanger.isLightTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isLightTheme ? Colors.white : Colors.black,
        //toolbarHeight: 40,
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
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    return GestureDetector(
                      child: Image.asset('assets/icons/home.png',scale: 4.8,
                      color: isLightTheme ? Colors.black : Colors.white,),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: const Border(
                      top: BorderSide(width: 0.5,color: Colors.grey),
                      right: BorderSide(width: 0.5,color: Colors.grey),
                      bottom: BorderSide(width: 0.5,color: Colors.grey),
                      left: BorderSide(width: 0.5,color: Colors.grey),
                    ),
                    color: const Color(0xffD0FCFF),
                      image: const DecorationImage(
                        image: AssetImage('assets/icons/background.png'),
                        fit: BoxFit.fill,
                        opacity: 1,)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)
                              ),
                              child: Center(
                                child:
                                Text( '${page!+1}',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                                      color: isLightTheme ? Colors.grey.shade600 : Colors.grey.shade600),
                                ),
                              ),
                            ),
                            Text(' /${currentImageList.length}',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isLightTheme ? Colors.black : Colors.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(' صفحہ نمبر',
                                style: TextStyle(
                                    fontFamily: 'MyFont2',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isLightTheme ? Colors.black : Colors.black),
                                ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0,top: 3.0),
                        child: Row(
                          children: [
                            Text(part.toString(),
                              style: TextStyle(
                                  fontFamily: 'MyFont2',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: isLightTheme ? Colors.black : Colors.black),
                            ),
                            Text('حصہ',
                              style: TextStyle(
                                  fontFamily: 'MyFont2',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: isLightTheme ? Colors.black : Colors.black),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
               InkWell(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Image.asset('assets/icons/Share.png',scale: 4.5,
                     color: isLightTheme ? Colors.black : Colors.white,),
                 ),
                 onTap: () async {
                   final ByteData imageData = await rootBundle.load(currentImageList[page!]);
                   final Uint8List imageUint8List = imageData.buffer.asUint8List();
                   final tempDir = await getTemporaryDirectory();
                   final tempFilePath = '${tempDir.path}/image.png';
                   final tempFile = File(tempFilePath);
                   await tempFile.writeAsBytes(imageUint8List);

                   final String text = 'Hayat_e_Sahaba صفحہ نمبر: ${page! + 1}  حصہ: $part';
                   await Share.shareFiles([tempFilePath], text: text);
                   setState(() {});
                 },
               ),
            ],
          ),
          const SizedBox(height: 1,),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: currentImageList.length,
              onPageChanged: (index){
                 setState(() {
                    page = index;
                    storageProvider.setLast(page!, part!);
                 });
              },
              controller: PageController(initialPage: page!.toInt()),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: PhotoView(
                    minScale: PhotoViewComputedScale.contained * 1.0,
                    maxScale: PhotoViewComputedScale.covered * 2.0,
                    initialScale: PhotoViewComputedScale.contained,
                    imageProvider: AssetImage(currentImageList[page!.toInt()]),
                    backgroundDecoration:
                    const BoxDecoration(
                      color: Color(0xffD0FCFF),
                        image: DecorationImage(
                          image: AssetImage('assets/icons/background.png'),
                          fit: BoxFit.fill,
                          opacity: 1,)),
                  ),
                );
              },
            )
          ),
        ],
      ),
       bottomNavigationBar: Container(
             height: 55,
             width: double.infinity,
             decoration: const BoxDecoration(
               color: Color(0xffD0FCFF),
               borderRadius: BorderRadius.only(
                   topRight: Radius.circular(30),
                   topLeft: Radius.circular(30)),
                 image: DecorationImage(
                   image: AssetImage('assets/icons/background.png'),
                   fit: BoxFit.fill,
                   opacity: 0.6,)
             ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        child: Column(
                          children: [
                            Image.asset('assets/icons/download.png',scale: 5,),
                            Text('Download',
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
                                  color: isLightTheme ? Colors.black : Colors.black),)
                          ],
                        ),
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Save PDF:'),
                                content: Container(
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffD0FCFF),
                                      image: DecorationImage(
                                        image: AssetImage('assets/icons/background.png'),
                                        fit: BoxFit.fill,
                                        opacity: 1,)
                                  ),
                                  child: Image.asset(currentImageList[page!.toInt()],fit: BoxFit.fitHeight,),
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
                                      }else {
                                        await savePdf();
                                        Navigator.pop(context);
                                        if (isAdReady) {
                                          await showSaveInterstitialAd();
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                            const SnackBar(content: Text(
                                                '  کو کامیابی سے محفوظ کیا گیا PDF '),
                                              duration: Duration(seconds: 2),
                                            )
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
                        },
                      ),
                      const SizedBox(width: 10,),
                      InkWell(
                        child: Column(
                          children: [
                            Image.asset('assets/icons/favourite.png',scale: 5,),
                            Text('Favourities',
                               style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
                                   color: isLightTheme ? Colors.black : Colors.black),)
                          ],
                        ),
                        onTap: () {
                          final storage = GetStorage();
                          List<Map<String, dynamic>> favourites = (storage.read('favourites') as List?) ?.cast<Map<String, dynamic>>() ?? [];
                          Map<String, dynamic> newFavourite = {
                            'favImage': currentImageList[page!.toInt()],
                            'favPage': page,
                            'favPart': part,
                          };

                          bool alreadyExists = favourites.any((fav) =>
                          fav['favImage'] == newFavourite['favImage'] &&
                              fav['favPage'] == newFavourite['favPage'] &&
                              fav['favPart'] == newFavourite['favPart']);

                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: const Text('Add to Favorite:'),
                                  content: Container(
                                    height: 200,
                                    decoration: const BoxDecoration(
                                        color: Color(0xffD0FCFF),
                                        image: DecorationImage(
                                          image: AssetImage('assets/icons/background.png'),
                                          fit: BoxFit.fill,
                                          opacity: 1,)
                                    ),
                                    child: Image.asset(currentImageList[page!.toInt()],fit: BoxFit.fitHeight,),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: (){
                                          if (!alreadyExists) {
                                            favourites.add(newFavourite);
                                            storage.write('favourites', favourites);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('پسندیدہ میں شامل کیا گیا۔'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'پہلے ہی پسندیدہ میں شامل ہو چکا ہے۔'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Add'),),
                                    TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),),
                                  ],
                                );
                              }
                            );
                         },
                      ),
                   ],
                ),
             ],
          ),
       )
    );
  }
}
