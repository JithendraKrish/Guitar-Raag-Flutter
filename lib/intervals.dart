import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clg_project_gtr_raag/Chords.dart';
import 'package:flutter/services.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:bottom_bar_matu/bottom_bar_double_bullet/bottom_bar_double_bullet.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:bottom_bar_matu/utils/app_utils.dart';

// import 'package:clg_project_gtr_raag/HomePage.dart';
// import 'package:clg_project_gtr_raag/inputPage.dart';

// import 'package:flutter_midi/flutter_midi.dart';


import 'Theory.dart';

void main() {  runApp(const IntPair()); }

class IntPair extends StatelessWidget {
  const IntPair({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        // useMaterial3: true,
      ),
      home: Pair(input: inputMap,),
    );
  }
}

bool tutorialIntervalState=false;
void tutorialIntervalVbleState(a){
  if (a){
    tutorialIntervalState = a;
  }
}


class Pair extends StatefulWidget {
  Pair({required this.input});
  Map input={};

  final String title = 'MusicInterval';
  @override
  State<Pair> createState() => _PairState();
}

class _PairState extends State<Pair> {


// THESE are to be given inside the widget

  final GlobalKey _IntPattern = GlobalKey();
  final GlobalKey _IntPairs_NoteSlider = GlobalKey();
  final GlobalKey _IntPairs = GlobalKey();


//MAIN OUTPUT
  // final _flutterMidi = FlutterMidi();
  int  pos = 0;
  void posVal(int a){setState(() {
    pos = a;
  });}
  // void initState(){
  //   load();
  // }

  // Future<void> load() async{ByteData _byte = await rootBundle.load('assets/audios/Guitar1.sf2');
  // _flutterMidi.prepare(sf2: _byte);}
  String pairFinder(){
    String PairResult = '';
    List tmp = TotalList;
    int len = tmp[1];
    //print(tmp);
    for(int i = 0;i<len;i++)
    {
      String a = tmp[0][pos][i][0][0];
      String b = tmp[0][pos][i][0][1];
      String c = tmp[0][pos][i][0][2];
      String d = tmp[0][pos][i][0][3];
      PairResult += '$a - $b $c $d' + '\n';

    }
    //PairResult = PairResult.substring(0,PairResult.length-1);
    return (PairResult.substring(0,PairResult.length-1));

  }
  String patternFinder(){
    String PatternResult = '';
    List tmp = TotalList;
    int len = tmp[1];
    for(int i = 0;i<len-1;i++)
    {
      String a = tmp[2][i][0][0];
      String b = tmp[2][i][0][1];
      String c = tmp[2][i][0][2];
      String d = tmp[2][i][0][3];
      PatternResult += '$a - $b $c $d' + '\n';

    }

    return (PatternResult.substring(0,PatternResult.length-1));
  }
  var TotalIntervalOnly_list = TotalList[0];
  var Interval_Name_BasedMAP = {};
  var interval_Combo = [
    'Unison\nOctave',
    'minor 2nd\nMajor 7th',
    'Major 2nd\nminor 7th',
    'minor 3rd\nMajor 6th',
    'Major 3rd\nminor 6th',
    'Perfect 4th\nPerfect 5th',
    'Tritone'
  ];

  Map intr = {
    0: 'Unison', 1: 'minor 2nd',
    2: 'Major 2nd', 3: 'minor 3rd',
    4: 'Major 3rd', 5: 'Perfect 4th',
    6: 'Tritone', 7: 'Perfect 5th',
    8: 'minor 6th', 9: 'Major 6th',
    10: 'minor 7th', 11: 'Major 7th',
  };
  Map intr2 = {
    0: 'Octave', 1: 'Major 7th',
    2: 'minor 7th', 3: 'Major 6th',
    4: 'minor 6th', 5: 'Perfect 5th',
    6: 'Tritone', 7: 'Perfect 4th',
    8: 'Major 3rd', 9: 'minor 3rd',
    10: 'Major 2nd', 11: 'minor 2nd',
  };

