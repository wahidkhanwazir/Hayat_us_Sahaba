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
  void initState() {
    super.initState();
    loadAd();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        reloadAd();
        _createInterstitialAd();
      }
    });
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
  Future<void> loadAd() async {
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
    }else {
      print(',,,,,,,,,,,Adaptive ad size not available');
    }
  }

  void reloadAd() {
    if (_bannerAd != null) {
      _bannerAd!.dispose();
    }
    loadAd();
  }

  final pageController = TextEditingController();
  String? selectedPart;
  List<String> parts = [
    ' اول',
    ' دوم',
    ' سوم',
  ];

  @override

  Widget build(BuildContext context) {
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
         appBar: AppBar(
           backgroundColor: isLightTheme ? Colors.white : Colors.black,
           toolbarHeight: 140,
           leading: Container(),
           flexibleSpace: Stack(
            children: [
              Column(
               children: [
                 Container(
                  height: 85,
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
                  height: 79,
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
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: isLightTheme ? Colors.black : Colors.black)),
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
                  height: 70,
                  width: width / 1.04,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text('حَیَاۃُ الصَّحَابَہؓ',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: isLightTheme ? Colors.black : Colors.black,),
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
        body: SingleChildScrollView(
          child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
            const SizedBox(height: 2),
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
                               Image.asset('assets/icons/book.png',scale: height / 125,),
                               Text('آخری پڑھا ہوا',
                                   style: TextStyle(
                                       fontSize: width / 12.5,
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
                                       fontSize: width / 16,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.white)),
                               Text(' حصہ${storageProvider.getLastPart()}',
                                   style: TextStyle(
                                       fontSize: width / 16,
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
           Padding(
             padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 1.0,bottom: 5.0),
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
                     width: 55,
                     child: TextButton(
                         onPressed: () {
                           if (selectedPart == null ||
                               pageController.text.isEmpty) {
                             ScaffoldMessenger.of(context)
                                 .showSnackBar(
                               const SnackBar(
                                 content: Text(
                                     'براہ کرم کوئی صفحہ یا حصہ درج کریں'),
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
                           side: MaterialStateProperty.all(const BorderSide(width: 0.5)),
                           backgroundColor: isLightTheme
                               ? MaterialStateProperty.all(
                                   Colors.white)
                               : MaterialStateProperty.all(
                                   Colors.white),
                         ),
                         child: Text(
                           'جائیے',
                           style: TextStyle(
                               fontWeight: FontWeight.bold,
                               color: isLightTheme
                                   ?  Colors.black
                                   :  Colors.black),
                         )),
                   ),
                   SizedBox(width: width / 40),
                   Expanded(
                     child: SizedBox(
                       width: 70,
                       height: 35,
                       child: TextField(
                         maxLength: 3,
                         keyboardType: TextInputType.number,
                         controller: pageController,
                         textAlign: TextAlign.center,
                         style: TextStyle(
                             color: isLightTheme
                                 ? Colors.black
                                 : Colors.black),
                         decoration: InputDecoration(
                           counterText: '',
                           filled: true,
                           fillColor: Colors.white,
                           hintText: '  :صفحہ نمبر',
                           hintStyle: TextStyle(
                               fontSize: 12,
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
                     child: Stack(children: [
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
                                             fontSize: 13,
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
                             left: 15,
                             top: 6,
                             child: Text('حصہ',
                               style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   color: isLightTheme
                                       ? Colors.grey.shade600
                                       : Colors.grey.shade600),
                             ))
                     ]),
                   ),
                   SizedBox(width: width / 40),
                   const Text('صفحہ پڑ جائیے',
                       style: TextStyle(
                           fontSize: 15,
                           fontWeight: FontWeight.bold,
                           color: Colors.black)),
                   SizedBox(width: width / 40),
                 ],
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 2),
             child: GridView.count(
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
                               Image.asset('assets/icons/Author.png',scale: height / 150,),
                               Text('مصنف',
                                 style: TextStyle(
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
              ),
               const SizedBox(height: 50,)
           ],
          ),
         ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: size.height - height/1.084,
            width: double.infinity,
            child: Center(
              child: _bannerAd != null
                  ? AdWidget(ad: _bannerAd!)
                  : const SizedBox(),
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
    var height = size.height;
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
              Image.asset('assets/icons/quran.png',scale: height / 150,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(parts[index],
                    style: TextStyle(
                        fontSize: width / 15,
                        fontWeight: FontWeight.bold,
                        color: isLightTheme ? Colors.black : Colors.black),
                  ),
                  Text('حصہ',
                    style: TextStyle(
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
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
