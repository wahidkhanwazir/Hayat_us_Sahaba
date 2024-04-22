import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hayat_e_sahaba/drawer/theme_changer/theme_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';


class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final storage = GetStorage();
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  final int _maxFailedLoadAttempts = 3;
  Timer? _adTimer;

  @override
  void initState(){
    super.initState();
    _createInterstitialAd();
    _adTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _showInterstitialAd();
    });
  }

  void _createInterstitialAd() {
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

  @override
  void dispose() {
    _adTimer?.cancel();
    _interstitialAd?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChangerProvider>(context);
    bool isLightTheme = themeChanger.isLightTheme;
    List<Map<String, dynamic>> favourites = (storage.read('favourites') as List?)?.cast<Map<String, dynamic>>() ?? [];
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
        title: Text('Favorites',style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLightTheme ? Colors.black : Colors.black),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.star,size: 25,color: isLightTheme ? Colors.black : Colors.black),
          )
        ],
      ),
      body: favourites.isEmpty ? const Center(child: Text('کوئی صفہ نہیں ملا'),) :
      ListView.builder(
        itemCount: favourites.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:  const EdgeInsets.all(5.0),
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:  const BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
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
                      opacity: 0.5,)
                ),
                child: ListTile(
                  leading: Image.asset(favourites[index]['favImage']),
                  trailing: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('صفہ ہٹائیں'),
                              content: SizedBox(
                                height: 250,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: const BoxDecoration(
                                          color: Color(0xffD0FCFF),
                                          image: DecorationImage(
                                            image: AssetImage('assets/icons/background.png'),
                                            fit: BoxFit.fill,
                                            opacity: 0.5,)
                                      ),
                                      child: Image.asset(favourites[index]['favImage'],fit: BoxFit.fitHeight,),
                                    ),
                                    const Text('کیا آپ واقعی اس صفہ کو ہٹانا چاہتے ہیں؟'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      favourites.removeAt(index);
                                      storage.write('favourites', favourites);
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('صفحہ کو ہٹا دیا گیا۔'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    });
                                  },
                                  child: const Text('جی ہاں'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('نہیں'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('ہٹائیں',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                  title: Text(' حصہ: ${favourites[index]['favPart']}',
                    style: TextStyle(color: isLightTheme ? Colors.black : Colors.black),),
                  subtitle: Text('${favourites[index]['favPage'] + 1} :صفہ نمبر',
                    style: TextStyle(color: isLightTheme ? Colors.black : Colors.black),),
                ),
              ),
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 40,
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('${favourites[index]['favPage'] + 1} :صفہ نمبر',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: isLightTheme ? Colors.black : Colors.black),),
                          Text(' حصہ: ${favourites[index]['favPart']}',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: isLightTheme ? Colors.black : Colors.black),
                          ),
                        ],
                      ),
                    ),
                    body: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: PhotoView(
                            minScale: PhotoViewComputedScale.contained * 1.0,
                            maxScale: PhotoViewComputedScale.covered * 2.0,
                            initialScale: PhotoViewComputedScale.contained,
                            imageProvider: AssetImage(favourites[index]['favImage']),
                            backgroundDecoration:
                            const BoxDecoration(
                              color: Color(0xffD0FCFF),
                                image: DecorationImage(
                                  image: AssetImage('assets/icons/background.png'),
                                  fit: BoxFit.fill,
                                  opacity: 0.5,)),
                            ),
                        ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
