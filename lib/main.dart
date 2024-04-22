import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hayat_e_sahaba/Home/home_page.dart';
import 'package:hayat_e_sahaba/Local_Data_Saver/local_storage.dart';
import 'package:hayat_e_sahaba/drawer/theme_changer/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init();
  MobileAds.instance.initialize();
  loadads();
  runApp(
    const MyApp(),
  );
  FlutterNativeSplash.remove();
}

 AppOpenAd? _appOpenAd;

 loadads() {
   AppOpenAd.load(
       adUnitId: 'ca-app-pub-3940256099942544/9257395921',
       request: const AdRequest(),
       adLoadCallback: AppOpenAdLoadCallback(
           onAdLoaded: (ad) {
             _appOpenAd = ad;
             _appOpenAd!.show();
           },
           onAdFailedToLoad: (error) {
             debugPrint(',,,,,,,,,,Error $error');
           },),
   );
 }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeChangerProvider()),
          ChangeNotifierProvider(create: (_) => StorageProvider()),
        ],
        child: Builder(
          builder: (BuildContext context){
            final themeChanger = Provider.of<ThemeChangerProvider>(context);
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode: themeChanger.themeMode,
                theme: ThemeData(
                  brightness: Brightness.light,
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                ),
                home: const HomePage()
            );
          },
        )
    );
  }
}
