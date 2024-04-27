import 'package:flutter/material.dart';
import 'package:hayat_e_sahaba/drawer/theme_changer/theme_provider.dart';
import 'package:provider/provider.dart';

class AboutOwner extends StatefulWidget {
  const AboutOwner({super.key});

  @override
  State<AboutOwner> createState() => _AboutOwnerState();
}

class _AboutOwnerState extends State<AboutOwner> {

  List<String> _authorHeadingList = [
    'مولانا محمد یوسف کندھلوی: ایک عالم اور اسلامی احیاء کے رہنما',
    ':ابتدائی زندگی اور تعلیم',
    ':تبلیغی جماعت کی قیادت',
    ':اسلامی احیاء پر اثر',
    ':ادبی خدمات',
    ':میراث',
  ];

  List<String> _authorHeadingDescription = [
    'مولانا محمد یوسف کندھلوی (1917-1965) ایک ممتاز اسلامی اسکالر تھے جنہوں نے مسلم '
        'دنیا پر خاص طور پر ایک عالمی اسلامی تبلیغی تحریک، تبلیغی جماعت کی قیادت کے ذریعے ایک گہرا نقش چھوڑا۔',
    '1917 میں بھارت کے کاندھلہ میں پیدا ہوئے، یوسف کندھلوی کم عمری ہی سے'
        ' علمی ماحول سے وابستہ رہے۔ انہوں نے کم عمر یعنی دس سال کی عمر میں قرآن حفظ کیا اور اسلامی علوم میں اپنی تعلیم'
        ' جاری رکھی۔ انہوں نے اپنے والد، مولانا محمد الیاس کندھلوی، جو تبلیغی جماعت کے بانی تھے، اور اس وقت کے دیگر '
        'ممتاز علماء سے علم حاصل کیا۔ اسلامی اسکالر شپ سے اس ابتدائی وابستگی نے ان کی آئندہ خدمات کی بنیاد رکھی۔',
    '1943 میں اپنے والد کی وفات کے بعد، یوسف کندھلوی نے تبلیغی جماعت کے دوسرے امیر'
        ' (رہنما) کا عہدہ سنبھال لیا۔ انہوں نے تحریک کی رسائی کو ہندوستان سے باہر پھیلانے میں اہم کردار ادا کیا اور اسے ایک عالمی تحریک میں'
        ' تبدیل ہونے میں فروغ دیا۔ ان کی قیادت میں، تبلیغی جماعت نے اسلامی اصولوں پر مبنی تبلیغ، تعلیم اور سماجی اصلاح کی اہمیت پر'
        ' زور دیا۔ یہ تحریک دنیا بھر کے مسلمانوں میں اسلامی اعمال کو زندہ کرنے اور انہیں فروغ دینے پر توجہ مرکوز کرتی ہے۔',
    'یوسف کندھلوی کا تبلیغی جماعت کے ساتھ کام 20ویں صدی کی اسلامی احیاء تحریکوں کے تناظر میں اہمیت کا حامل ہے۔ یہ تحریک، عملی تقویٰ اور کمیونٹی تک رسائی پر زور دینے'
        ' کی وجہ سے دنیا بھر کے مسلمانوں میں اسلامی عقیدے اور عمل کو بحال کرنے میں مددگار ثابت ہوئی ہے۔ انہیں تبلیغی جماعت کے تبلیغی '
        'کام کے منفرد انداز کو تیار کرنے کا سہرا جاتا ہے، جو مختصر مدت کے تبلیغی دوروں اور ذاتی تبدیلی پر توجہ مرکوز کرتا ہے۔',
    'اپنی قیادت کے کردار سے ہٹ کر، یوسف کندھلوی ایک انمول مصنف بھی تھے۔ ان کی سب سے مشہور تصنیف "حياة الصحابہ" (صحابہ کی زندگیاں) ہے، جسے تبلیغی جماعت کے لیے'
        ' ایک بنیادی متن سمجھا جاتا ہے۔ یہ کتاب نبی اکرم حضرت محمد صلی اللہ علیہ وسلم کے صحابہ کرام کی زندگیوں اور تعلیمات کا احاطہ کرتی ہے،'
        ' جو مسلمانوں کے لیے بطورِ منبعِ رہنمائی اور ترغیب کا کام دیتی ہے جو اسلام کی اپنی سمجھ کو مزید گہرا کرنا چاہتے ہیں۔',
    'مولانا محمد یوسف کندھلوی کی میراث تبلیغی جماعت کے ذریعے آج بھی قائم ہے، جو آج دنیا کی سب سے بااثر اسلامی تبلیغی تحریکوں میں سے'
        ' ایک ہے۔ اسلامی احیاء کو فروغ دینے اور ذاتی تقویٰ پر زور دینے کا ان کا کام آج بھی دنیا بھر کے مسلمانوں کو متاثر کرتا ہے۔',

  ];

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChangerProvider>(context);
    bool isLightTheme = themeChanger.isLightTheme;
    return Scaffold(
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
        title: Text('مصنف',style: TextStyle(fontSize: 30),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _authorHeadingList.length,
            itemBuilder: (BuildContext , index){
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(_authorHeadingList[index].toString(),
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,fontFamily: 'MyFont1',
                      decoration: TextDecoration.underline,),
                    textAlign: TextAlign.center,
                  ),
                  Text(_authorHeadingDescription[index].toString(),
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,fontFamily: 'MyFont1'),
                    textAlign: TextAlign.end,),
                  SizedBox(height: 10,),
                ],
              );
            }),
      )
    );
  }
}
