import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hayat_e_sahaba/Home/detail_page.dart';
import 'package:hayat_e_sahaba/Home/about_owner.dart';
import 'package:hayat_e_sahaba/Local_Data_Saver/local_storage.dart';
import 'package:hayat_e_sahaba/drawer/Settings/favourites.dart';
import 'package:hayat_e_sahaba/drawer/drawer.dart';
import 'package:hayat_e_sahaba/drawer/theme_changer/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';


final storage = GetStorage();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String, int> partClickCount = {
    ' اول': 0,
    ' دوم': 0,
    ' سوم': 0,
  };

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  final int _maxFailedLoadAttempts = 3;

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print(',,,,,,,,,,,Interstitial Ad Loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print(',,,,,,,,,,,,,Interstitial Ad Failed to Load: $error');
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
      print(',,,,,,,,,,,,,Trying to show before ad is loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print(',,,,,,,,,,,,Ad dismissed');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print(',,,,,,,,,,,,,,,,,Ad failed to show.');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _incrementClickCount(String part) {
    partClickCount.update(part, (value) => value + 1);

    if (partClickCount[part] == 4) {
      _showInterstitialAd();
      partClickCount[part] = 0;
    }
  }

  BannerAd? _bannerAd;
  bool _hasInternetConnection = false;

  Future<void> _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _hasInternetConnection = true;
      });
    }
  }

  Future<void> loadAd() async {
    if (_hasInternetConnection) {
      final adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.toInt(),
      );
      if (adSize != null) {
        _bannerAd = BannerAd(
          adUnitId: 'ca-app-pub-3940256099942544/6300978111',
          request: const AdRequest(),
          size: adSize,
          listener: BannerAdListener(
            onAdLoaded: (ad) => setState(() {}),
            onAdFailedToLoad: (ad, error) {
              print(',,,,,,BannerAd failed to load: $error');
              ad.dispose();
            },
          ),
        )..load();
      } else {
        print(',,,,,,,,,,,Adaptive ad size not available');
      }
    } else {
      print(',,,,,,,,,,,No internet connection, not loading ad.');
    }
  }

  void reloadAd() {
    if (_bannerAd != null) {
      _bannerAd!.dispose();
    }
    loadAd();
    _createInterstitialAd();
  }

  final pageController = TextEditingController();
  String? selectedPart;
  List<String> parts = [
    ' اول',
    ' دوم',
    ' سوم',
  ];

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
    loadAd();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _hasInternetConnection = result != ConnectivityResult.none;
      if (_hasInternetConnection) {
        reloadAd();
      }
    });
  }

  @override

  Widget build(BuildContext context) {
    loadAd();
    final themeChanger = Provider.of<ThemeChangerProvider>(context);
    bool isLightTheme = themeChanger.isLightTheme;
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Stack(
      children: [
        Scaffold(
         drawer: const Drawer(
           child: DrawerPage(),
         ),
         body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: height / 4.22,
              child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: height / 8,
                          decoration: BoxDecoration(
                              color: const Color(0xffD0FCFF),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: isLightTheme ? Colors.black45 : Colors.grey.shade500,
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 5)
                                ),
                              ],
                              image: const DecorationImage(
                                image: AssetImage('assets/icons/background.png'),
                                fit: BoxFit.fill,
                                opacity: 1,)
                          ),
                        ),
                        Container(
                          height: height / 9,
                          width: width / 1.04,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color(0xffD0FCFF),
                              boxShadow: [
                                BoxShadow(
                                    color: isLightTheme ? Colors.black45 : Colors.grey.shade500,
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 5)
                                ),
                              ],
                              image: const DecorationImage(
                                image: AssetImage('assets/icons/background.png'),
                                fit: BoxFit.fill,
                                opacity: 1,)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text('اسلام علیکم',
                                      style: TextStyle(
                                          fontFamily: 'MyFont2',
                                          fontSize: height / 30,
                                          fontWeight: FontWeight.bold,
                                          color: isLightTheme ? Colors.black : Colors.black),),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: 55,
                      left: width / 45,
                      right: width / 45,
                      child: Container(
                        height: height / 10.8,
                        width: width / 1.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Builder(
                                builder: (context) {
                                  return CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: GestureDetector(
                                      child: Icon(Icons.menu, size: 27,color: isLightTheme ? Colors.black : Colors.black,),
                                      onTap: () {
                                        Scaffold.of(context).openDrawer();
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('حَیَاۃُ الصَّحَابَہؓ',
                                style: TextStyle(
                                  fontFamily: 'MyFont2',
                                  fontSize: height / 25,
                                  fontWeight: FontWeight.bold,
                                  color: isLightTheme ? Colors.black : Colors.black,),
                              ),
                            ),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffD0FCFF),
                                    ),
                                    child: Icon(Icons.favorite,size: 25,color: isLightTheme ? Colors.black : Colors.black,)
                                ),
                              ),
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=> const FavouritePage()));
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ]
              ),
            ),

           Container(
             width: double.infinity,
             height: (height / 100) * 76.3,
             child: SingleChildScrollView(
               child: Column(
                 children: [
                   SizedBox(
                     height: height / 80,
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Consumer <StorageProvider>(
                      builder: (context,storageProvider,_) {
                        return InkWell(
                          child: Container(
                            height: height / 6.7,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xff4A5758),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: isLightTheme ? Colors.black45 : Colors.grey.shade500,
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 5)
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 40.0,right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: height / 13.5,
                                          child: Image.asset('assets/icons/book.png',)),
                                      Text('آخری پڑھا ہوا',
                                          style: TextStyle(
                                              fontFamily: 'MyFont2',
                                              fontSize: height / 25.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0,right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${storageProvider.getLastPage() + 1} :صفہ نمبر',
                                          style: TextStyle(
                                              fontFamily: 'MyFont2',
                                              fontSize: height / 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      Text(' حصہ${storageProvider.getLastPart()}',
                                          style: TextStyle(
                                              fontFamily: 'MyFont2',
                                              fontSize: height / 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      part: storageProvider.getLastPart(),
                                      page: storageProvider.getLastPage(),
                                    )));
                            _incrementClickCount(' اول');
                            _incrementClickCount(' دوم');
                            _incrementClickCount(' سوم');
                          },
                        );
                      }
                    ),
                             ),
                   SizedBox(
                     height: height / 100,
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 1.0),
                     child: Container(
                       height: height / 12,
                       width: double.infinity,
                       decoration: BoxDecoration(
                           color: const Color(0xffD0FCFF),
                           borderRadius: BorderRadius.circular(15),
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
                       child: Row(
                         children: [
                           SizedBox(width: width / 35),
                           SizedBox(
                             height: 35,
                             width: width / 6.5,
                             child: TextButton(
                                 onPressed: () {
                                   if (selectedPart == null ||
                                       pageController.text.isEmpty) {
                                     ScaffoldMessenger.of(context)
                                         .showSnackBar(
                                       const SnackBar(
                                         content: Text('براہ کرم کوئی صفحہ یا حصہ درج کریں'),
                                         duration: Duration(seconds: 2),
                                       ),
                                     );
                                     return;
                                   }

                                   final page = int.parse(pageController.text);

                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                           builder: (context) => DetailPage(
                                               part: selectedPart!,
                                               page: page - 1)));
                                   _incrementClickCount(' اول');
                                   _incrementClickCount(' دوم');
                                   _incrementClickCount(' سوم');
                                   pageController.clear();
                                   selectedPart == null;
                                 },
                                 style: ButtonStyle(
                                   side: WidgetStateProperty.all(const BorderSide(width: 0.5)),
                                   backgroundColor: isLightTheme
                                       ? WidgetStateProperty.all(Colors.grey.shade200)
                                       : WidgetStateProperty.all(Colors.grey.shade200),
                                 ),
                                 child: Text('جائیے',
                                   style: TextStyle(
                                       fontFamily: 'MyFont2',
                                       fontSize: width / 30,
                                       fontWeight: FontWeight.bold,
                                       color: isLightTheme
                                           ?  Colors.black
                                           :  Colors.black),
                                 )),
                           ),
                           SizedBox(width: width / 40),
                           Expanded(
                             child: SizedBox(
                               width: width / 5.5,
                               height: 35,
                               child: TextField(
                                 maxLength: 4,
                                 keyboardType: TextInputType.number,
                                 controller: pageController,
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                     color: isLightTheme
                                         ? Colors.black
                                         : Colors.black),
                                 decoration: InputDecoration(
                                   contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                                   counterText: '',
                                   filled: true,
                                   fillColor: Colors.white,
                                   hintText: '  :صفحہ نمبر',
                                   hintStyle: TextStyle(
                                       fontFamily: 'MyFont2',
                                       fontSize: width / 35,
                                       color: isLightTheme ? Colors.grey.shade600 : Colors.grey.shade600),
                                   border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(20.0),
                                   ),
                                 ),
                               ),
                             ),
                           ),
                           SizedBox(width: width / 40),
                           Expanded(
                             child: Stack(
                                 children: [
                                   Container(
                                     height: 34,
                                     width: width / 4.5,
                                     decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(30)),
                                     child: Padding(
                                       padding: const EdgeInsets.only(
                                           left: 20.0, bottom: 3),
                                       child: DropdownButton(
                                           isExpanded: true,
                                           value: selectedPart,
                                           onChanged: (newValue) {
                                             setState(() {
                                               selectedPart = newValue;
                                             });
                                           },
                                           items: parts.map((e) {
                                             return DropdownMenuItem(
                                                 value: e,
                                                 child: Text(e,
                                                     style: TextStyle(
                                                         fontFamily: 'MyFont2',
                                                         fontSize: width / 26,
                                                         fontWeight:
                                                         FontWeight.bold,
                                                         color: isLightTheme
                                                             ? Colors.black
                                                             : Colors.grey.shade700)));
                                           }).toList(),
                                           underline: const SizedBox()),
                                     ),
                                   ),
                                   if (selectedPart == null)
                                     Positioned(
                                         left: 18,
                                         top: 10,
                                         child: Text('حصہ',
                                           style: TextStyle(
                                               fontFamily: 'MyFont2',
                                               fontSize: width / 26,
                                               fontWeight: FontWeight.bold,
                                               color: isLightTheme
                                                   ? Colors.grey.shade600
                                                   : Colors.grey.shade600),
                                         ))
                                 ]),
                           ),
                           SizedBox(width: width / 40),
                           Text('صفحہ پڑ جائیے',
                               style: TextStyle(
                                   fontFamily: 'MyFont2',
                                   fontSize: width / 24,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black)),
                           SizedBox(width: width / 40),
                         ],
                       ),
                     ),
                   ),
                   SizedBox(
                     height: height / 70,
                   ),
                   GridView.count(
                       padding: EdgeInsets.symmetric(horizontal: 15.0),
                       shrinkWrap: true,
                       physics: const NeverScrollableScrollPhysics(),
                       crossAxisCount: 2,
                       crossAxisSpacing: 37.0,
                       mainAxisSpacing: 13.0,
                       childAspectRatio: 1.125,
                       children: [
                         partButten(context, 1, parts[1], 0),
                         partButten(context, 0, parts[0], 0),
                         partButten(context, 2, parts[2], 0),
                         InkWell(
                           child: Container(
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
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
                             child: Center(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     SizedBox(
                                         width: width / 6,
                                         child: Image.asset('assets/icons/Author.png',)),
                                     Text('مصنف',
                                       style: TextStyle(
                                           fontFamily: 'MyFont2',
                                           fontSize: width / 15,
                                           fontWeight: FontWeight.bold,
                                           color: isLightTheme ? Colors.black : Colors.black),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           ),
                           onTap: () {
                             Navigator.push(context,
                                 MaterialPageRoute(builder: (context) => const AboutOwner()));
                             _incrementClickCount(' اول');
                             _incrementClickCount(' دوم');
                             _incrementClickCount(' سوم');
                           },
                         )
                       ]
                   ),
                   SizedBox(
                     height: height / 12.7,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: size.height - height / 1.084,
            width: double.infinity,
            child: Center(
              child: _bannerAd != null
                  ? AdWidget(ad: _bannerAd!)
                  : SizedBox(),
            ),
          ),
        ),
      ]
    );
  }

  InkWell partButten(
    BuildContext context,
    int index,
    String part,
    int page,
  ) {
    final themeChanger = Provider.of<ThemeChangerProvider>(context);
    bool isLightTheme = themeChanger.isLightTheme;
    var size = MediaQuery.of(context).size;
    var width = size.width;
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: width / 6,
                  child: Image.asset('assets/icons/quran.png')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(parts[index],
                    style: TextStyle(
                        fontFamily: 'MyFont2',
                        fontSize: width / 15,
                        fontWeight: FontWeight.bold,
                        color: isLightTheme ? Colors.black : Colors.black),
                  ),
                  Text('حصہ',
                    style: TextStyle(
                        fontFamily: 'MyFont2',
                        fontSize: width / 15,
                        fontWeight: FontWeight.bold,
                        color: isLightTheme ? Colors.black : Colors.black),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailPage(
                      part: parts[index],
                      page: page,
                    )));
        _incrementClickCount(' اول');
        _incrementClickCount(' دوم');
        _incrementClickCount(' سوم');
      },
    );
  }
}