  void IntervalVector(){
    var Interval_Name_BasedList = [];
    for(int k =0;k<12;k++) {
      var tmp = [];
      var tmp2_Unison = [];
      for (int i = 0; i < TotalIntervalOnly_list.length; i++) {
        for (int j = i; j < TotalIntervalOnly_list[i].length; j++) {
          var sec_Note_lastVal = TotalIntervalOnly_list[i][j][0][1][(TotalIntervalOnly_list[i][j][0][1])
              .length - 1];

          if (TotalIntervalOnly_list[i][j][0][4] == 0) {
            tmp2_Unison.add(
                [TotalIntervalOnly_list[i][j][0][0],
                  TotalIntervalOnly_list[i][j][0][1]
                      + '|' +
                      TotalIntervalOnly_list[i][j][0][1],
                  TotalIntervalOnly_list[i][j][0][0]
                      + '^'
                ]);
          }
          if (TotalIntervalOnly_list[i][j][0][4] == k) {
            if (sec_Note_lastVal == '^') {
              tmp.add([
                TotalIntervalOnly_list[i][j][0][0],
                TotalIntervalOnly_list[i][j][0][1]
                    + '|' +
                    TotalIntervalOnly_list[i][j][0][1].substring(
                        0, (TotalIntervalOnly_list[i][j][0][1]).length - 1),
                TotalIntervalOnly_list[i][j][0][0]
              ]);
            }
            else {
              tmp.add([
                TotalIntervalOnly_list[i][j][0][0],
                TotalIntervalOnly_list[i][j][0][1]
                    + '|' +
                    TotalIntervalOnly_list[i][j][0][1],
                TotalIntervalOnly_list[i][j][0][0]
                    + '^'
              ]);
            }
          }
          if (TotalIntervalOnly_list[i][j][0][4] == 12 - k && k != 6) {
            if (sec_Note_lastVal == '^') {
              tmp.add([
                TotalIntervalOnly_list[i][j][0][1].substring(
                    0, (TotalIntervalOnly_list[i][j][0][1]).length - 1),
                TotalIntervalOnly_list[i][j][0][0]
                    + '|' + TotalIntervalOnly_list[i][j][0][0],
                TotalIntervalOnly_list[i][j][0][1]
              ]);
            }
            else {
              tmp.add([
                TotalIntervalOnly_list[i][j][0][1],
                TotalIntervalOnly_list[i][j][0][0]
                    + '^' + '|' + TotalIntervalOnly_list[i][j][0][0],
                TotalIntervalOnly_list[i][j][0][1]
              ]);
            }
          }
        }
      }
      if (k == 0) {
        var result4 = [];

        for(int y = 0;y<tmp2_Unison.length;y++){
          var result2 = tmp2_Unison[y].toString();
          var result3 = result2.substring(1,result2.length-1);
          result4.add(result3);
        }

        Interval_Name_BasedList.add(result4);
      }
      else {
        final nestedList = tmp;
        final jsonList = nestedList.map((list) => jsonEncode(list)).toList();
        final uniqueJsonList = jsonList.toSet().toList();
        final result = uniqueJsonList.map((json) => jsonDecode(json)).toList();
        var result4 = [];

        for(int y = 0;y<result.length;y++){
          var result2 = result[y].toString();
          var result3 = result2.substring(1,result2.length-1);
          result4.add(result3);
        }


        //THANK YOU LEO AI
        Interval_Name_BasedList.add(result4);
      }
    }

    for(int i =0;i<intr.length;i++){
      Interval_Name_BasedMAP[intr[i]]=Interval_Name_BasedList[i];
    }

  }
  // void Intervalplayer(String a)async{
  //
  //   int note = MidiNum[a];
  //
  //   _flutterMidi.playMidiNote(midi: note);
  //   Future.delayed(const Duration(milliseconds: 600),(){_flutterMidi.stopMidiNote(midi: note);});
  //
  //
  // }
  @override
  Widget build(BuildContext context) {
    IntervalVector();
    List input =  inputMap['scale'];
    // Color OverallBG = Color.fromRGBO(122, 145, 141, 1);
    // Color txtTitle = Colors.black;
    // Color txtY = Color.fromRGBO(220, 238, 209, 1);
    // Color lineColor = Color.fromRGBO(220, 238, 209, 1);
    // Color intPatCol = Colors.black;
    // final NotesSelector = ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 5) ,
    //   backgroundColor: Color.fromRGBO(161, 130, 118, 1),
    //   foregroundColor: Color.fromRGBO(220, 238, 209, 1),
    // );
    // final intPatDeco =  BoxDecoration(border: Border.all( width: 0.5, color: Colors.white, ),borderRadius: BorderRadius.circular(10.0),color:  Color.fromRGBO(220, 238, 209, 1), );
    // final intPairDeco = BoxDecoration(border: Border.all( width: 2, color: Color.fromRGBO(170, 192, 170, 1), ),borderRadius: BorderRadius.circular(10.0),color: Color.fromRGBO(115, 99, 114, 1),);






    // Color OverallBG =Color.fromRGBO(250, 250, 250, 1);
    Color OverallBG = Color.fromRGBO(255, 255, 255, 1);
    Color txtTitle = Color.fromRGBO(0,0,0,1);
    Color txtY = Color.fromRGBO(111, 111, 111, 1);
    Color lineColor = Color.fromRGBO(140, 140, 140, 1);
    Color intPatCol = Color.fromRGBO(0, 0, 0, 1);
    var NotesSelector = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15) ,
        foregroundColor: Color.fromRGBO(0,0, 0, 1),
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        elevation: 0.75,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
    var intPairTxtStyl = TextStyle(fontFamily: 'NotoSansRegular',color:  Color.fromRGBO(78, 78, 78, 1),fontSize: 16,fontWeight: FontWeight.normal);
    var noteSelectorDeco =  BoxDecoration(border: Border.all(color: Color.fromRGBO(230, 230, 230, 1),width: 2,),borderRadius: BorderRadius.circular(30.0),);
    Color backArrow = Color.fromRGBO(46, 46, 46, 1);
    var intPatDeco =  BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 5), // changes position of shadow
        ),
      ],

        border: Border.all( width: 1, color: Color.fromRGBO(11, 111, 244, 1).withOpacity(0.3),), borderRadius: BorderRadius.circular(10.0),
      color:  Color.fromRGBO(255, 255, 255, 1).withOpacity(0.9), );
    Color SwaraContainerBG = Color.fromRGBO(255, 255, 255, 1);
    Color SwarasContainerText = Color.fromRGBO(0, 0, 0, 1);
    Color SwaraContainersubText = Color.fromRGBO(0,0,0, 1);
    var SwarasContainerDeco = BoxDecoration(
      border: Border.all(width: 0.1, color: Color.fromRGBO(0, 0, 0, 1),),
      borderRadius: BorderRadius.circular(10.0),
      color: SwaraContainerBG,);
    var trans_info = Icon(Icons.info_outline_rounded, size: 12,color: Colors.transparent,);
    var coloured_info  = Icon(Icons.info_outline_rounded, size: 12,color: Color.fromRGBO(11, 111,244,1),);
    var intPairDeco = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 5,
          offset: Offset(0,2), // changes position of shadow
        ),
      ],
      border: Border.all( width: 0.5, color: Color.fromRGBO(11, 111, 244, 1).withOpacity(0.6), ),borderRadius: BorderRadius.circular(10.0),
        color: Color.fromRGBO(241,243,244, 1),
    );
    var popupMainText = TextStyle(fontFamily: 'NotoSansRegular',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(11, 111, 244, 1));
    var popupMidText = TextStyle(fontFamily: 'NotoSansMid',
        fontSize: 15,
        color: Color.fromRGBO(11, 111, 244, 1),
        height: 2.5);
    var popupNormalText = TextStyle(color: Colors.black,
        fontFamily: 'NotoSansMid', fontSize: 15, height: 1.5);
    var popupNoteText = TextStyle(color: Colors.black,
        fontFamily: 'NotoSansRegular', fontSize: 12, fontWeight: FontWeight.w100 );
    int _Bottomindex=0;
    double CT_heigh = MediaQuery.of(context).size.height*0.05;
    double CT_Fheigh = CT_heigh/2.8;
    if (tutorialIntervalState) {_createTutorialInterval();}
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    @override
    void initState() {
      super.initState();
      _createTutorialInterval();
    }
    return WillPopScope(
      onWillPop:  () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> IntPair()));
        return true; // Prevent back navigation
      },
      child: Scaffold(
        backgroundColor: OverallBG,
        appBar: AppBar(

          toolbarHeight: screenHeight*0.08,
          actions: [

            Row(
              mainAxisAlignment:MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(icon: Icon(Icons.chrome_reader_mode_outlined, size: screenHeight*0.035,),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Color.fromRGBO(240, 255, 255, 1),
                              content: Container(
                                //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child:
                                RichText(text: TextSpan(text: ' ',
                                  style: TextStyle(fontSize: 12,
                                      fontFamily: 'NotoSansMid',
                                      color: SwarasContainerText),
                                  children: <TextSpan>[
                                    TextSpan(text: 'Intervals\n',
                                        style: popupMainText),

                                    TextSpan(text: '\nThe Most basic and fundamental concept in western music is Intervals.'
                                        '\n\nIntervals are the measure of distance between 2 notes, the distance is measured in Semitones'
                                        '\n\nThis screen focuses on Interval Pattern and Interval Pairs of a Scale',
                                      style: popupNormalText,),
                                    TextSpan(text: '\n\nTo learn how this works select the \'Learn More\' option given below,',style: popupNoteText)


                                  ],),),),

                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close', style: popupMidText),
                                ),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(255, 255, 255, 1), // background color
                                  ),
                                  onPressed: () {
                                    PageCtrl = 4;
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TheoryContent()));
                                  },
                                  child: Text('Learn more', style: popupMidText),
                                ),



                              ],
                            );
                          },
                        );


                      },
                    ),
                    Container(
                      margin:EdgeInsets.symmetric(horizontal: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text('Learn',style: TextStyle(fontSize: screenHeight*0.012),),
                    ),
                  ],
                ),




                Column(
                  children: [
                    IconButton(icon: Icon(Icons.explore_outlined,
                      size: screenHeight*0.035,
                    ),
                      onPressed: () {
                        tutorialIntervalVbleState(true);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> IntPair()));
                      },),
                    Container(
                      margin:EdgeInsets.symmetric(horizontal: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text('Walkthrough',style: TextStyle(fontSize: screenHeight*0.012),),
                    ),
                  ],
                ),
              ],
            ),



          ],
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back,color:backArrow,),
          //   onPressed: () {
          //     pairOutPut = '0';patternOutPut = '0';
          //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));
          //
          //   },
          // ),
          backgroundColor: OverallBG,
          title: Text('Intervals',style: TextStyle(color: txtTitle,fontFamily: 'NotoSansMid',fontSize: screenHeight*0.03),),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),

            // Important: Remove any padding from the ListView.
            children: [
              // Container(
              //   key: _IntPattern,
              //   //decoration: BoxDecoration(border: Border.all( width: 1, color: Colors.red, ),borderRadius: BorderRadius.circular(10.0), color: Colors.grey.withOpacity(0.6), ),
              //   margin: const EdgeInsets.symmetric(horizontal: 70.0),
              //   child: Column(
              //
              //     children:[
              //     Container(margin: EdgeInsets.all(10),),
              //     Container(
              //       alignment: Alignment.center,
              //       margin: const EdgeInsets.only(top: 0.0,bottom: 5.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(Icons.info_outline, size: 25,color: Colors.transparent,),
              //           Icon(Icons.info_outline, size: 25,color: Colors.transparent,),
              //           Text('Interval Pattern',style: TextStyle( fontSize: 18,fontWeight: FontWeight.bold,color: txtY,fontFamily: 'NotoSansRegular'),),
              //           IconButton(icon: Icon(Icons.info_outline, size: 25,),
              //             onPressed: () {
              //
              //
              //
              //               showDialog(
              //                 context: context,
              //                 builder: (BuildContext context) {
              //                   return AlertDialog(
              //                     backgroundColor: Color.fromRGBO(240, 255, 255, 1),
              //                     content: Container(
              //                       //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
              //                       padding: EdgeInsets.all(10),
              //                       child:
              //
              //
              //                       RichText(text: TextSpan(text: 'CHANGE ME TO INTERVAL PATTERN, GESTURE DETETCTOR, ON_TAP POP UP\n',
              //                         style: TextStyle(fontSize: 12,
              //                             fontFamily: 'NotoSansMid',
              //                             color: SwarasContainerText),
              //                         children: <TextSpan>[
              //                           TextSpan(text: 'Interval Pattern  \n',
              //                               style: popupMainText),
              //
              //
              //                           TextSpan(text: ''
              //                               '\nWestern music has 12 unique Pitch Classes namely A, A#...G# (or) A, Bb, B…..Ab they are enharmonic, that is both Bb and A# denote the same sound frequency.'
              //                               '\n\nSimilarly in carnatic music there are 16 notes S, R1, R2…N3 S and 12 pitches. Where the Swaras R2 - G1…D2 - N3 are enharmonic…!'
              //                               '\n\nConversion: Converting the Carnatic to western vice versa is very simple..!',
              //                             style: popupNormalText,),
              //
              //
              //                         ],),),),
              //
              //                     actions: <Widget>[
              //
              //                       TextButton(
              //
              //                         onPressed: () {
              //                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TheoryContent()));
              //                         },
              //                         child: Text('Learn more', style: popupMidText),
              //                       ),
              //
              //
              //                       ElevatedButton(
              //                         style: ElevatedButton.styleFrom(
              //                           backgroundColor: Color.fromRGBO(255, 230, 230, 1), // background color
              //                         ),
              //                         onPressed: () {
              //                           Navigator.of(context).pop();
              //                         },
              //                         child: Text('Close', style: popupMidText),
              //                       ),
              //                     ],
              //                   );
              //                 },
              //               );
              //
              //
              //
              //             },
              //           ),
              //         ],
              //       ),),
              //
              //      for(int i = 0;i < (TotalList[1]-1);i++)
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //
              //         Expanded(
              //           child: Container(
              //             decoration: intPatDeco.copyWith(
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: Colors.grey.withOpacity(0.0),
              //                   spreadRadius: 0,
              //                   blurRadius: 0,
              //                   offset: Offset(-25,0), // changes position of shadow
              //                 ),
              //               ],
              //             ),
              //             alignment: Alignment.center,
              //             margin: EdgeInsets.only(top:2,bottom:2, left: 20,right: 0),
              //             padding: const EdgeInsets.symmetric(vertical: 5.0),
              //             child:
              //             Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 // Container(margin: EdgeInsets.all(1),),
              //
              //                 Text('${TotalList[2][i][0][0]}', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //                 Text('${TotalList[2][i][0][1]}', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //
              //                 //   RichText(text: TextSpan(text: '',style: DefaultTextStyle.of(context).style,
              //                 //     children: <TextSpan>[
              //                 //          TextSpan(text: '${TotalList[2][i][0][0]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //                 //          TextSpan(text: '${TotalList[2][i][0][1]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //                 //          TextSpan(text: '${TotalList[2][i][0][2]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //                 //          TextSpan(text: '${TotalList[2][i][0][3]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //                 //
              //                 //
              //                 //
              //                 //       //TotalList[2][i][0][0];
              //                 //     ],),),
              //
              //
              //
              //                 //          Text('${TotalList[2][i][0]}\n',style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14),textAlign: TextAlign.center,),
              //                 //          Text('${patternOutPut}',style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14),textAlign: TextAlign.center,),
              //
              //               ],),
              //
              //
              //           ),
              //         ),
              //         Expanded(
              //           flex: 2,
              //           child: GestureDetector(
              //             onTap: (){
              //               int note1 = MidiNum[TotalList[2][i][0][0]];
              //               _flutterMidi.playMidiNote(midi: note1);
              //               Future.delayed(const Duration(milliseconds: 500),(){_flutterMidi.stopMidiNote(midi: note1);});
              //
              //
              //               if(i == 6){
              //                 int note  = MidiNum[TotalList[2][0][0][1]]+12;
              //                 _flutterMidi.playMidiNote(midi: note);
              //                 Future.delayed(const Duration(milliseconds: 500),(){_flutterMidi.stopMidiNote(midi: note);});
              //
              //               }
              //               else{
              //                 int note2 = MidiNum[TotalList[2][i][0][1]];
              //                 _flutterMidi.playMidiNote(midi: note2);
              //                 Future.delayed(const Duration(milliseconds: 500),(){_flutterMidi.stopMidiNote(midi: note2);});}
              //
              //
              //               // print(a);
              //               // print(b);
              //
              //
              //             },
              //
              //             child: Container(
              //               decoration: intPatDeco,
              //               alignment: Alignment.center,
              //               margin: EdgeInsets.only(top:2,bottom:3, left: 15,right: 10),
              //               padding: const EdgeInsets.symmetric(vertical: 5.0),
              //               child:
              //               Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   // Container(margin: EdgeInsets.all(1),),
              //                   // Text('${TotalList[2][i][0][2]}', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //                   Text('${TotalList[2][i][0][3]}', style: TextStyle(color: Color.fromRGBO(11, 111, 244, 1),fontFamily: 'NotoSansRegular',fontSize: 14,)),
              //
              //
              //
              //                   //   RichText(text: TextSpan(text: '',style: DefaultTextStyle.of(context).style,
              //                   //     children: <TextSpan>[
              //                   //          TextSpan(text: '${TotalList[2][i][0][0]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //                   //          TextSpan(text: '${TotalList[2][i][0][1]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //                   //          TextSpan(text: '${TotalList[2][i][0][2]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //                   //          TextSpan(text: '${TotalList[2][i][0][3]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //                   //
              //                   //
              //                   //
              //                   //       //TotalList[2][i][0][0];
              //                   //     ],),),
              //
              //
              //
              //                   //          Text('${TotalList[2][i][0]}\n',style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14),textAlign: TextAlign.center,),
              //                   //          Text('${patternOutPut}',style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14),textAlign: TextAlign.center,),
              //
              //                 ],),
              //
              //
              //             ),
              //           ),
              //         ),
              //       ],),
              //
              //     ],),),


                //NEW
              Container(margin: EdgeInsets.all(0),),
              GestureDetector(
                key: _IntPattern,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color.fromRGBO(240, 255, 255, 1),
                        content: Container(
                          //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
                          padding: EdgeInsets.all(10),
                          child: RichText(text: TextSpan(text: '',children: <TextSpan>[
                              TextSpan(text: 'Interval Pattern  \n',
                                  style: popupMainText),


                              TextSpan(text: ''
                                  '\nThe notes are given in bigger font, the \'-\' represents 1 semitone, and so based on the interval the number of \'-\' is displayed'
                                  '\n\nThe numbers below represents the number of semitones that are in between the two notes.!'
                                  '\n\nInterval Pattern is a simple yet important tool in western music, The Interval patterns are used within a scale from the root to it\'s octave.'
                                  '\n\nUsing this interval pattern we can convert the pitch of the scale, since this acts like a formula of the scale, based on the different start values we can derive different scale positions.!',
                                style: popupNormalText,),
                            TextSpan(text: '\n\nTo learn how this works select the \'Learn More\' option given below,',style: popupNoteText)
                            ],),),),

                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              PageCtrl = 4;
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TheoryContent()));},
                            child: Text('Learn more', style: popupMidText),
                          ),


                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(255, 230, 230, 1), // background color
                            ),                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close', style: popupMidText),
                          ),
                        ],
                      );
                    },
                  );



                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Interval Pattern' ,style: TextStyle(fontFamily: 'NotoSansMid',color: Color.fromRGBO(11, 111, 244, 1),fontSize: screenHeight*0.028),),
                        ],
                      ),

                      Text('\n',style: TextStyle(fontSize:5 ),),

                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for(int i = 0;i < (TotalList[1]-1);i++)
                            Column(
                              children: [
                                Text('${input[i]}'+' - '*TotalList[2][i][0][4],style: TextStyle(fontFamily: 'NotoSansRegular',fontSize: 18,color: SwarasContainerText),),
                                Text(' ${TotalList[2][i][0][4]} ',style: TextStyle(fontFamily: 'NotoSansRegular',fontSize: 16,color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.normal),),
                              ],
                            ),

                          Column(
                            children: [
                              Text('${input[7]}', style: TextStyle(fontFamily: 'NotoSansRegular',fontSize: 18,color: SwarasContainerText,fontWeight: FontWeight.normal)),
                              Text(' ',style: TextStyle(fontFamily: 'NotoSansMid',fontSize: 16,color: SwarasContainerText.withOpacity(0.8),fontWeight: FontWeight.normal),),
                            ],
                          ),
                        ],),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text('numbers denote the semitones', style: TextStyle(
                  fontSize: CT_heigh/4,
                  fontFamily: 'NotoSansRegular',
                  fontWeight: FontWeight.normal,
                  color: Color.fromRGBO(0, 0, 0, .8),),),),
              // Container(margin: EdgeInsets.only(top: 20),alignment:Alignment.center, child: Text('Select any Interval Category',style: TextStyle(fontSize: 13,fontFamily: 'NotoSansRegular',color: txtY,fontWeight: FontWeight.normal),),),
              // Divider(indent: 60,endIndent: 60,height: 5 ,thickness: 1,color: lineColor,),
              // Container(
              //   key: _IntPairs_NoteSlider,
              //   margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              //   height: 50.0, // Adjust the height as needed
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: input.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return  Container(
              //         width: 60.0,
              //         height: 20.0,// Adjust the width as needed
              //         margin: EdgeInsets.symmetric(vertical: 6.0,horizontal: 6),
              //         //padding: EdgeInsets.all(8.0),
              //         decoration: noteSelectorDeco,
              //         child: ElevatedButton(style: NotesSelector,onPressed: () {
              //
              //
              //           if (index == 7){   int note1 = MidiNum[TotalList[2][0][0][0]]-12;
              //           _flutterMidi.playMidiNote(midi: note1);
              //           Future.delayed(const Duration(milliseconds: 500),(){_flutterMidi.stopMidiNote(midi: note1);});
              //           }
              //           else{
              //             int note1 = MidiNum[TotalList[2][index][0][0]]-24;
              //             _flutterMidi.playMidiNote(midi: note1);
              //             Future.delayed(const Duration(milliseconds: 500),(){_flutterMidi.stopMidiNote(midi: note1);});
              //           }
              //
              //
              //
              //           posVal(index);},child: Text(input[index],style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,fontFamily: 'NotoSansRegular'),),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              // Container(margin: EdgeInsets.all(3),),
              // Divider(thickness: 2,height: 0,indent: 20,endIndent: 20,color: lineColor,),
              // Container(
              //   margin: EdgeInsets.only(top:10),
              //
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //
              //
              //       trans_info,
              //       Text('Interval Pairs',style: TextStyle(fontSize:18,fontFamily: 'NotoSansRegular',fontWeight: FontWeight.bold,color: txtY),),
              //       IconButton(icon: coloured_info,
              //         onPressed: () {
              //           showDialog(
              //             context: context,
              //             builder: (BuildContext context) {
              //               return AlertDialog(
              //                 backgroundColor: Color.fromRGBO(240, 255, 255, 1),
              //                 content: Container(
              //                   //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
              //                   padding: EdgeInsets.symmetric(vertical: 10),
              //                   child:
              //
              //
              //                   RichText(text: TextSpan(text: ' ',
              //                     style: TextStyle(fontSize: 12,
              //                         fontFamily: 'NotoSansMid',
              //                         color: SwarasContainerText),
              //                     children: <TextSpan>[
              //                       TextSpan(text: 'Interval Pairs  \n',
              //                           style: popupMainText),
              //
              //
              //                       TextSpan(text: ''
              //                           '\nThis element helps you to find the interval between one scale note to other..!'
              //                           '\n\nOn Tapping the note above, this list of interval pairs changes and shows all the other scale notes and it\'s respective interval measures'
              //                           '\n\nThe distance from note 1 and 2 might not be the same from note 2 to 1, and that is why it is important to see the intervals from one scale note to others!',
              //                         style: popupNormalText,),
              //                       TextSpan(text: '\n\nTo learn how this works select the \'Learn More\' option given below,',style: popupNoteText)
              //
              //
              //                     ],),),),
              //
              //                 actions: <Widget>[
              //
              //                   TextButton(
              //                     onPressed: () {
              //                       PageCtrl = 4;
              //                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TheoryContent()));
              //                     },
              //                     child: Text('Learn more', style: popupMidText),
              //                   ),
              //
              //
              //                   ElevatedButton(
              //                     style: ElevatedButton.styleFrom(
              //                       backgroundColor: Color.fromRGBO(255, 230, 230, 1), // background color
              //                     ),
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     },
              //                     child: Text('Close', style: popupMidText),
              //                   ),
              //                 ],
              //               );
              //             },
              //           );
              //
              //
              //
              //         },
              //       ),
              //
              //
              //     ],
              //   ),),
              // Container(
              //   key: _IntPairs,
              //   //decoration: intPairDeco,
              //   alignment: Alignment.center,
              //   padding: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
              //   margin: const EdgeInsets.symmetric(horizontal: 50),
              //   child:
              //   Column(children: [
              //     for (int i = 0;i<(TotalList[1]);i++)
              //       GestureDetector(
              //         onTap: (){
              //
              //           if (pos == 7) {
              //             int note1 = MidiNum[TotalList[0][0][i][0][0]]+12;
              //             _flutterMidi.playMidiNote(midi: note1);
              //             Future.delayed(const Duration(milliseconds: 500),(){_flutterMidi.stopMidiNote(midi: note1);});
              //           }
              //           else{
              //             int note1 = MidiNum[TotalList[0][pos][i][0][0]];
              //             _flutterMidi.playMidiNote(midi: note1);
              //             Future.delayed(const Duration(milliseconds: 500),(){_flutterMidi.stopMidiNote(midi: note1);
              //             });
              //           }
              //
              //           if(i == 7){
              //             int note  = MidiNum[TotalList[0][0][i][0][0]]+12;
              //             _flutterMidi.playMidiNote(midi: note);
              //             Future.delayed(const Duration(milliseconds: 500),(){_flutterMidi.stopMidiNote(midi: note);});
              //
              //           }
              //           else{
              //             int note2 = MidiNum[TotalList[0][pos][i][0][1]];
              //             _flutterMidi.playMidiNote(midi: note2);
              //             Future.delayed(const Duration(milliseconds: 500),(){_flutterMidi.stopMidiNote(midi: note2);});}
              //
              //         },
              //         child: Container(
              //           decoration: intPairDeco,
              //           padding: EdgeInsets.symmetric(vertical: 5),
              //           margin: EdgeInsets.symmetric(vertical: 3),
              //
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             children: [
              //
              //
              //               Flexible(flex: 0,child: Text('\t\t\t\t', style: intPairTxtStyl),),
              //               Expanded(flex: 1,child: Text('${TotalList[0][pos][i][0][0]}\t\t - \t\t', style: intPairTxtStyl),),
              //               Expanded(flex: 1,child: Text('${TotalList[0][pos][i][0][1]}', style: intPairTxtStyl),),
              //               Expanded(flex: 1 ,child: Text('${TotalList[0][pos][i][0][2]}', style: intPairTxtStyl),),
              //               Expanded(flex: 2, child: Text('${TotalList[0][pos][i][0][3]}', style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold),),),
              //
              //
              //
              //               //Container(margin: EdgeInsets.symmetric(horizontal: 10),),
              //               //Container(margin: EdgeInsets.all(10),),
              //               //   RichText(text: TextSpan(text: '',style: DefaultTextStyle.of(context).style,
              //               //     children: <TextSpan>[
              //               //          TextSpan(text: '${TotalList[2][i][0][0]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //               //          TextSpan(text: '${TotalList[2][i][0][1]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //               //          TextSpan(text: '${TotalList[2][i][0][2]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //               //          TextSpan(text: '${TotalList[2][i][0][3]} ', style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14)),
              //               //
              //               //
              //               //
              //               //       //TotalList[2][i][0][0];
              //               //     ],),),
              //
              //
              //
              //               //          Text('${TotalList[2][i][0]}\n',style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14),textAlign: TextAlign.center,),
              //               //          Text('${patternOutPut}',style: TextStyle(color: intPatCol,fontFamily: 'NotoSansRegular',fontSize: 14),textAlign: TextAlign.center,),
              //
              //             ],),
              //         ),
              //       ),
              //
              //   ],),
              //   //Text('$pairOutPut',style: intPairTxtStyl),
              // ),
              // Container(margin: EdgeInsets.all(20),),
              // Container(margin: EdgeInsets.only(top: 10),),
              Container(margin: EdgeInsets.all(10),),
              Container(
                key: _IntPairs_NoteSlider,
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 2),
                height: 80.0, // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: interval_Combo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  Container(
                      decoration: SwarasContainerDeco,
                      height: 80.0,// Adjust the width as needed
                      margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 8),
                      child: ElevatedButton(
                        style: NotesSelector,
                        onPressed: () {posVal(index);},
                        child: Text(interval_Combo[index],style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,fontFamily: 'NotoSansRegular'),),
                      ),
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Select Interval Combo', style: TextStyle(
                  fontSize: CT_heigh/4,
                  fontFamily: 'NotoSansRegular',
                  fontWeight: FontWeight.normal,
                  color: Color.fromRGBO(0, 0, 0, 1),),),),
              // Container(margin: EdgeInsets.only(top: 2),alignment:Alignment.center, child: Text('Select Interval Combo',style: TextStyle(fontSize: 13,fontFamily: 'NotoSansRegular',color: txtY,fontWeight: FontWeight.normal),),),
              // Divider(thickness: 2,height: 0,indent: 20,endIndent: 20,color: lineColor,),
              Divider(height: 10, indent: 20, endIndent: 20,thickness: 0.5, color: lineColor,),
              Container(
                margin: EdgeInsets.only(top:20,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text('Intervals in the Raag',style: TextStyle(fontSize:screenHeight*0.028,fontFamily: 'NotoSansMid',color: Color.fromRGBO(11, 111, 244, 1)),),
                    // IconButton(icon: coloured_info,
                    //   onPressed: () {
                    //   showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //         backgroundColor: Color.fromRGBO(240, 255, 255, 1),
                    //         content: Container(
                    //           //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
                    //           padding: EdgeInsets.symmetric(vertical: 10),
                    //           child:
                    //
                    //
                    //           RichText(text: TextSpan(text: ' ',
                    //             style: TextStyle(fontSize: 12,
                    //                 fontFamily: 'NotoSansMid',
                    //                 color: SwarasContainerText),
                    //             children: <TextSpan>[
                    //               TextSpan(text: 'Interval Pairs  \n',
                    //                   style: popupMainText),
                    //
                    //
                    //               TextSpan(text: ''
                    //                   '\nThis element helps you to find the interval between one scale note to other..!'
                    //                   '\n\nOn Tapping the note above, this list of interval pairs changes and shows all the other scale notes and it\'s respective interval measures'
                    //                   '\n\nThe distance from note 1 and 2 might not be the same from note 2 to 1, and that is why it is important to see the intervals from one scale note to others!',
                    //                 style: popupNormalText,),
                    //               TextSpan(text: '\n\nTo learn how this works select the \'Learn More\' option given below,',style: popupNoteText)
                    //
                    //
                    //             ],),),),
                    //
                    //         actions: <Widget>[
                    //
                    //           TextButton(
                    //             onPressed: () {
                    //               PageCtrl = 4;
                    //               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TheoryContent()));
                    //             },
                    //             child: Text('Learn more', style: popupMidText),
                    //           ),
                    //
                    //
                    //           ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //               backgroundColor: Color.fromRGBO(255, 230, 230, 1), // background color
                    //             ),
                    //             onPressed: () {
                    //               Navigator.of(context).pop();
                    //             },
                    //             child: Text('Close', style: popupMidText),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   );
                    //
                    //
                    //
                    // },
                    // ),

                  ],
                ),),
              Container(
                key: _IntPairs,
                //decoration: intPairDeco,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Column(children: [
                        for (int i = 0;i<(Interval_Name_BasedMAP[intr[pos]].length);i++)
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 2,),
                            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text((Interval_Name_BasedMAP[intr[pos]][i]).toString(), style: intPairTxtStyl,),
                                // Text((Interval_Name_BasedMAP[intr[pos]][i][0]).toString(), style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold),),
                                // Text(' , ',style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold)),
                                // Text((Interval_Name_BasedMAP[intr[pos]][i][1]).toString(), style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold),),
                                //
                                // Container(margin: EdgeInsets.symmetric(horizontal: 20,vertical: 0),child: Text('|'),),
                                //
                                // Text((Interval_Name_BasedMAP[intr[pos]][i][1]).toString(), style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold),),
                                // Text(' , ',style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold)),
                                // Text((Interval_Name_BasedMAP[intr[pos]][i][0]).toString(), style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold),),
                                // Text('^',style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold)),

                              ],
                            ),
                          ),

                        Container(margin: EdgeInsets.all(10),),
                      ],),
                    ],),
                //Text('$pairOutPut',style: intPairTxtStyl),
                ),
              // Container(
              //   //decoration: intPairDeco,
              //   alignment: Alignment.center,
              //   padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
              //   child:Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //         Column(children: [
              //             Container(
              //               alignment: Alignment.center,
              //               padding: EdgeInsets.symmetric(vertical: 8,),
              //               margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              //               child:Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                 children: [
              //                   // Text('^',style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold)),
              //                   Text((Interval_Name_BasedMAP2[intr[pos]][0]).toString(), style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold),),
              //                   Text(' , ',style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold)),
              //                   Text((Interval_Name_BasedMAP2[intr[pos]][1]).toString(), style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold),),
              //
              //
              //                   Container(margin: EdgeInsets.symmetric(horizontal: 20,vertical: 0),child: Text('|'),),
              //
              //                   Text((Interval_Name_BasedMAP2[intr[pos]][1]).toString(), style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold),),
              //                   Text(' , ',style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold)),
              //                   Text((Interval_Name_BasedMAP2[intr[pos]][0]).toString(), style: intPairTxtStyl.copyWith(fontWeight: FontWeight.bold),),
              //
              //
              //                 ],
              //               ),
              //             ),
              //
              //           Container(margin: EdgeInsets.all(10),),
              //         ],),
              //       ],),
              //   //Text('$pairOutPut',style: intPairTxtStyl),
              //   ),
              Container(
                alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(intr[pos],style: intPairTxtStyl.copyWith(fontWeight: FontWeight.w300,color: Colors.black)),
                      Container(margin: EdgeInsets.all(20),),
                      Text(intr2[pos],style: intPairTxtStyl.copyWith(fontWeight: FontWeight.w300,color: Colors.black)),
                    ],
                  )),
              Container(margin: EdgeInsets.all(20),)

            ],
          ),
        ),
      ),
    );
  }

  void _createTutorialInterval() {
    var HeadingTextStyle =  TextStyle(fontSize: 28,fontFamily: 'NotoSansRegular',color: Colors.white,fontWeight: FontWeight.bold);
    var ImportantNormal = TextStyle(fontFamily: 'NotoSansMid',fontSize: 16,color: Color.fromRGBO(255, 255, 255, 1));
    var normalTextStyle = TextStyle(fontWeight: FontWeight.w200,fontFamily: 'NotoSansMid',fontSize: 16,color: Color.fromRGBO(180, 180, 180, 1));
    var padding_TargetContainer = EdgeInsets.symmetric(horizontal: 10,vertical: 10);

    var boxDecoration_TargetContainer =  BoxDecoration(border: Border.all(color: Color.fromRGBO(11, 111, 244, 1), width: 2.0),);
    double rad = 20;

    final targets = [
      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'IntScreen Int Pattern',
        keyTarget: _IntPattern,
        //alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align:ContentAlign.bottom,
              builder:(context,controller)=>
                  Container(
                    decoration: boxDecoration_TargetContainer,
                    padding: padding_TargetContainer,
                    child: RichText(text:
                    TextSpan(text: 'Interval Pattern',style: HeadingTextStyle,children: <TextSpan>[
                      TextSpan(text: '\n\nThis area shows the Interval pattern of the selected Raaga. The',style:normalTextStyle),
                      TextSpan(text: ' numbers',style: ImportantNormal),
                      TextSpan(text:'  given below represent the number of',style:normalTextStyle),
                      TextSpan(text: ' semitones',style: ImportantNormal),
                      TextSpan(text:' in beteween each note.\n\nTo learn more about this, tap on the info button, given inside the box',style:normalTextStyle),
                    ],),),
                  )
          ),
        ],
      ),
      //Raag Input Screen 1
      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'IntScreen Note Slider',
        keyTarget: _IntPairs_NoteSlider,
        //alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align:ContentAlign.bottom,
              builder:(context,controller)=>
                  Container(
                    decoration: boxDecoration_TargetContainer,
                    padding: padding_TargetContainer,
                    child: RichText(text:
                    TextSpan(text: 'Interval Slider',style: HeadingTextStyle,children: <TextSpan>[
                      TextSpan(text: '\n\nThis Slider allows you to select a Interval combo from the scale, so that you can see the',style:normalTextStyle),
                      TextSpan(text: ' Intervals',style: ImportantNormal),
                      TextSpan(text: ' of that category, from that selected Raaga.',style:normalTextStyle),

                    ],),),
                  )
          ),
        ],
      ),



      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'IntScreen Int Pairs',
        keyTarget: _IntPairs,
        //alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align:ContentAlign.top,
              builder:(context,controller)=>
                  Container(
                    padding: padding_TargetContainer,
                    decoration: boxDecoration_TargetContainer,
                    child: RichText(text:
                    TextSpan(text: 'Interval withing the Raaga',style: HeadingTextStyle,children: <TextSpan>[
                      TextSpan(text: '\n\nThe Interval within a raaga is classified in various categories.!.',style:normalTextStyle),
                      TextSpan(text:'\n\nOn selecting that category, all the intervals within the raaga that has the interval will show.',style:normalTextStyle),

                    ],),),
                  )


          ),
        ],
      ),
      // Raag Input Screen 2


    ];
    final tutorial = TutorialCoachMark(
      targets: targets,
      hideSkip: false,
      opacityShadow: 0.93,
      paddingFocus: 10,
      focusAnimationDuration: Duration(milliseconds: 300),
      unFocusAnimationDuration: Duration(milliseconds: 300),
      pulseAnimationDuration: Duration(milliseconds: 300),
    );
    Future.delayed(const Duration(milliseconds: 500),(){
      tutorial.show(context: context);});
    tutorialIntervalState=false;}
}

