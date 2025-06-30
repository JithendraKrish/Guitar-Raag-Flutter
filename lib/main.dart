import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:clg_project_gtr_raag/Theory.dart';
import 'package:clg_project_gtr_raag/intervals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:clg_project_gtr_raag/Chords.dart';
import 'package:clg_project_gtr_raag/inputPage.dart';
import 'package:clg_project_gtr_raag/HomePage.dart';
// import 'package:flutter_midi/flutter_midi.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(MainApp(showHome:showHome));
}

 // final _flutterMidi = FlutterMidi();




class MainApp extends StatelessWidget {

  final bool showHome;
  const MainApp({super.key,required this.showHome});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        title: 'About the Dev',
        home: showHome? HomeApp(): OnBoarding(),
        //home: HomeApp(),
      // const MyAbt(title: 'Gtr Raag'),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black45),
        useMaterial3: true,
      ),
    );
  }
}

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}
class _OnBoardingState extends State<OnBoarding> {



  bool colVal = true;
  Color Easter = Colors.transparent;
  double EasterImage = 0.0;
  @override
  Widget build(BuildContext context) {
    String output2 ='';
    var boxDecoration = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 5), // changes position of shadow
        ),
      ],
      border: Border.all( width: 0.5, color: Color.fromRGBO(46, 46,46, 1), ),
      borderRadius: BorderRadius.circular(10.0),
      color: Color.fromRGBO(241,243,244, 1), );


    var screen2_box_title =  TextStyle( color: Color.fromRGBO(11, 111, 244,1),fontSize: 20,fontFamily: 'NotoSansRegular',);
    var screen2_box_text =   TextStyle( color: Colors.black, fontSize: 14,fontWeight: FontWeight.w300,);

    var HeadingTextStyle =  TextStyle(fontSize: 28,fontFamily: 'NotoSansRegular',color: Colors.white,fontWeight: FontWeight.bold);
    var ImportantNormal =   TextStyle(color: Color.fromRGBO(11, 111,244,1),fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'NotoSansRegular');
    var normalTextStyle =  TextStyle( color: Colors.black,fontSize: 18,fontWeight: FontWeight.w300);



    final screenControl = PageController(initialPage: 0);

    @override
    void dispose(){
      screenControl.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: [
            Container(
              alignment:Alignment.topLeft,
              margin: const EdgeInsets.only(top:0.0,),
              child: Row(children: [
                //Container(child: Image(image: AssetImage('assets/images/CLGLOGO.jpg'),color: Colors.transparent.withOpacity(0.2),),),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Text('Temple of Fine Arts \nCoimbatore!',style: TextStyle( color: Easter,fontSize: 24,fontFamily: 'NotoSans_Normal',fontWeight: FontWeight.w600,),),
                ),
              ],),
            ),


            Container(
              decoration: boxDecoration,
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 30,left: 30,top: 10),
                    alignment: Alignment.center,
                    child: TextButton(
                      child:Text('Welcome!',style:
                       TextStyle( color: Color.fromRGBO(11, 111, 244,1),fontSize: 32,fontFamily: 'NotoSansMid',)),
                      onPressed: (){
                        if (colVal == true){setState(() {Easter = Colors.black;colVal = !colVal;});}
                        else {setState((){Easter = Colors.transparent;colVal = !colVal;});}
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(left: 5.0,bottom: 0),
                    padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 20),
                    alignment: Alignment.center,
                    child: RichText(text: TextSpan(text: '',
                      children: <TextSpan>[

                            TextSpan(text: 'Find chords, learn theory and play music\n\nWelcome to Guitar Raag, the go-to resource for ',style: normalTextStyle),
                            TextSpan(text: 'learning and calculating ',style: normalTextStyle.copyWith(color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.w500)),
                            TextSpan(text:'Family of Chords. \n\nWhether you\'re writing, practicing, or simply wondering about how chords operate within Melakarta Raagas, this application will help you identify',style: normalTextStyle,),
                            TextSpan(text: ' Family of chords for melakarta raagas',style: normalTextStyle.copyWith(color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.w500)),
                            TextSpan(text:' in seconds and learn the concepts behind it as well.',style: normalTextStyle,),
                            TextSpan(text:'\n\nThis app is free for everyone and it was created as an ',style: normalTextStyle,),
                            TextSpan(text: ' open-source project ',style: normalTextStyle.copyWith(color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.w500)),
                            TextSpan(text:'( the source code of the project is available for everyone at the GitHub repository); you are welcome to help improve it.'
                          ,style: normalTextStyle,),
                      ],),),
                    //decoration: BoxDecoration( border: Border.all( width: 5, color: Colors.white, ), ),//DEBUGGING
                  ),
                ],
              ),
            ),

            Container(
              alignment:Alignment.center,

              //padding: EdgeInsets.only(top:50.0),
              child: Column(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 80.0),
                  alignment: Alignment.topLeft,
                  child: Text('\nDeveloped By:',style: TextStyle( color: Easter,fontSize: 13,fontFamily: 'NotoSans_Normal'),),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 70.0),
                  alignment: Alignment.topRight,
                  child: Text('a student from, WESTERN DEPARTMENT',style: TextStyle( color: Easter,fontSize: 11,fontFamily: 'NotoSans_Normal',),),
                ),
              ],),
            ),

            GestureDetector(
              onTap: (){screenControl.animateToPage(1, duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
              onDoubleTap: (){screenControl.animateToPage(1, duration:Duration(milliseconds: 250), curve: Curves.easeIn);},
              onLongPress: (){screenControl.animateToPage(1, duration:Duration(milliseconds: 5000), curve: Curves.easeIn);},
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(11,111, 244, 1)),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('showHome',true);
                            tutorialState(true);
                            tutorialModalState(true);
                            tutorialInputState(true);
                            tutorialIntervalVbleState(true);
                            tutorialChordVbleState(true);

                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));
                            //Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeApp()));

                          },
                          // screenControl.animateToPage(1, duration:Duration(milliseconds: 500), curve: Curves.easeIn);},

                          child: Text('Proceed',style: TextStyle(fontSize: 18, fontFamily: 'NotoSansMid',fontWeight: FontWeight.w600 ,color: Color.fromRGBO(255, 255, 255, 1)),))),

                  Container(margin: EdgeInsets.all(10),)
                ],
              ),
            ),



          ],
        ),
      ),


    );
  }
}