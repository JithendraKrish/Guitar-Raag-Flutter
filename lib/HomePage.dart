
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:bottom_bar_matu/bottom_bar_double_bullet/bottom_bar_double_bullet.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:clg_project_gtr_raag/About.dart';
import 'package:clg_project_gtr_raag/FretBoard.dart';
import 'package:clg_project_gtr_raag/Theory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'main.dart';

import 'package:clg_project_gtr_raag/Chords.dart';
import 'package:clg_project_gtr_raag/intervals.dart';
import 'package:clg_project_gtr_raag/inputPage.dart';
import 'package:clg_project_gtr_raag/RaagDict.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';


void main(){
  runApp(HomeApp());
}



bool tutorialVble = false;
void tutorialState(a){
  if (a){
    tutorialVble = a;
  }
}


bool tutorialModalVble = false;
void tutorialModalState(a){
  if (a){
    tutorialModalVble = a;
  }
}


class HomeApp extends StatelessWidget {

  const HomeApp({super.key});
  // This widget is the root of your application.s
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyAbt(title: 'Home Page'),
      title: 'Home Screeen',
      // theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),useMaterial3: true,),
    );
  }
}

List <bool> setNotes(r){  List <bool> a = RaagaLib['Keeravani'];  return a;}
bool star = true;
List swaraInput = [];

int CHORD_SIZE=3;

String RaagamName = 'Keeravani';
Map inputMap = {
  'notes':  setNotes('RaagamName'), 'scale': ['A', 'B', 'C', 'D', 'E', 'F', 'G#', 'A^']};
var carnatic_swaras = {0:'S',1:'R1',2:'R2',3:'R3',
  4:'G1',5:'G2',6:'G3',7:'M1',8:'M2',
  9:'P',10:'D1',11:'D2',12:'D3',13:'N1',
  14:'N2',15:'N3',16:'S^'};
Map western_swaras ={
  0:'A',1:'A#',2:'B',3:'C',4:'C#',5:'D',6:'D#',7:'E',8:'F',9:'F#',10:'G',11:'G#',12:'A^'};
Map MidiNum={
  'A':57,'S':57,
  'A#':58,'R1':58,
  'B':59,'R2 | G1':59,
  'C':60,'R3 | G2':60,
  'C#':61,'G3':61,
  'D':62,'M1':62,
  'D#':63,'M2':63,
  'E':64,'P':64,
  'F':65,'D1':65,
  'F#':66,'D2 | N1':66,
  'G':67,'D3 | N2':67,
  'G#':68,'N3':68,    };
List IntervalCalculator(inputMap) {
  List n = inputMap['scale'];
  List l = inputMap['notes'];
  List TotalIntervalList = [];
  List PatternList=[];
  List PairList=[];
  Map intr = {
    0: 'Unison', 1: 'minor 2nd',
    2: 'Major 2nd', 3: 'minor 3rd',
    4: 'Major 3rd', 5: 'Perfect 4th',
    6: 'Tritone', 7: 'Perfect 5th',
    8: 'minor 6th', 9: 'Major 6th',
    10: 'minor 7th', 11: 'Major 7th',
    12: 'Octave'
  };
  List tmp2 = [];
  for (int i = 0; i < l.length; i++) {
    for (int j = 0; j < l.length; j++) {
      int diff = (l[i] - l[j]).abs();
      List tmp = [];
      tmp.add([n[i], n[j], '=', intr[diff],diff]);
//      print(tmp);
      tmp2.add(tmp);
      if (i - j == -1) {
        PatternList.add(tmp);
      }
      if (i == 0) {
        PairList.add(tmp);
      }
    }
    TotalIntervalList.add(tmp2);
    tmp2 = [];
  }
  //print(TotalIntervalList[0][2]);
  tmp2 = [TotalIntervalList, l.length, PatternList, PairList, n,l];
  return tmp2;
}
// List FamChordCalculator(chd_size) {
//   List Tl = TotalList;
//   List chordList = [];
//   List tmp = [];
//   List tmp2 = [];
//   // List IntrCombo = [];
//   // List NoteCombo = [];
//   int l = Tl[1];
//   List input = Tl[4];
//   String  Last_char = input[l - 1];
//   //if (input[l - 1] == 'S^' || Last_char.substring((Last_char.length)-1) == '^') {
//   if (Last_char.substring((Last_char.length)-1) == '^') {
//     List dummy = [];
//     for(int o=0;o<l-1;o++){
//       dummy.add(input[o]);
//     }
//     l = l - 1;
//     input=dummy;
//   }
//
//
// //returns One Chord At a time
//   List NoteFinder(chd_size, swara_idx) {
//     int counter = 0;
//     tmp2 = [];
//     for (int j = swara_idx; counter < chd_size; j += 2) {
//       if(counter==chd_size){break;}
//       //print('NOTEFINDER()'+'$j'+'$swara_idx'+'$counter');
//       j=j%l;
//       tmp.add(input[j]);
//       tmp2.add(j);
//       counter++;
//     }
//
//     return [tmp, tmp2];
//
//
//   }
// //Returns The Interval from TotalList
//   List IntrFinder(List one_single_chd_idx) {
//     List b = one_single_chd_idx;
//     List temp=[];
//     String mapKey = '';
//     List temp2=[];
//     for(int k=0;k<b.length;k++){
//       int a =b[k];
//       int c = (k+1)%b.length;
//       int d = b[c];
//       //int tempu = b[0];
//       if(d==0){d=(l);}
//       // temp.add(a);//optionn1 for debugging
//       // temp.add(d);//option 1 //THat if line below is the actual option
//       if(a!<=8||c!<=8) { temp = [Tl[0][a][d][0][4]];
//       }
//       if(d<a){temp = [(12-temp[0]).abs()];}
//       int dumb = temp[0];
//       mapKey+='$dumb';
//       temp2.add(temp);
//       temp=[];
//     }
//     temp2.add([mapKey]);
//
//     return temp2;
//   }
//   if (l! >= 5) {
//     List a = [];
//     List b = [];
//     for (int i = 0; i < l; i++) {
//       if(i==l){break;}
//       tmp = NoteFinder(chd_size, i); //1st Arg, chd_size, 2nd Arguement is swara Idx
//       a = tmp[0];
//       b = IntrFinder(tmp[1]);
//       tmp = [];
//       tmp.add(a);
//       tmp.add(b);
//       // NoteCombo.add(a);
//       // IntrCombo.add(b);
//       chordList.add(tmp);
//       a=[];
//       b=[];
//       tmp = [];
//     }
//   }
//   else { chordList = ['Kindly Enter the Raaga That has More than 4 Swaras']; }
//   return chordList;
// }
myMapper(String a){
  Map op = {};
  List Swaras=['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'];
  int index = Swaras.indexOf(a);
  for(int i = 0;i<12;i++){op[i]=Swaras[(index+i)%12];}
  op[12] = a+'^';
  return op;

}
List Scale = [];
List Fretter(List a){

  List Frets = [];
  Map GtrFretOpens = {'[6, 0]':'E','[5, 0]':'A','[4, 0]':'D','[3, 0]':'G','[2, 0]':'B','[1, 0]':'E'};
  Map WholeGTRmap = {};
  for(int j = 6;j>0;j--){
    List tmp = [];
    for (int i = 0;i<13;i++){tmp.add([j,i]);
    }
    Frets.add(tmp);
  }



  for(int j = 0;j<6;j++){//the 6 is Responsible for Number of Strings
    var OpenNote = GtrFretOpens[(Frets[j][0]).toString()];
    List Swaras=['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'];
    int index = Swaras.indexOf(OpenNote);
    for(int i = 0;i<12;i++){WholeGTRmap[(Frets[j][i]).toString()]=Swaras[(index+i)%12];}
  }
  List keys = [];
  List positions=[];

  for(int i=0;i<a.length-1;i++){//length-1 coz of octave
    List tmp = [];
    List tmp2= [];
    //tmp.add(a[i]);
    WholeGTRmap.forEach((key, value) {
      if (value == a[i]){
        tmp.add(key);
        List<dynamic> list = jsonDecode(key); // Convert string to list
        // int Str = int.parse(key[1]);
        // int fre = int.parse(key[4]);
        tmp2.add(list);  }
    }
    );
    positions.add(tmp2);
    keys.add(tmp);
  }


  List dummy = [];
  List Root = [positions[0][0][0] ,positions[0][0][1]];
  int string = positions[0][0][0];
  int RootFret = positions[0][0][1];
  int e = (Root[0])%6;
  List octave =[];
  octave = positions[0][2];
  print(octave);

  for(int i = 0;i<positions.length;i++){
    List chumma =positions[i];

    for(int j = 0;j<chumma.length;j++){
//&&chumma[j][0]<string
      if (chumma[j][1] - RootFret < 5&&chumma[j][1] - RootFret >=-2&&chumma[j][1]!=0){
        dummy.add(chumma[j]);
        break;
      }
    }
  }
  dummy.add(positions[0][2]);


  Scale = dummy;
  return positions;
}
List input =  inputMap['scale'];
var res = Fretter(input);
Map myMidiMapper(String a){
  List Pitches=['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'];
  Map MidiVals={
    'A':57,'S':57,
    'A#':58,'R1':58,
    'B':59,'R2 | G1':59,
    'C':60,'R3 | G2':60,
    'C#':61,'G3':61,
    'D':62,'M1':62,
    'D#':63,'M2':63,
    'E':64,'P':64,
    'F':65,'D1':65,
    'F#':66,'D2 | N1':66,
    'G':67,'D3 | N2':67,
    'G#':68,'N3':68,    };
  Map midiDict = {};

  int index = Pitches.indexOf(a);
  for(int i = 0; i<12;i++){
    midiDict[Pitches[(index+i)%12]] = ((MidiVals[a])+i);
    midiDict[carnatic_swaras[i]] = ((MidiVals[a])+i);
  }
  return midiDict;

}
int CurrPage = 0;

final PageController pgCtrl = PageController(initialPage:0);


//void setPGCtrl(int a){setState(() {CurrPage = a;print('$CurrPage'+'a');});}

final GlobalKey _title = GlobalKey();
final GlobalKey _CarnaticSwaras = GlobalKey();
final GlobalKey _CurrentRaag = GlobalKey();
final GlobalKey _CurrentRaagScreen = GlobalKey();
final GlobalKey _CurrentRaagChakraScreen = GlobalKey();
final GlobalKey _WesternNotes = GlobalKey();
final GlobalKey _PitchSelector = GlobalKey();
final GlobalKey _mainButtons = GlobalKey();



class MyAbt extends StatefulWidget {
  const MyAbt({super.key, required this.title});
  final String title;
  @override
  State<MyAbt> createState() => _MyAbtState();
}
class _MyAbtState extends State<MyAbt> {

  // void setRaagam(List a, swaras) {
  //   setState(() {
  //     inputMap = inputToNotes(a, swaras);
  //   });
  // }
  // void setRaagamName(String a) {setState(() {
  //     RaagamName = a;
  //   });
  // }
  // void setCarnatic(List a) {
  //   String state2 = ' ';
  //   String state3 = ' ';
  //   String state9 = ' ';
  //   String state10 = ' ';
  //   if (a[2] == true) {
  //     state2 = 'R2';
  //   }
  //   if (a[4] == true) {
  //     state2 = 'G1';
  //   }
  //   if (a[3] == true) {
  //     state3 = 'R3';
  //   }
  //   if (a[5] == true) {
  //     state3 = 'G2';
  //   }
  //   if (a[11] == true) {
  //     state9 = 'D2';
  //   }
  //   if (a[13] == true) {
  //     state9 = 'N1';
  //   }
  //   if (a[12] == true) {
  //     state10 = 'D3';
  //   }
  //   if (a[14] == true) {
  //     state10 = 'N2';
  //   }
  //
  //   if (state2 == ' ') {
  //     state2 = 'R2';
  //   }
  //   if (state3 == ' ') {
  //     state3 = 'G2';
  //   }
  //   if (state9 == ' ') {
  //     state9 = 'D2';
  //   }
  //   if (state10 == ' ') {
  //     state10 = 'N2';
  //   }
  //
  //
  //   var swar = {
  //     0: 'S',
  //     1: 'R1',
  //     2: state2,
  //     3: state3,
  //     4: 'G3',
  //     5: 'M1',
  //     6: 'M2',
  //     7: 'P',
  //     8: 'D1',
  //     9: state9,
  //     10: state10,
  //     11: 'N3',
  //     12: 'S^'
  //   };
  //   setState(() {
  //     carnatic_swaras = swar;
  //   });
  // }
  // List<bool> nomenCletureList(List a) {
  //   List <bool> returner = [
  //     a[0],
  //     a[1],
  //     false,
  //     false,
  //     a[6],
  //     a[7],
  //     a[8],
  //     a[9],
  //     a[10],
  //     false,
  //     false,
  //     a[15],
  //     a[16]
  //   ];
  //   //print(a);
  //   if (a[2] == true || a[4] == true) {
  //     returner[2] = true;
  //   }
  //   if (a[3] == true || a[5] == true) {
  //     returner[3] = true;
  //   }
  //
  //   if (a[11] == true || a[13] == true) {
  //     returner[9] = true;
  //   }
  //   if (a[12] == true || a[14] == true) {
  //     returner[10] = true;
  //   }
  //
  //   //print(returner);
  //   return returner;
  // }
  // Map inputToNotes(l, swaras) {    // print('INPUT TEST');
  //   // print(l);
  //   List a = [];
  //   List b = [];
  //   if (l.runtimeType == List<bool>) {
  //     setCarnatic(l);
  //     List n12 = nomenCletureList(l);
  //     //print(n12);
  //     for (int i = 0; i < 13; i++) {
  //       if (n12[i] == true) {
  //         a.add(i);
  //         b.add(swaras[i]);
  //       } //if
  //     } //for
  //   }
  //
  //   else {
  //     for (int i = 0; i < l.length; i++) {
  //       a.add(l[i]);
  //       b.add(swaras[l[i]]);
  //     }
  //   }
  //   // print('\n\nSWAR DICT');
  //   // print(carnatic_swaras);
  //   // print({'notes':a,'scale':b});
  //   return {'notes': a, 'scale': b};
  // } //Function end
  // String Raaga = ' ';
  // Future<void> ReadFromFile() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/Scales.txt');
  //   //print('${directory.path}/Scales.txt');
  //   if (!await file.exists()) {
  //     Raaga = ' ';
  //   }
  //   else {
  //     Raaga = await file.readAsStringSync();
  //   }
  // }
  // Future<String> defaultRaagSet()async{
  //
  //   if (Raaga.length==0){
  //     print(Raaga);
  //     return 'Keeravani';
  //   }else{
  //     print(Raaga);
  //     String ragaName = Raaga;
  //     setRaagam(RaagaLib['$ragaName'],western_swaras);
  //     setRaagamName(Raaga);
  //     return Raaga;   }
  // }
  //
  // Future<void> writeToFile(String content) async {
  //   final filepath = '${(await getApplicationDocumentsDirectory()).path}/Scales.txt';
  //   final file = File(filepath);
  //   bool value = false;
  //   if (!await file.exists()) {await file.writeAsString('$content'+'\n');}
  //   else {
  //     String fileContent = file.readAsStringSync();
  //     for(int i = 0; i<fileContent.length;i++){
  //       String a = '$content';
  //       // var h = utf8.decode(utf8.encode(fileContent[i]));
  //       // print(h.runtimeType);
  //       //
  //       // print(fileContent[i]+'File');
  //       // print(fileContent[i].runtimeType);
  //       // print(a);
  //       // print(a.runtimeType);
  //       if(fileContent[i] == a){value =( a == fileContent[i]);}
  //     }
  //     if(!value){await file.writeAsString('$content'+'\n', mode: FileMode.write);}
  //     else{print('Already There');}
  //   }
  // }
  // //data/user/0/com.collegegtrraag.clg_project_gtr_raag/app_flutter/Scales.txt
  // void myFileWriter(String a) async {
  //   final filepath = '${(await getApplicationDocumentsDirectory()).path}/Scales.txt';
  //   final file = File(filepath);
  //   print(filepath);
  //   file.writeAsString(a,mode: FileMode.write);
  //   }
  // bool selected = false;
  // bool FretBoardselected = false;
  int _Bottomindex=1;

  @override
  Widget build(BuildContext context) {

    // defaultRaagSet();


    // List Pitches = [
    //   'A',
    //   'A#',
    //   'B',
    //   'C',
    //   'C#',
    //   'D',
    //   'D#',
    //   'E',
    //   'F',
    //   'F#',
    //   'G',
    //   'G#'
    // ];
    // void setPitch(String a) {
    //   setState(() {
    //     western_swaras = myMapper(a);
    //     MidiNum = myMidiMapper(a);
    //   });
    // }
    // List chakras = [
    //   'Indu', 'Nethra', 'Agni', 'Veda', 'Bhana', 'Ruthu',
    //   'Rishi', 'Vasu', 'Brahma', 'Dishi', 'Rudra', 'Adithya'
    // ];
    // ReadFromFile();

    // if (swaraInput.length != 0) {
    //
    //   setRaagam(swaraInput, carnatic_swaras);
    //   swaraInput = [];
    // }

    // inputMap = inputToNotes(inputMap['notes'], western_swaras);
    // String ragam = '${inputMap['scale']}';
    // Map input2 = inputToNotes(inputMap['notes'], carnatic_swaras);
    // String ragam2 = '${input2['scale']}';

    //setPitch(Pitches[0]);

    //FUNCTIONS list Dynammic
    //Input to NOTES or MAIN input must be list of BOOLS

    // TotalList = IntervalCalculator(inputMap); //TOTALLIST DECLARATION
    // FamChdList = FamChordCalculator(CHORD_SIZE);


    //
    //
    // Color OverallbackGround =Color.fromRGBO(50, 50, 50, 1);
    // Color txtTitle = Color.fromRGBO(11, 111, 244,1);
    // Color SwaraContainerBG = Color.fromRGBO(40,40,40, 1);
    // Color SwarasContainerText = Color.fromRGBO(250,250,250, 1);
    // Color SwaraContainersubText =Color.fromRGBO(200, 200, 200, 1);
    // var SwarasContainerDeco = BoxDecoration(
    //   boxShadow: [
    //     BoxShadow(
    //       color: Colors.grey.withOpacity(0.2),
    //       spreadRadius: 2,
    //       blurRadius: 5,
    //       offset: Offset(0, 5), // changes position of shadow
    //     ),
    //   ],
    //   border: Border.all( width: 0.3, color: Color.fromRGBO(220, 220,220, 1), ),borderRadius: BorderRadius.circular(10.0), color: SwaraContainerBG, );
    // Color subText = Color.fromRGBO(110, 110, 110, 1);
    // Color lineColor = Color.fromRGBO(230, 230, 230, 1);
    // var PitchSlider = ElevatedButton.styleFrom (
    //   padding: EdgeInsets.symmetric(horizontal: 10),
    //   foregroundColor: Color.fromRGBO(11, 111, 244,1),
    //   backgroundColor: Colors.white,
    //   shadowColor: Colors.black,
    //   elevation: 5,
    // );
    // //Color.fromRGBO(244, 111, 11, 1);
    // var PitchSliderDeco = BoxDecoration(border: Border.all(color: Color.fromRGBO(240, 240, 240, 1),width: 2,),borderRadius: BorderRadius.circular(20.0),);
    // var RaagaList = ElevatedButton.styleFrom (
    //   padding: EdgeInsets.symmetric(horizontal: 10),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0), // Adjust the value as needed
    //   ),
    //   foregroundColor: Color.fromRGBO(11, 111, 244,1),
    //   backgroundColor:  Colors.white,
    //   shadowColor: Colors.black,
    //   elevation: 5,
    // );
    // var mainButtons = ElevatedButton.styleFrom(
    //   padding: EdgeInsets.symmetric(horizontal:5.0,vertical:12 ),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),
    //     // Adjust the value as needed
    //   ),
    //   //fixedSize: Size(160, 60),
    //   backgroundColor: Color.fromRGBO(11, 111, 244,1).withOpacity(1.0),
    //   shadowColor: Colors.black,
    //   elevation: 5,
    //   //foregroundColor: Color.fromRGBO(11, 111, 244,1),
    // );
    // var mainButtonTxt = TextStyle(fontFamily: 'NotoSansRegular',fontWeight: FontWeight.bold,fontSize: (screenHeight*0.021),color: Color.fromRGBO(250, 250, 250, 1),);
    // var mainButtonDecorations = BoxDecoration(border: Border.all( width: 1, color: Color.fromRGBO(11, 111, 244, 1).withOpacity(0.3), ),borderRadius: BorderRadius.circular(10.0),);
    // Color modalBottomBG =  Color.fromRGBO(240, 240, 240,1);
    // var modalCTNdeco = BoxDecoration(border: Border.all(color: Color.fromRGBO(115, 99, 114, 1),width: 1.0,),borderRadius: BorderRadius.circular(10.0),);
    // var otherText = TextStyle(fontFamily: 'NotoSans',fontSize: 12,fontWeight: FontWeight.normal,color: Color.fromRGBO(11, 111, 244, 1));
    //
    // var ChakraButtons = ElevatedButton.styleFrom(
    //   padding: EdgeInsets.symmetric(horizontal:10.0,vertical:5 ),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
    //     // Adjust the value as needed
    //   ),
    //   backgroundColor: Color.fromRGBO(11, 111, 244,1).withOpacity(0.9),
    //   shadowColor: Colors.black,
    //   elevation: 10,
    //   //foregroundColor: Color.fromRGBO(11, 111, 244,1),
    // );
    //
    // var ChakraButtonTxt = TextStyle(fontFamily: 'NotoSansRegular',fontWeight: FontWeight.bold,fontSize: 15,color: Color.fromRGBO(250, 250, 250, 1),);
    //
    // var popupMainText =   TextStyle(fontFamily: 'NotoSansRegular',fontSize: 22,fontWeight: FontWeight.bold,color: Color.fromRGBO(11, 111, 244,1));
    // var popupMidText =  TextStyle(fontFamily: 'NotoSansMid',fontSize: 15,color: Color.fromRGBO(11, 111, 244,1),height: 2.5);
    // var popupNormalText = TextStyle(fontFamily: 'NotoSansMid',fontSize: 15,height: 1.5);

    print('\nThis Statement chumma Exists, Just above the UI lines\n');

    //UI
    Color OverallbackGround = Color.fromRGBO(255, 255, 255, 1);
    Color txtTitle = Color.fromRGBO(11, 111, 244, 1);
    Color SwaraContainerBG = Color.fromRGBO(241, 243, 244, 1);
    Color SwarasContainerText = Color.fromRGBO(0, 0, 0, 1);
    Color SwaraContainersubText = Color.fromRGBO(100, 100,100, 1);
    var SwarasContainerDeco = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 5), // changes position of shadow
        ),
      ],
      border: Border.all(width: 0.5, color: Color.fromRGBO(46, 46, 46, 1),),
      borderRadius: BorderRadius.circular(10.0),
      color: SwaraContainerBG,);
    Color subText = Color.fromRGBO(110, 110, 110, 1);
    Color lineColor = Color.fromRGBO(230, 230, 230, 1);
    var PitchSlider = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 0),
      foregroundColor: Color.fromRGBO(11, 111, 244, 1),
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 5,
    );
    //Color.fromRGBO(244, 111, 11, 1);
    var PitchSliderDeco = BoxDecoration(
      border: Border.all(color: Color.fromRGBO(240, 240, 240, 1), width: 2,),
      borderRadius: BorderRadius.circular(20.0),);
    var RaagaList = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0), // Adjust the value as needed
      ),
      foregroundColor: Color.fromRGBO(11, 111, 244, 1),
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 5,
    );
    var mainButtons = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),
        // Adjust the value as needed
      ),
      //fixedSize: Size(160, 60),
      backgroundColor: Color.fromRGBO(11, 111, 244, 1).withOpacity(1.0),
      shadowColor: Colors.black,
      elevation: 5,
      //foregroundColor: Color.fromRGBO(11, 111, 244,1),
    );
    // var mainButtonTxt = TextStyle(fontFamily: 'NotoSansRegular',
    //   fontWeight: FontWeight.bold,
    //   fontSize: (screenHeight * 0.021),
    //   color: Color.fromRGBO(250, 250, 250, 1),);
    var mainButtonDecorations = BoxDecoration(border: Border.all(
      width: 1, color: Color.fromRGBO(11, 111, 244, 1).withOpacity(0.3),),
      borderRadius: BorderRadius.circular(10.0),);
    Color modalBottomBG = Color.fromRGBO(240, 240, 240, 1);
    var modalCTNdeco = BoxDecoration(
      border: Border.all(color: Color.fromRGBO(115, 99, 114, 1), width: 1.0,),
      borderRadius: BorderRadius.circular(10.0),);
    var otherText = TextStyle(fontFamily: 'NotoSansNormal',
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: Color.fromRGBO(11, 111, 244, 1));
    var ChakraButtons = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
        // Adjust the value as needed
      ),
      backgroundColor: Color.fromRGBO(11, 111, 244, 1).withOpacity(0.9),
      shadowColor: Colors.black,
      elevation: 10,
      //foregroundColor: Color.fromRGBO(11, 111, 244,1),
    );
    var ChakraButtonTxt = TextStyle(fontFamily: 'NotoSansRegular',
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Color.fromRGBO(250, 250, 250, 1),);
    var popupMainText = TextStyle(fontFamily: 'NotoSansRegular',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(11, 111, 244, 1));
    var popupMidText = TextStyle(fontFamily: 'NotoSansMid',
        fontSize: 15,
        color: Color.fromRGBO(11, 111, 244, 1),
        height: 2.5);
    var popupNormalText = TextStyle(
        fontFamily: 'NotoSansMid', fontSize: 15, height: 1.5);
    var popupNoteText = TextStyle(
        fontFamily: 'NotoSansRegular', fontSize: 12, fontWeight: FontWeight.w100 );
    var about_Cont_text= TextStyle( color: Colors.black,fontSize: 15,fontWeight: FontWeight.w300);




    if (tutorialVble) {_createTutorial();}

    List ourRaagas = RaagaLib.keys.toList();
    var ourRaagasNested = [];

    int SplitSize = 6;
    var tmp = [];
    for (int i = 0; i < ourRaagas.length; i++) {
      tmp.add(ourRaagas[i]);
      if (tmp.length == SplitSize) {
        ourRaagasNested.add(tmp);
        tmp = [];
      }
    }
    DateTime? lastpress;

    @override
    void initState() {
      super.initState();
      _createTutorial();
    }
    var trans_info = Icon(Icons.info_outline_rounded, size: 12,color: Colors.transparent,);
    var coloured_info  = Icon(Icons.info_outline_rounded, size: 12,color: Color.fromRGBO(11, 111,244,1),);


    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final Max = Duration(seconds: 2);

        final isWarning = lastpress == null ||
            now.difference(lastpress!) > Max;

        if (isWarning) {
          lastpress = DateTime.now();
          final sb = SnackBar(
            content: Text('Tap back button again, to exit..!', textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'NotoSansMid',
                  fontSize: 15,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  height: 2.5),),
            duration: Max,
            backgroundColor: Color.fromRGBO(11, 111, 244, 0.7),

          );
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(sb);


          return false;

        } else {
          exit(0);

          return true;

        }
        //
        //  SystemNavigator.pop();
        // return false;
        //
        // //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> MainApp(showHome: true,)));
      },
      child: Scaffold(
        // appBar: AppBar(
        //   leading:
        //     IconButton(icon: Icon(Icons.psychology_alt,
        //       size: 30,
        //       color: Color.fromRGBO(11,111, 244, 1),
        //     ),
        //       onPressed: () {
        //         tutorialState(true);
        //         tutorialModalState(true);
        //         tutorialInputState(true);
        //         tutorialIntervalVbleState(true);
        //         tutorialChordVbleState(true);
        //
        //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));
        //       },),
        //
        //   actions: [
        //
        //
        //
        //
        //
        //
        //     IconButton(icon:
        //       Icon(Icons.school_outlined,
        //         size: 30,color: Color.fromRGBO(11, 111, 244, 1),),
        //       onPressed: () {
        //       PageCtrl = 0;
        //       Navigator.push(context, MaterialPageRoute(builder: (_)=> TheoryContent()));
        //       },),
        //
        //
        //
        //     IconButton(icon: Icon(Icons.logo_dev_rounded,
        //       size: 30,
        //       color: Color.fromRGBO(50, 50, 50, 1),
        //     ),
        //       onPressed: () {
        //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> MainApp(showHome: false)));
        //       },),
        //An
        //
        //
        //
        //   ],
        //   backgroundColor: Colors.transparent,
        // ),
        backgroundColor: OverallbackGround,
          bottomNavigationBar: BottomBarDoubleBullet(
            color: Color.fromRGBO(11, 111, 244, 1),
            selectedIndex: _Bottomindex,
            items: [

              BottomBarItem(iconData: Icons.info_outline_rounded,label: 'Intervals',),
              BottomBarItem(iconData: Icons.home_outlined,label: 'Chords',),
              // BottomBarItem(iconData: Icons.square, label: 'FretBoard',),
              // BottomBarItem(iconData: Icons.description_outlined,label: 'Theory',),
              BottomBarItem(iconData: Icons.groups_2_outlined,label: 'About',),

            ],
            onSelect: (index) {
              if(index == 0){setState(() {_Bottomindex = index;});PageCtrl=0;}
              else if(index == 1){setState(() {_Bottomindex = index;});PageCtrl=0;}
              else if(index == 2){setState(() {_Bottomindex = index;});PageCtrl=0;}
              // else if(index == 3){setState(() {_Bottomindex = index;});PageCtrl=0;}
              // else if(index == 4){setState(() {_Bottomindex = index;});PageCtrl=0;}
            },
          ),




          body: [IntPair(),FamilyChds(),
            // Raag_FretBoard(),

            // TheoryLearner(),
            About_US()][_Bottomindex],
        // body: Center(
        //   child: ListView(
        //     // Important: Remove any padding from the ListView.
        //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //     children: [
        //
        //       Container(margin: EdgeInsets.all(30),),
        //
        //       GestureDetector(
        //         key: _title,
        //         onTap: () {
        //           showDialog(
        //               context: context,
        //               builder: (BuildContext context) {
        //                 return AlertDialog(
        //                   backgroundColor: Color.fromRGBO(255, 240, 240, 5),
        //                   content: Container(
        //                     //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
        //                     padding: EdgeInsets.all(10),
        //                     child: RichText(text: TextSpan(text: ' ',
        //                       style: TextStyle(fontSize: 12,
        //                           fontFamily: 'NotoSansMid',
        //                           color: SwarasContainerText),
        //                       children: <TextSpan>[
        //                         TextSpan(text: 'Special Credits \n',
        //                             style: popupMainText),
        //
        //                         TextSpan(text: 'Music Theory Trainers',
        //                             style: popupMidText),
        //                         TextSpan(text: '\nAcharya K.Pradeepan - Mentor',
        //                           style: popupNormalText,),
        //                         TextSpan(
        //                           text: '\nMohana Priya - Carnatic Music',
        //                           style: popupNormalText,),
        //                         TextSpan(text: '\nEvans Marvin - Chords',
        //                           style: popupNormalText,),
        //
        //
        //                         TextSpan(text: '\nTechnical Guides',
        //                             style: popupMidText),
        //                         TextSpan(
        //                           text: '\nP.S.Sanjay - Flutter Development',
        //                           style: popupNormalText,),
        //                         TextSpan(text: '\nAdith Mohan Kumar - Audio',
        //                           style: popupNormalText,),
        //                         TextSpan(text: '\nAjay - Creative UX Ideas',
        //                           style: popupNormalText,),
        //
        //
        //                         TextSpan(
        //                             text: '\nUI/UX Guide', style: popupMidText),
        //                         TextSpan(text: '\nAbinav Suresh - UX Guides',
        //                           style: popupNormalText,),
        //                         TextSpan(text: '\nK.Saljo - UX Monitoring',
        //                           style: popupNormalText,),
        //                         TextSpan(
        //                           text: '\nAaditya.M - UI/UX Fundementals',
        //                           style: popupNormalText,),
        //
        //
        //                         TextSpan(
        //                           text: '\n\nIf it weren\'t for all the above people and my family i could not have developed the application.',
        //                           style: popupNormalText.copyWith(
        //                               fontSize: 10),),
        //
        //
        //                       ],),),),
        //
        //                   actions: <Widget>[
        //                     TextButton(
        //                       onPressed: () {
        //                         Navigator.of(context).pop();
        //                       },
        //                       child: Text('Close', style: popupMidText),
        //                     ),
        //                   ],
        //                 );
        //               }
        //           );
        //         },
        //         child: Center(
        //             child: Stack(
        //               children: <Widget>[
        //                 // Stroked text as border.
        //                 Text(
        //                   'Guitar Raag',
        //                   style: TextStyle(
        //                     fontFamily: 'NotoSansMid',
        //                     fontSize: screenHeight * 0.033,
        //                     foreground: Paint()
        //                       ..style = PaintingStyle.stroke
        //                       ..strokeWidth = 0.4
        //                       ..color = Colors.white,
        //                   ),
        //                 ),
        //                 // Solid text as fill.
        //                 Text(
        //                   'Guitar Raag',
        //                   style: TextStyle(
        //                     fontFamily: 'NotoSansMid',
        //                     fontSize: screenHeight * 0.033,
        //                     color: txtTitle,
        //                   ),
        //                 ),
        //               ],
        //             )
        //
        //
        //           // Text('Guitar Raag',style: TextStyle(fontFamily: 'NotoSansMid',color: txtTitle, fontSize: screenHeight*0.033,),
        //           // )
        //         ),
        //       ),
        //       //Title
        //
        //       //Divider(color: Color.fromRGBO(244, 111, 11, 1),height: 0,thickness: 0.1,endIndent: 100,indent: 100,),
        //       //Container(margin: EdgeInsets.all(20.0),),
        //       // Container(
        //       //   alignment: Alignment.center,
        //       //   margin: const EdgeInsets.only(top: 20.0),
        //       //   child: GestureDetector(
        //       //     onTap: (){showDialog(
        //       //       context: context,
        //       //       builder: (BuildContext context){
        //       //         return AlertDialog(
        //       //           title: Text('GuitarRaag'),
        //       //           content: Container(
        //       //            //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
        //       //             padding: EdgeInsets.all(10),
        //       //             child: Text('\"The Guitar Raaga\" is primarily designed to ascertain the precise musical chords for any Heptatonic Musical Scale or Carnatic Melakarta Raagam using musical intervals. '
        //       //                         'The Family of chords feature enables users to accompany real-time songs, and'
        //       //                         ' it facilitates song composition without incorporating accidental notes or swaras.',
        //       //               style: TextStyle(fontSize: 15,fontFamily: 'NotoSansRegular'),
        //       //               textAlign: TextAlign.left,)),
        //       //
        //       //           actions: <Widget>[
        //       //             TextButton(
        //       //               onPressed: () {Navigator.of(context).pop();},
        //       //               child: Text('Close'),
        //       //             ),
        //       //           ],
        //       //         );
        //       //       }
        //       //     );},
        //       //       child: Text('Guitar Raag',style: TextStyle(fontFamily: 'NotoSans',color: txtTitle, fontSize: 28,fontWeight: FontWeight.bold,),)),),
        //
        //       Container(margin: EdgeInsets.only(top: 10)),
        //
        //       // Container(alignment: Alignment.center,margin: EdgeInsets.only(bottom: 10),
        //       //   child: Center(child: Column(
        //       //     children: [
        //       //       Text('Tap to Set Swaras',style: TextStyle(color: txtY,fontSize: 14,fontFamily: 'NotoSansRegular',fontWeight: FontWeight.bold,),),
        //       //       // Text('Double Tap to Set Raaga',style: TextStyle(color: txtY,fontSize: 14,fontFamily: 'NotoSansRegular',fontWeight: FontWeight.bold,),),
        //       //     ],
        //       //   )),),
        //
        //
        //
        //
        //
        //
        //
        //       // Container(
        //       //   padding: const EdgeInsets.all(8.0),
        //       //   child: CustomPaint(
        //       //     size: Size(screenWidth,screenHeight),
        //       //     painter: PaintTest(),
        //       //   ),
        //       // ),
        //
        //
        //
        //
        //
        //       GestureDetector(
        //         key: _CurrentRaag,
        //
        //         onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InputBox()));
        //           //
        //           // if(tutorialModalVble){
        //           //   _createTutorialModalBottom();
        //           // }
        //           //
        //           // showModalBottomSheet(
        //           //     context: context, builder: (BuildContext context) {
        //           //   return Column(
        //           //     children: [
        //           //       Container(
        //           //         key: _CurrentRaagScreen,
        //           //         height: 280,
        //           //         margin: EdgeInsets.only(top: 25),
        //           //         color: modalBottomBG,
        //           //         padding: EdgeInsets.symmetric(horizontal: 30.0),
        //           //         child: PageView.builder(
        //           //           controller: pgCtrl,
        //           //           itemCount: ourRaagasNested.length,
        //           //           onPageChanged: (value) {
        //           //             setState(() {
        //           //               CurrPage = value;
        //           //             });
        //           //           },
        //           //           itemBuilder: (BuildContext context,
        //           //               int ChakraIndex) {
        //           //             return ListView.builder(
        //           //               itemCount: ourRaagasNested[ChakraIndex].length,
        //           //               itemBuilder: (BuildContext context, int index) {
        //           //                 var MelaNo = ChakraIndex * SplitSize + index;
        //           //                 return Container(
        //           //                   width: 60.0,
        //           //                   height: 40.0,
        //           //                   // Adjust the width as needed
        //           //                   margin: EdgeInsets.symmetric(
        //           //                       horizontal: 60.0, vertical: 3),
        //           //                   //padding: EdgeInsets.all(8.0),
        //           //                   decoration: modalCTNdeco,
        //           //                   child: ElevatedButton(style: RaagaList,
        //           //                     onPressed: () {
        //           //
        //           //                       String ragaName = ourRaagasNested[ChakraIndex][index];
        //           //                       setRaagam(RaagaLib['$ragaName'],
        //           //                           western_swaras);
        //           //                       setRaagamName(
        //           //                           ourRaagasNested[ChakraIndex][index]);
        //           //
        //           //
        //           //                       setState(() {
        //           //                         CurrPage = 0;
        //           //                       });
        //           //                       Navigator.pop(context);
        //           //                     },
        //           //                     child: Row(
        //           //                       children: [
        //           //                         Flexible(child: Container(
        //           //                           margin: EdgeInsets.all(25.0),),),
        //           //                         Text('${MelaNo + 1} : ',
        //           //                           style: TextStyle(fontSize: 15),),
        //           //                         Text(
        //           //                           '${ourRaagasNested[ChakraIndex][index]}',
        //           //                           style: TextStyle(fontSize: 15),),
        //           //                         Flexible(child: Container(
        //           //                           margin: EdgeInsets.all(25.0),),),
        //           //                       ],),
        //           //                   ),);
        //           //               },);
        //           //           },),),
        //           //
        //           //       // Positioned(
        //           //       //   bottom: 20,
        //           //       //   left:100,
        //           //       //   right: 100,
        //           //       //   child: DropdownButton(
        //           //       //     value: CurrPage,
        //           //       //     items: [
        //           //       //       for(int i = 0;i<chakras.length;i++)
        //           //       //         DropdownMenuItem(child: Text(chakras[i]),value: i)],
        //           //       //     onChanged: (value){
        //           //       //       int a = value!;
        //           //       //       pgCtrl.animateToPage(
        //           //       //           a,
        //           //       //           duration: Duration(milliseconds: 300),
        //           //       //           curve: Curves.easeIn);
        //           //       //     },
        //           //       //   ),
        //           //       // ),
        //           //
        //           //
        //           //       // Positioned(
        //           //       //   bottom:10,
        //           //       //   left: 0,
        //           //       //   right:0,
        //           //       //   child: Container(
        //           //       //     color: Colors.transparent,
        //           //       //     child: Row(
        //           //       //       mainAxisAlignment: MainAxisAlignment.center,
        //           //       //       children: List<Widget>.generate(ourRaagasNested.length, (index) => Padding(
        //           //       //         padding: EdgeInsets.symmetric(horizontal: 2.0),
        //           //       //         child: InkWell(
        //           //       //           onTap:(){
        //           //       //             pgCtrl.animateToPage(
        //           //       //                 index,
        //           //       //                 duration: Duration(milliseconds: 300),
        //           //       //                 curve: Curves.easeIn);
        //           //       //           },
        //           //       //           child: CircleAvatar(
        //           //       //             radius: 10,
        //           //       //             backgroundColor: CurrPage==index?
        //           //       //             Color.fromRGBO(11, 111, 244, 1):
        //           //       //             Colors.grey,
        //           //       //           ),
        //           //       //         ),
        //           //       //       ),
        //           //       //       ),),
        //           //       //   ),
        //           //       // ),
        //           //
        //           //
        //           //       // PageView.builder(
        //           //       //
        //           //       //   itemCount: chakras.length,
        //           //       //   onPageChanged: (value){
        //           //       //     setState(() {
        //           //       //       CurrPage = value;
        //           //       //     });
        //           //       //   },
        //           //       //   itemBuilder: (BuildContext context, int CurrPage){
        //           //       //     return Positioned(
        //           //       //       bottom:10,
        //           //       //       left: 0,
        //           //       //       right:0,
        //           //       //       child: Container(
        //           //       //         color: Colors.transparent,
        //           //       //         child: Row(
        //           //       //           mainAxisAlignment: MainAxisAlignment.center,
        //           //       //           children: List<Widget>.generate(chakras.length, (index) => Padding(
        //           //       //             padding: EdgeInsets.symmetric(horizontal: 2.0),
        //           //       //             child: InkWell(
        //           //       //               onTap:(){
        //           //       //                 pgCtrl.animateToPage(
        //           //       //                     index,
        //           //       //                     duration: Duration(milliseconds: 300),
        //           //       //                     curve: Curves.easeIn);
        //           //       //               },
        //           //       //               child: Row (
        //           //       //                 mainAxisAlignment: MainAxisAlignment.center,
        //           //       //                 children: [
        //           //       //                   Text(chakras[index]+'\n',style: TextStyle(
        //           //       //
        //           //       //                     //backgroundColor: _checkboxValues[14]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
        //           //       //                     // color: (CurrPage==index)?
        //           //       //                     // MaterialStateProperty.all<Color>(Color.fromRGBO(11, 111, 244, 1)):
        //           //       //                     // MaterialStateProperty.all<Color>(Colors.grey),
        //           //       //
        //           //       //                     fontSize: (CurrPage==index) ? 20:9,
        //           //       //                     color: CurrPage==index?Color.fromRGBO(11, 111, 244, 1):Colors.grey,
        //           //       //
        //           //       //                   ),),
        //           //       //
        //           //       //                 ],),
        //           //       //             ),
        //           //       //           ),
        //           //       //           ),),
        //           //       //       ),
        //           //       //     );
        //           //       //
        //           //       //
        //           //       //
        //           //       //
        //           //       //
        //           //       //     //        ListView.builder(
        //           //       //     //                               itemCount: ourRaagasNested[ChakraIndex].length,
        //           //       //     //                               itemBuilder: (BuildContext context, int index) {
        //           //       //     //                                 var MelaNo = ChakraIndex*SplitSize+index;
        //           //       //     //                                 return Container(
        //           //       //     //                                   width: 60.0,
        //           //       //     //                                   height: 50.0,
        //           //       //     //                                   // Adjust the width as needed
        //           //       //     //                                   margin: EdgeInsets.all(6.0),
        //           //       //     //                                   //padding: EdgeInsets.all(8.0),
        //           //       //     //                                   decoration: modalCTNdeco,
        //           //       //     //                                   child: ElevatedButton(style: RaagaList,
        //           //       //     //                                     onPressed: () {
        //           //       //     //                                       String ragaName = ourRaagasNested[ChakraIndex][index];
        //           //       //     //                                       setRaagam(RaagaLib['$ragaName'], western_swaras);
        //           //       //     //                                       setRaagamName(ourRaagasNested[ChakraIndex][index]);
        //           //       //     //                                       setState(() {CurrPage = 0;});
        //           //       //     //                                       Navigator.pop(context);
        //           //       //     //                                     },
        //           //       //     //                                     child: Row(
        //           //       //     //                                       children: [
        //           //       //     //                                         Flexible(child: Container(
        //           //       //     //                                           margin: EdgeInsets.all(25.0),),),
        //           //       //     //                                         Text('${MelaNo + 1} : ',
        //           //       //     //                                           style: TextStyle(fontSize: 20),),
        //           //       //     //                                         Text('${ourRaagasNested[ChakraIndex][index]}',
        //           //       //     //                                           style: TextStyle(fontSize: 20),),
        //           //       //     //                                         Flexible(child: Container(
        //           //       //     //                                           margin: EdgeInsets.all(25.0),),),
        //           //       //     //                                       ],),
        //           //       //     //                                   ),);
        //           //       //     //
        //           //       //     //                               },);
        //           //       //
        //           //       //
        //           //       //   },),
        //           //
        //           //
        //           //       // DropdownButton(
        //           //       //   value: CurrPage,
        //           //       //   items: [
        //           //       //     for(int i = 0;i<chakras.length;i++)
        //           //       //       DropdownMenuItem(child: Text(chakras[i]),value: i)],
        //           //       //   onChanged: (value){
        //           //       //     int a = value!;
        //           //       //     pgCtrl.animateToPage(
        //           //       //         a,
        //           //       //         duration: Duration(milliseconds: 300),
        //           //       //         curve: Curves.easeIn);
        //           //       //   },
        //           //       // ),
        //           //
        //           //       // Column (
        //           //       //   mainAxisAlignment: MainAxisAlignment.center,
        //           //       //   children: [
        //           //       //     Row(children: [
        //           //       //       for(int i = 0;i<4;i++)
        //           //       //         Flexible(
        //           //       //           child: ElevatedButton(onPressed: (){
        //           //       //             pgCtrl.animateToPage(
        //           //       //                 i,
        //           //       //                 duration: Duration(milliseconds: 300),
        //           //       //                 curve: Curves.easeIn);
        //           //       //             }, child: Text(chakras[i])),
        //           //       //         ),
        //           //       //     ],),
        //           //       //
        //           //       //     Row(children: [
        //           //       //       for(int i = 4;i<8;i++)
        //           //       //         ElevatedButton(onPressed: (){
        //           //       //           pgCtrl.animateToPage(
        //           //       //               i,
        //           //       //               duration: Duration(milliseconds: 300),
        //           //       //               curve: Curves.easeIn);
        //           //       //         }, child: Text(chakras[i])),
        //           //       //
        //           //       //     ],),
        //           //       //
        //           //       //
        //           //       //     Row(children: [
        //           //       //       for(int i = 8;i<12;i++)
        //           //       //         ElevatedButton(onPressed: (){
        //           //       //           pgCtrl.animateToPage(
        //           //       //               i,
        //           //       //               duration: Duration(milliseconds: 300),
        //           //       //               curve: Curves.easeIn);
        //           //       //         }, child: Text(chakras[i])),
        //           //       //
        //           //       //     ],),
        //           //       //
        //           //       //     // Text(chakras[index]+'\n',style: TextStyle(fontSize: 12,color:Color.fromRGBO(11, 111, 244, 1)
        //           //       //     // ),),
        //           //       //     // //color: CurrPage==index?Color.fromRGBO(11, 111, 244, 1):Colors.grey,
        //           //       //
        //           //       //   ],),
        //           //
        //           //       Divider(height: 10, thickness: 1,),
        //           //       Container(
        //           //         key: _CurrentRaagChakraScreen,
        //           //         color: Colors.transparent,
        //           //         child: Column(
        //           //           mainAxisAlignment: MainAxisAlignment.center,
        //           //           children: [
        //           //             Row(
        //           //               mainAxisAlignment: MainAxisAlignment.center,
        //           //               children: [
        //           //                 for(int i = 0; i < 4; i++)
        //           //                   Container(
        //           //                     //decoration: PitchSliderDeco,
        //           //                     margin: EdgeInsets.symmetric(
        //           //                         horizontal: 5, vertical: 0),
        //           //                     child: ElevatedButton(
        //           //                         style: ChakraButtons,
        //           //                         onPressed: () {
        //           //                           pgCtrl.animateToPage(
        //           //                               i, duration: Duration(
        //           //                               milliseconds: 300),
        //           //                               curve: Curves.easeIn);
        //           //                         },
        //           //                         child: Text(chakras[i],
        //           //                           style: ChakraButtonTxt,)),
        //           //                   ),
        //           //               ],),
        //           //
        //           //             Row(
        //           //               mainAxisAlignment: MainAxisAlignment.center,
        //           //               children: [
        //           //                 for(int i = 4; i < 8; i++)
        //           //                   Container(
        //           //                     //decoration: PitchSliderDeco,
        //           //                     margin: EdgeInsets.only(left: 15,
        //           //                         right: 15,
        //           //                         top: 0,
        //           //                         bottom: 0),
        //           //                     child: ElevatedButton(
        //           //                         style: ChakraButtons,
        //           //                         onPressed: () {
        //           //                           pgCtrl.animateToPage(
        //           //                               i, duration: Duration(
        //           //                               milliseconds: 300),
        //           //                               curve: Curves.easeIn);
        //           //                         },
        //           //                         child: Text(chakras[i],
        //           //                           style: ChakraButtonTxt,)),
        //           //                   ),
        //           //               ],),
        //           //
        //           //             Row(
        //           //               mainAxisAlignment: MainAxisAlignment.center,
        //           //               children: [
        //           //                 for(int i = 8; i < 12; i++)
        //           //                   Container(
        //           //                     // decoration: PitchSliderDeco,
        //           //                     margin: EdgeInsets.symmetric(
        //           //                         horizontal: 5, vertical: 0),
        //           //                     child: ElevatedButton(
        //           //                         style: ChakraButtons,
        //           //                         onPressed: () {
        //           //                           pgCtrl.animateToPage(
        //           //                               i, duration: Duration(
        //           //                               milliseconds: 300),
        //           //                               curve: Curves.easeIn);
        //           //                         },
        //           //                         child: Text(chakras[i],
        //           //                           style: ChakraButtonTxt,)),
        //           //                   ),
        //           //
        //           //               ],),
        //           //
        //           //             // Text(chakras[index]+'\n',style: TextStyle(fontSize: 12,color:Color.fromRGBO(11, 111, 244, 1)
        //           //             // ),),
        //           //             // //color: CurrPage==index?Color.fromRGBO(11, 111, 244, 1):Colors.grey,
        //           //
        //           //           ],),
        //           //
        //           //
        //           //         // Row(
        //           //         //   mainAxisAlignment: MainAxisAlignment.center,
        //           //         //   children: List<Widget>.generate(ourRaagasNested.length, (index) => Padding(
        //           //         //     padding: EdgeInsets.symmetric(horizontal: 2.0),
        //           //         //     child: Column (
        //           //         //       mainAxisAlignment: MainAxisAlignment.center,
        //           //         //       children: [
        //           //         //         Row(children: [
        //           //         //           for(int i = 0;i<4;i++)
        //           //         //             Flexible(
        //           //         //               child: ElevatedButton(onPressed: (){
        //           //         //                 pgCtrl.animateToPage(
        //           //         //                     i,
        //           //         //                     duration: Duration(milliseconds: 300),
        //           //         //                     curve: Curves.easeIn);
        //           //         //               }, child: Text(chakras[i])),
        //           //         //             ),
        //           //         //         ],),
        //           //         //
        //           //         //         Row(children: [
        //           //         //           for(int i = 4;i<8;i++)
        //           //         //             ElevatedButton(onPressed: (){
        //           //         //               pgCtrl.animateToPage(
        //           //         //                   i,
        //           //         //                   duration: Duration(milliseconds: 300),
        //           //         //                   curve: Curves.easeIn);
        //           //         //             }, child: Text(chakras[i])),
        //           //         //
        //           //         //         ],),
        //           //         //
        //           //         //
        //           //         //         Row(children: [
        //           //         //           for(int i = 8;i<12;i++)
        //           //         //             ElevatedButton(onPressed: (){
        //           //         //               pgCtrl.animateToPage(
        //           //         //                   i,
        //           //         //                   duration: Duration(milliseconds: 300),
        //           //         //                   curve: Curves.easeIn);
        //           //         //             }, child: Text(chakras[i])),
        //           //         //
        //           //         //         ],),
        //           //         //
        //           //         //         // Text(chakras[index]+'\n',style: TextStyle(fontSize: 12,color:Color.fromRGBO(11, 111, 244, 1)
        //           //         //         // ),),
        //           //         //         // //color: CurrPage==index?Color.fromRGBO(11, 111, 244, 1):Colors.grey,
        //           //         //
        //           //         //       ],),
        //           //         //
        //           //         //
        //           //         //
        //           //         //   ),
        //           //         //   ),),
        //           //       ),
        //           //
        //           //     ],
        //           //   );
        //           // }); //showModalBottomSheet
        //         },
        //
        //         child: Container(
        //           margin: EdgeInsets.only(top: 10, bottom: 25, left: 20, right: 20),
        //           padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10),
        //           decoration: SwarasContainerDeco,
        //           alignment: Alignment.center,
        //           child: Column(children: [
        //             Container(margin: EdgeInsets.only(bottom: 10),
        //               alignment: Alignment.center,
        //               child: Text('Current Raag', style: TextStyle(
        //                   fontFamily: 'NotoSansRegular',
        //                   color: SwaraContainersubText,
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.normal),),),
        //               Text(RaagamName, style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //                 fontFamily: 'NotoSansRegular',
        //                 color: Color.fromRGBO(0, 0, 0, 1),
        //                 fontSize: 22)),
        //             Container(
        //                 margin: EdgeInsets.only(top: 12.0, right: 5.0)),
        //             Text('Tap to Set Raaga', style: otherText,)
        //           ],),
        //         ),
        //       ),
        //       //SwaraSelector
        //
        //
        //
        //       GestureDetector(
        //         key: _CarnaticSwaras,
        //         onTap: () {
        //           showDialog(
        //               context: context,
        //               builder: (BuildContext context) {
        //             return AlertDialog(
        //               backgroundColor: Color.fromRGBO(240, 255, 255, 1),
        //               content:
        //               Container(
        //                 //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
        //                 padding: EdgeInsets.symmetric(vertical: 10),
        //                 child:
        //
        //
        //                 RichText(text: TextSpan(text: ' ',
        //                   style: TextStyle(fontSize: 12,
        //                       fontFamily: 'NotoSansMid',
        //                       color: SwarasContainerText),
        //                   children: <TextSpan>[
        //                     TextSpan(text: 'Carnatic Swaras \n',
        //                         style: popupMainText),
        //
        //
        //                     TextSpan(text: '\n'
        //                         'This box shows the swaras of the raaga that is selected, in carnatic nomenclature.'
        //                         '\n\nCarnatic music\'s nomenclature follows 16 swarars and 12 unique pitches, '
        //                         '\n\nSimilarly the raagas used in this app are Melakarta raagas that means all the seven swaras are selected, only once.!',
        //                       style: popupNormalText,),
        //
        //                     TextSpan(text: '\n\nTo learn how this works select the \'Learn More\' option given below,',style: popupNoteText)
        //
        //
        //                   ],),),),
        //
        //               actions: <Widget>[
        //                 TextButton(
        //                   onPressed: () {
        //                     PageCtrl = 6;
        //                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TheoryContent()));
        //                   },
        //                   child: Text('Learn more', style: popupMidText),
        //                 ),
        //                 ElevatedButton(
        //                   style: ElevatedButton.styleFrom(
        //                     backgroundColor: Color.fromRGBO(255, 230, 230, 1), // background color
        //                   ),
        //                   onPressed: () {
        //                     Navigator.of(context).pop();
        //                   },
        //                   child: Text('Close', style: popupMidText),
        //                 ),
        //               ],
        //             );
        //           },
        //           );
        //
        //
        //
        //           },
        //         child: Container(
        //           margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        //           decoration: SwarasContainerDeco,
        //           padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10),
        //           alignment: Alignment.center,
        //           child: Column(
        //               children: [
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //
        //                   children: [
        //                    trans_info,
        //
        //                      Text('Carnatic Swaras' ,style: TextStyle(
        //                           fontFamily: 'NotoSansRegular',
        //                           color: SwaraContainersubText,
        //                           fontSize: 12,
        //                           fontWeight: FontWeight.normal),),
        //                     coloured_info,
        //
        //               ],
        //                 ),
        //                 Container(
        //                   alignment: Alignment.center,
        //                   margin: EdgeInsets.symmetric(vertical: 5.0),
        //                   child: Text(ragam2.substring(1, (ragam2.length - 1)),
        //                     style: TextStyle(fontFamily: 'NotoSansRegular',
        //                         fontSize: 16,
        //                         color: SwarasContainerText,
        //                         fontWeight: FontWeight.bold),),),
        //
        //               ]),),
        //       ),
        //       //Carnatic Swaras
        //
        //       GestureDetector(
        //         key: _WesternNotes,
        //         onTap: () {
        //           showDialog(
        //             context: context,
        //             builder: (BuildContext context) {
        //               return AlertDialog(
        //                 backgroundColor: Color.fromRGBO(240, 255, 255, 1),
        //                 content: Container(
        //                   //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
        //                   padding: EdgeInsets.symmetric(vertical: 10),
        //                   child: RichText(text: TextSpan(text: ' ',
        //                     style: TextStyle(fontSize: 12,
        //                         fontFamily: 'NotoSansMid',
        //                         color: SwarasContainerText),
        //                     children: <TextSpan>[
        //                       TextSpan(text: 'Notes in Western Music \n',
        //                           style: popupMainText),
        //
        //
        //                       TextSpan(text: '\n'
        //                           'This box shows the scale notes that are equivalent of the selected raaga in western nomenclature.'
        //                          '\n\nThe scale is also changes when the pitch is adjusted below.!'
        //                           '\n\nIn Western music, the scale note plays a major role as this is the basic thing in western music.'
        //                           '\n\nChords are built using scale notes, shaping the harmonic structure and progression of music.',
        //                         style: popupNormalText,),
        //
        //                       TextSpan(text: '\n\nTo learn how this works select the \'Learn More\' option given below,',style: popupNoteText)
        //
        //
        //
        //
        //
        //                     ],),),),
        //
        //                 actions: <Widget>[
        //                   TextButton(
        //
        //                     onPressed: () {
        //                       PageCtrl = 1;
        //                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TheoryContent()));},
        //                     child: Text('Learn more', style: popupMidText),
        //                   ),
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
        //         },
        //         child: Container(
        //         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        //         decoration: SwarasContainerDeco,
        //         padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10),
        //         alignment: Alignment.center,
        //         child: Column(
        //             children: [
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //
        //                   trans_info,
        //                   Text('Western Notes', style: TextStyle(
        //                       fontFamily: 'NotoSansRegular',
        //                       color: SwaraContainersubText,
        //                       fontSize: 12,
        //                       fontWeight: FontWeight.normal),),
        //                   coloured_info,
        //                 ],
        //               ),
        //               //Container(margin: EdgeInsets.only(top:5.0),),
        //               Container(
        //                 //decoration: BoxDecoration(border: Border.all( width: 2, color: Colors.black, ),),
        //                 alignment: Alignment.center,
        //                 margin:  EdgeInsets.symmetric(vertical: 5.0),
        //                 child: Text(ragam.substring(1, (ragam.length - 1)),
        //                   style: TextStyle(fontFamily: 'NotoSansRegular',
        //                       fontSize: 16,
        //                       color: SwarasContainerText,
        //                       fontWeight: FontWeight.bold),),),
        //             ]),),
        //
        //           ),
        //       //Western NOtes
        //
        //       // Center(
        //       //   child: GestureDetector(
        //       //
        //       //       child: Container(
        //       //         margin: EdgeInsets.only(top: 10),
        //       //         child: Icon(Icons.help_outline,color: txtTitle, size: 24,),                    ),
        //       //
        //       //       onTap:() {
        //       //         showDialog(
        //       //             context: context,
        //       //             builder: (BuildContext context) {
        //       //               return AlertDialog(
        //       //                 backgroundColor: Color.fromRGBO(255, 240, 240, 5),
        //       //                 content: Container(
        //       //                   //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
        //       //                   padding: EdgeInsets.all(10),
        //       //                   child: RichText(text: TextSpan(text: ' ',
        //       //                     style: TextStyle(fontSize: 12,
        //       //                         fontFamily: 'NotoSansMid',
        //       //                         color: SwarasContainerText),
        //       //                     children: <TextSpan>[
        //       //                       TextSpan(text: 'Special Credits \n',
        //       //                           style: popupMainText),
        //       //
        //       //                       TextSpan(text: 'Music Theory Trainers',
        //       //                           style: popupMidText),
        //       //                       TextSpan(
        //       //                         text: '\nAcharya K.Pradeepan - Mentor',
        //       //                         style: popupNormalText,),
        //       //                       TextSpan(
        //       //                         text: '\nMohana Priya - Carnatic Music',
        //       //                         style: popupNormalText,),
        //       //                       TextSpan(text: '\nEvans Marvin - Chords',
        //       //                         style: popupNormalText,),
        //       //
        //       //
        //       //                       TextSpan(text: '\nTechnical Guides',
        //       //                           style: popupMidText),
        //       //                       TextSpan(
        //       //                         text: '\nP.S.Sanjay - Flutter Development',
        //       //                         style: popupNormalText,),
        //       //                       TextSpan(
        //       //                         text: '\nAdith Mohan Kumar - Audio',
        //       //                         style: popupNormalText,),
        //       //                       TextSpan(text: '\nAjay - Creative UX Ideas',
        //       //                         style: popupNormalText,),
        //       //
        //       //
        //       //                       TextSpan(
        //       //                           text: '\nUI/UX Guide',
        //       //                           style: popupMidText),
        //       //                       TextSpan(
        //       //                         text: '\nAbinav Suresh - UX Guides',
        //       //                         style: popupNormalText,),
        //       //                       TextSpan(text: '\nK.Saljo - UX Monitoring',
        //       //                         style: popupNormalText,),
        //       //                       TextSpan(
        //       //                         text: '\nAaditya.M - UI/UX Fundementals',
        //       //                         style: popupNormalText,),
        //       //
        //       //
        //       //                       TextSpan(
        //       //                         text: '\n\nIf it weren\'t for all the above people and my family i could not have developed the application.',
        //       //                         style: popupNormalText.copyWith(
        //       //                             fontSize: 10),),
        //       //
        //       //
        //       //                     ],),),),
        //       //
        //       //                 actions: <Widget>[
        //       //                   TextButton(
        //       //                     onPressed: () {
        //       //                       Navigator.of(context).pop();
        //       //                     },
        //       //                     child: Text('Close', style: popupMidText),
        //       //                   ),
        //       //                 ],
        //       //               );
        //       //             }
        //       //         );
        //       //       }
        //       //   ),
        //       // ),
        //
        //       // Container(
        //       //   margin: EdgeInsets.symmetric(horizontal: 60.0,vertical: 10),
        //       //   decoration: BoxDecoration(border: Border.all( width: 3, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0),),
        //       //   height: 42,
        //       //   child: ElevatedButton(
        //       //     style: ElevatedButton.styleFrom(
        //       //       padding: EdgeInsets.symmetric(horizontal:10.0),
        //       //       shape: RoundedRectangleBorder(
        //       //         borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
        //       //       ),
        //       //       fixedSize: Size(200, 42),
        //       //       backgroundColor:Color.fromRGBO(220, 238, 209, 1),
        //       //       //Color.fromRGBO(161, 130, 118, 1),
        //       //       foregroundColor:Color.fromRGBO(115, 99, 114, 1),
        //       //       //Color.fromRGBO(220, 238, 209, 1),
        //       //     ),
        //       //     child: Text('Raaga Names',style: TextStyle(fontFamily: 'NotoSans',fontSize: 18,fontWeight: FontWeight.bold),),
        //       //     onPressed: (){
        //       //       List ourRaagas = RaagaLib.keys.toList();
        //       //       showModalBottomSheet<void>(context: context,builder: (BuildContext context) {
        //       //         return Container(height: 500,
        //       //           color: Color.fromRGBO(115, 99, 114, 1),
        //       //           padding: EdgeInsets.all(20.0),
        //       //           child: ListView.builder(
        //       //             itemCount: ourRaagas.length,
        //       //             itemBuilder: (BuildContext context, int index) {
        //       //               return  Container(
        //       //                 width: 60.0,
        //       //                 height: 50.0,// Adjust the width as needed
        //       //                 margin: EdgeInsets.all(6.0),
        //       //                 //padding: EdgeInsets.all(8.0),
        //       //                 decoration: BoxDecoration(border: Border.all(color: Color.fromRGBO(115, 99, 114, 1),width: 2.0,),borderRadius: BorderRadius.circular(30.0),),
        //       //                 child: ElevatedButton(style: styl,
        //       //                   onPressed: () {String ragaName = ourRaagas[index];
        //       //                   setRaagam(RaagaLib['$ragaName'], western_swaras);},
        //       //                   child: Row(
        //       //                     children: [
        //       //                       Flexible(child: Container(margin: EdgeInsets.all(25.0),),),
        //       //                       Text('${index + 1} : ',style: TextStyle(fontSize: 20),),
        //       //                       Text(ourRaagas[index],style: TextStyle(fontSize: 20),),
        //       //                       Flexible(child: Container(margin: EdgeInsets.all(25.0),),),
        //       //                     ],),
        //       //                 ),);
        //       //             },),);
        //       //       });//showModalBottomSheet
        //       //     },),),
        //
        //       // Container(
        //       //   margin: EdgeInsets.symmetric(horizontal: 100.0,vertical: 10),
        //       //   decoration: BoxDecoration(border: Border.all( width: 3, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0),),
        //       //   height: 42,
        //       //   child: ElevatedButton(
        //       //     style: ElevatedButton.styleFrom(
        //       //       padding: EdgeInsets.symmetric(horizontal:10.0),
        //       //       shape: RoundedRectangleBorder(
        //       //         borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
        //       //       ),
        //       //       fixedSize: Size(260, 40),
        //       //       backgroundColor:Color.fromRGBO(220, 238, 209, 1),
        //       //       //Color.fromRGBO(161, 130, 118, 1),
        //       //       foregroundColor:Color.fromRGBO(115, 99, 114, 1),
        //       //       //Color.fromRGBO(220, 238, 209, 1),
        //       //     ),
        //       //     child: Text('Swaras',style: TextStyle(fontFamily: 'NotoSans',fontSize: 18,fontWeight: FontWeight.bold),),
        //       //     onPressed: (){
        //       //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> InputBox()));
        //       //
        //       //       // Navigator.push(context, MaterialPageRoute(builder: (_) => InputBox()) );
        //       //     },
        //       //   ),),
        //
        //       GestureDetector(
        //         onTap: () {
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
        //                       TextSpan(text: 'Pitches \n',
        //                           style: popupMainText),
        //                       TextSpan(text: ''
        //                           '\nIn Western music, pitch refers to the highness or lowness of a sound.'
        //                           '\n\nPitches are the foundation of melodies (songs) and are structured into patterns known as scales, which make music sound pleasing and recognized.',
        //                         style: popupNormalText,),
        //                       TextSpan(text: '\n\nTo learn how this works select the \'Learn More\' option given below,',style: popupNoteText)
        //
        //
        //                     ],),),),
        //
        //                 actions: <Widget>[
        //
        //                   TextButton(
        //
        //                     onPressed: () {
        //                       PageCtrl = 1;
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
        //         },
        //         child: Container(
        //           key: _PitchSelector,
        //           margin: EdgeInsets.only(top: 20, bottom: 10),
        //           child: Column(
        //             children: [
        //
        //               Divider(height: 5,
        //                 thickness: 1.0,
        //                 indent: 30,
        //                 endIndent: 30,
        //                 color: lineColor,),
        //               Container(
        //                 alignment: Alignment.center,
        //                 margin: EdgeInsets.symmetric(horizontal: 50),
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     trans_info,
        //                     Text('Select the required note', style: TextStyle(
        //                       fontSize: 14,
        //                       fontFamily: 'NotoSansRegular',
        //                       fontWeight: FontWeight.normal,
        //                       color: subText,),),
        //                     coloured_info,
        //                   ],
        //                 ),),
        //               SizedBox(
        //                 height: 50.0, // Adjust the height as needed
        //                 child: ListView.builder(
        //                   scrollDirection: Axis.horizontal,
        //                   itemCount: Pitches.length,
        //                   itemBuilder: (BuildContext context, int index) {
        //                     return Container(
        //                       width: 60.0,
        //                       height: 50.0,
        //                       // Adjust the width as needed
        //                       margin: EdgeInsets.all(5.0),
        //                       //padding: EdgeInsets.all(8.0),
        //                       decoration: PitchSliderDeco,
        //                       child: ElevatedButton(
        //                         style: PitchSlider,
        //                         onPressed: () {
        //                           setPitch(Pitches[index]);
        //                           setRaagam(inputMap['notes'], western_swaras);
        //                         },
        //                         child: Text(Pitches[index], style: TextStyle(
        //                             fontFamily: 'NotoSansMid',
        //                             fontSize: 14,
        //                             fontWeight: FontWeight.normal),),
        //                       ),
        //                     );
        //                   },
        //                 ),
        //               ),
        //               Divider(height: 10, thickness: 2.0, color: lineColor,),
        //             ],),
        //         ),
        //       ),
        //       //Pitch Selector
        //
        //       Container(
        //         key: _mainButtons,
        //
        //         margin: EdgeInsets.only(top: 10.0),
        //         child: Row(children: [
        //           Container(margin: EdgeInsets.all(5),),
        //
        //           Expanded(
        //             child: SizedBox(
        //               height: 60,
        //               child: ElevatedButton(
        //                 style: mainButtons,
        //                 child: Text('Intervals', style: mainButtonTxt,),
        //                 onPressed: () {
        //                   Navigator.pushReplacement(context, MaterialPageRoute(
        //                       builder: (context) => IntPair()));
        //                 },
        //               ),
        //             ),
        //           ),
        //           Container(margin: EdgeInsets.all(5),),
        //
        //           Expanded(
        //             child: SizedBox(
        //               height: 60,
        //               child: ElevatedButton(
        //                 style: mainButtons,
        //                 child: Text('Chords', style: mainButtonTxt),
        //                 onPressed: () {
        //                   Navigator.pushReplacement(context, MaterialPageRoute(
        //                       builder: (context) => FamilyChds()));
        //                 },
        //               ),
        //             ),
        //           ),
        //           Container(margin: EdgeInsets.all(5),),
        //
        //         ],),),
        //       //Main Buttons
        //
        //       GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             FretBoardselected = !FretBoardselected;
        //           });
        //         },
        //         child: AnimatedContainer(
        //             margin: FretBoardselected ? EdgeInsets.symmetric(vertical: 50,horizontal: 0) : EdgeInsets.symmetric(
        //                 vertical: 20, horizontal: 60),
        //             padding: FretBoardselected ? EdgeInsets.all(0) : EdgeInsets
        //                 .symmetric(vertical: 10, horizontal: 0),
        //             color: FretBoardselected ? Colors.transparent : Colors.transparent,
        //             alignment: FretBoardselected
        //                 ? Alignment.center
        //                 : AlignmentDirectional.center,
        //             duration: const Duration(milliseconds: 1000),
        //             curve: Curves.fastOutSlowIn,
        //             child: FretBoardselected ? Container(
        //               //margin: EdgeInsets.only(top:10),
        //               padding: EdgeInsets.all(10),
        //               decoration: SwarasContainerDeco,
        //               child:
        //
        //               CustomPaint(
        //                 size: Size(screenWidth,screenHeight),
        //                 painter: PaintTest(),
        //               ),
        //
        //
        //             ) :
        //
        //             Center(
        //               child: Container(
        //
        //                   padding: EdgeInsets.symmetric(horizontal: 80,vertical: 12),
        //
        //
        //                   decoration: BoxDecoration(
        //                     boxShadow: [
        //                       BoxShadow(
        //                         color: Colors.grey.withOpacity(0.2),
        //                         spreadRadius: 2,
        //                         blurRadius: 5,
        //                         offset: Offset(0, 5), // changes position of shadow
        //                       ),
        //                     ],
        //                     border: Border.all(width: 1, color: Colors.brown,),
        //                     borderRadius: BorderRadius.circular(10.0),
        //                     color: SwaraContainerBG,),
        //                   child: Text('Fretboard',style: TextStyle(fontSize: 18,color: Color.fromRGBO(11,111,244,1),fontWeight: FontWeight.w500),)
        //
        //
        //               ),
        //             )),
        //       ),
        //       //FretBoards
        //
        //       GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             selected = !selected;
        //           });
        //         },
        //         child: AnimatedContainer(
        //             margin: selected ? EdgeInsets.symmetric(vertical: 50,horizontal: 0) : EdgeInsets.symmetric(
        //                 vertical: 0, horizontal: 120),
        //             padding: selected ? EdgeInsets.all(0) : EdgeInsets
        //                 .symmetric(vertical: 10, horizontal: 0),
        //             color: selected ? Colors.transparent : Colors.transparent,
        //             alignment: selected
        //                 ? Alignment.center
        //                 : AlignmentDirectional.center,
        //             duration: const Duration(milliseconds: 1000),
        //             curve: Curves.fastOutSlowIn,
        //             child: selected ? Container(
        //               //margin: EdgeInsets.only(top:10),
        //               padding: EdgeInsets.all(10),
        //               decoration: SwarasContainerDeco,
        //               child:
        //
        //
        //               RichText(text:
        //               TextSpan(
        //                 children: <TextSpan>[
        //
        //                   TextSpan(text: 'Guitar Raag,',
        //                       style: popupMainText),
        //
        //                   TextSpan(text: ' find chords, learn theory and play music.\n\nWelcome to Guitar Raag, the go-to resource for ',style: about_Cont_text),
        //                   TextSpan(text: 'learning and calculating ',style: about_Cont_text.copyWith(color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.w500)),
        //                   TextSpan(text:'Family of Chords. \n\nWhether you\'re writing, practicing, or simply wondering about how chords operate within Melakarta Raagas, this application will help you identify',style: about_Cont_text),
        //                   TextSpan(text: ' Family of chords for melakarta raagas',style: about_Cont_text.copyWith(color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.w500)),
        //                   TextSpan(text:' in seconds and learn the concepts behind it as well.',style: about_Cont_text,),
        //                   TextSpan(text:'\n\nThis app is free for everyone and it was created as an ',style: about_Cont_text,),
        //                   TextSpan(text: ' open-source project ',style: about_Cont_text.copyWith(color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.w500)),
        //                   TextSpan(text:'( the source code of the project is available for everyone at the GitHub repository); you are welcome to help improve it.'
        //                       ,style:  about_Cont_text),
        //
        //                   TextSpan(
        //                       text: 'is primarily designed to ascertain the precise musical chords for any Heptatonic Musical Scale or Carnatic Melakarta Raagam using musical intervals. '
        //                           '\n\nThe Family of chords feature enables users to accompany real-time songs, and'
        //                           ' it facilitates song composition without incorporating accidental notes or swaras.',
        //                       style: about_Cont_text),
        //                   // TextSpan(text: ' expected to know',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'NotoSansMid',fontSize: 15,color: Color.fromRGBO(11, 111, 244, 1))),
        //                   // TextSpan(text: ' concepts such as,\n\n\t\t\tWestern Music Theory\n\t\t\tCarnatic Music Theory\n\t\t\tIntervals\n\t\t\tChords',style: TextStyle(fontSize: 15, fontFamily: 'NotoSansMid'),),
        //
        //
        //                   TextSpan(text: '\n\nInspirations ', style: popupMainText.copyWith(height: 1)),
        //                   TextSpan(text: '\n\nFor the development of this app, there i derived inspirations from various existing Applications'
        //                       '. The primary aim is to make trans_info system that is better or different than the existing, '
        //                       'however the existing always serves trans_info special place in the music community, some of these apps are',
        //                       style:about_Cont_text),
        //                   TextSpan(
        //                       text: '\n\n\t\t\tCarnatic Raaga\n\t\t\tIan Ring\n\t\t\tGuitar Tuna\n\t\t\tTambura Droid',
        //                       style: about_Cont_text.copyWith(color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.w500,height: 1.5)),
        //
        //
        //                 ],),),
        //
        //             ) :
        //
        //             Center(
        //               child: Container(
        //
        //                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        //                   decoration: BoxDecoration(
        //                     boxShadow: [
        //                       BoxShadow(
        //                         color: Colors.grey.withOpacity(0.2),
        //                         spreadRadius: 2,
        //                         blurRadius: 5,
        //                         offset: Offset(0, 5), // changes position of shadow
        //                       ),
        //                     ],
        //                     border: Border.all(width: 0.5, color: Color.fromRGBO(46, 46, 46, 1),),
        //                     borderRadius: BorderRadius.circular(30.0),
        //                     color: SwaraContainerBG,),
        //                   child: Text('About')
        //
        //
        //
        //
        //
        //
        //               ),
        //             )),
        //       ),
        //       //About
        //
        //
        //
        //       //
        //       // ElevatedButton(onPressed: (){   tutorialState(true);
        //       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));
        //       //   }, child: Text('HITT')),
        //       Container(margin: EdgeInsets.all(20),),
        //     ],
        //   ),
        // )
      ),
    );
  }
  void _createTutorial() {
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
        identify: 'Title',
        keyTarget: _title,
        //alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align:ContentAlign.bottom,
            builder:(context,controller)=>
                Container(
                  padding: padding_TargetContainer,
                  decoration: boxDecoration_TargetContainer,
                  child: RichText(text:
                  TextSpan(text: 'Welcome..!',style: HeadingTextStyle,children: <TextSpan>[
                    TextSpan(text: '\n\n',style: normalTextStyle),
                    TextSpan(text: 'The GUITAR RAAG App was developed to help musicians or composers to find the, ',style: normalTextStyle),
                    TextSpan(text: 'Family of chords for melakarta raagas.',style: ImportantNormal),

                    TextSpan(text: '\n\nThis app helps Musicians from both',style: normalTextStyle),
                    TextSpan(text: ' Carnatic and Western ',style: ImportantNormal),
                    TextSpan(text: 'music traditions communicate music theory very easily.',style: normalTextStyle),


                    TextSpan(text: '\n\nIn other words this app strives to act like a ',style: normalTextStyle),
                    TextSpan(text: ' bridge ',style: ImportantNormal),
                    TextSpan(text: 'between both the worlds..!',style: normalTextStyle),


                    TextSpan(text: '\n\n\nIf you do not know any music theory, don\'t worry, the app helps you learn music theory as well..!',style: normalTextStyle),


                  ],),),
                )


          ),
        ],
      ),
           // Guitar Raag

      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'Raaga Name Input',
        keyTarget: _CurrentRaag,
        //alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align:ContentAlign.bottom,
              builder:(context,controller)=>
                  Container(
                    padding: padding_TargetContainer,
                    decoration: boxDecoration_TargetContainer,
                    child: RichText(text:
                    TextSpan(text: 'Input',style: HeadingTextStyle,children: <TextSpan>[
                      TextSpan(text: '\n\nUser input is important for an interactive application..! In this app you are expected to select the melakarta raagas for which you want to find Family of chords.',style: normalTextStyle),
                      TextSpan(text: '\n\nThis white box allows you to select the raaga by either selecting',style: normalTextStyle),
                      TextSpan(text: ' Raaga Names',style: ImportantNormal),
                      TextSpan(text: ', from the search bar or by selecting the ',style: normalTextStyle),
                      TextSpan(text: ' Swaras of the Raaga.',style: ImportantNormal),

                      TextSpan(text: '\n\nThe box also',style: normalTextStyle),
                      TextSpan(text: ' shows the name of the raaga that is currently selected ',style: ImportantNormal),
                      TextSpan(text: 'for calculation, by default Keeravani is selected as the current raaga.',style: normalTextStyle),

                    ],),),
                  )


          ),
        ],
      ),
      //Raag Input


      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'SwaraInput',
        keyTarget: _CarnaticSwaras,
        //alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align:ContentAlign.bottom,
              builder:(context,controller)=>
                  Container(
                    padding: padding_TargetContainer,
                    decoration: boxDecoration_TargetContainer,
                    child: RichText(text:
                    TextSpan(text: 'Carnatic Swaras',style: HeadingTextStyle,children: <TextSpan>[
                      TextSpan(text: '\n\nThis box shows the swaras of the selected raaga in carnatic nomenclature.',style: normalTextStyle),
                    ],),),
                  )

          ),
        ],
      ),
      //Swaras Box


      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'Western Note',
        keyTarget: _WesternNotes,
        // alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align:ContentAlign.top,
              builder:(context,controller)=>
                  Container(
                    padding: padding_TargetContainer,
                    decoration: boxDecoration_TargetContainer,
                    child: RichText(text:
                    TextSpan(text: 'Western Notes',style: HeadingTextStyle,children: <TextSpan>[

                            TextSpan(text: '\n\nThis box shows the scale notes that are equivalent of the selected raaga in western nomenclature.',style: normalTextStyle),
                            TextSpan(text: '\n\nThe scale is also changes when the pitch is adjusted below.!',style: normalTextStyle),

                    ],),),
                  )


          ),
        ],
      ),
      //Western Notes

      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'PitchSelector',
        keyTarget: _PitchSelector,
        // alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,

        contents: [
          TargetContent(
            align:ContentAlign.top,

            builder:(context,controller)=>
                Container(
                  decoration: boxDecoration_TargetContainer,
                  padding: padding_TargetContainer,
                  child: RichText(text:
                  TextSpan(text: 'Selecting the Pitch for the Raaga',style: HeadingTextStyle,children: <TextSpan>[
                                  TextSpan(text: '\n\nThis is a horizontal Slider, which contains all the 12 Pitches and users can just ',style: normalTextStyle),
                                  TextSpan(text: 'Tap on the Ellipses ',style: ImportantNormal),
                                  TextSpan(text: 'To set that pitch respectively. \n\nThe changes are updated above, for users to verify the change of Pitch.',style: normalTextStyle),

                  ],),),
                ),
          ),
        ],
      ),
      //Pitches

      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'Main Buttons',
        keyTarget: _mainButtons,
        // alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align:ContentAlign.top,
              builder:(context,controller)=>
                  Container(
                    decoration: boxDecoration_TargetContainer,
                    padding: padding_TargetContainer,
                    child: RichText(text:
                    TextSpan(text: 'The Main Buttons',style: HeadingTextStyle,children: <TextSpan>[
                                    TextSpan(text: '\n\nThese are the core functionality of the app, both of these buttons have unique purposes',style: normalTextStyle),
                                    TextSpan(text: '\n\nINTERVALS',style: ImportantNormal),
                                    TextSpan(text: ' : Take you to a page where you can find ',style: normalTextStyle),
                                    TextSpan(text: 'all possible interval combinations ',style: ImportantNormal),
                                    TextSpan(text: 'from the selected Raaga..!',style: normalTextStyle),
                                    TextSpan(text: '\n\nCHORDS',style: ImportantNormal),
                                    TextSpan(text: ' : This button directs you to a page where you can find the ',style: normalTextStyle),
                                    TextSpan(text: 'Family of chords ',style: ImportantNormal),
                                    TextSpan(text: 'of the selected Raaga..!',style: normalTextStyle),
                    ],),),
                  )


          ),
        ],
      ),
      //Main Buttons
    ];


    final tutorial = TutorialCoachMark(
      targets: targets,
      //hideSkip: true,
      opacityShadow: 0.93,

        paddingFocus: 10,
        focusAnimationDuration: Duration(milliseconds: 300),
        unFocusAnimationDuration: Duration(milliseconds: 300),
        pulseAnimationDuration: Duration(milliseconds: 300),


    );



  Future.delayed(const Duration(milliseconds: 100),(){
      tutorial.show(context: context);
    });

    tutorialVble=false;  }
  void _createTutorialModalBottom() {
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
        identify: 'Raaga Input Screen',
        keyTarget: _CurrentRaagScreen,
        //alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align:ContentAlign.top,
              builder:(context,controller)=>
                  Container(
                    decoration: boxDecoration_TargetContainer,
                    padding: padding_TargetContainer,
                    child: RichText(text:
                    TextSpan(text: 'Melakarta Raagas',style: HeadingTextStyle,children: <TextSpan>[
                      TextSpan(text: '\n\nThis screen contains all the 72 MelaKarta Raagas in ascending order, Each page displays only six raagas per screen..!',style:normalTextStyle),
                      TextSpan(text:'\n\nThese Raagas are divided based on',style:normalTextStyle),
                      TextSpan(text: ' Raaga Chakras..!',style: ImportantNormal),
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
        identify: 'Raaga Input',
        keyTarget: _CurrentRaagChakraScreen,
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
                    TextSpan(text: 'Raaga Chakras..!',style: HeadingTextStyle,children: <TextSpan>[
                      TextSpan(text: '\n\nThis portion displays all the 12 chakras as Buttons.',style:normalTextStyle),
                      TextSpan(text: '\nTapping a button ',style: ImportantNormal),
                      TextSpan(text:'will display that chakra, from there you can select your Raaga',style:normalTextStyle),

                    ],),),
                  )


          ),
        ],
      ),
      //Raag Input Screen 2


    ];
    final tutorial = TutorialCoachMark(
      targets: targets,
       hideSkip: true,
      opacityShadow: 0.93,
      paddingFocus: 10,
      focusAnimationDuration: Duration(milliseconds: 300),
      unFocusAnimationDuration: Duration(milliseconds: 300),
      pulseAnimationDuration: Duration(milliseconds: 300),

    );
    Future.delayed(const Duration(milliseconds: 500),(){
    tutorial.show(context: context);});
    tutorialModalVble=false;}
}


class Prefrences extends StatefulWidget {
  Prefrences({super.key});

  @override
  State<Prefrences> createState() => _Prefrences();
}
class _Prefrences extends State<Prefrences> {

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


    var screen2_box_title =  TextStyle( color: Color.fromRGBO(11, 111, 244,1),fontSize: 20,fontFamily: 'NotoSansMid',);
    var screen2_box_text =   TextStyle( color: Colors.black, fontSize: 14, fontFamily: 'NotoSans',fontWeight: FontWeight.w500,);

    return WillPopScope(
        onWillPop:  () async {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));
          return true; // Prevent back navigation
        },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,),
            onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));},),
          backgroundColor: Colors.transparent,
          title: Text('Prefrences',style: TextStyle(color: Color.fromRGBO(11, 111, 244, 1),fontFamily: 'NotoSansMid',fontSize: 26),),
          ),

        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            children: [
              Container(margin: EdgeInsets.symmetric(vertical: 70),),

              GestureDetector(
                onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> MainApp(showHome: false)));},
                child: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(241,243,244, 1),),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Icon(Icons.logout,color: Color.fromRGBO(11, 111, 244, 1),),
                      Container(margin: EdgeInsets.all(5),),
                      Text('Redirect to Onboarding Screen',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
                    ],
                  ),
                ),
              ),
              Divider(height: 15,thickness: 0,),

              GestureDetector(
                onTap: (){
                  PageCtrl = 0;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> TheoryContent()));},
                child: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(241,243,244, 1),),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),child: Row(
                    children: [
                      Icon(Icons.school_outlined,color: Color.fromRGBO(11, 111, 244, 1),),
                      // Container(margin: EdgeInsets.all(5),),
                      // Text('Learn Theory',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
                    ],
                  ),
                ),
              ),

              Divider(height: 15,thickness: 0,),



              GestureDetector(
                onTap: (){
                  tutorialState(true);
                  tutorialModalState(true);
                  tutorialInputState(true);

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));
                },
                child: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(241,243,244, 1),),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                  children: [
                    Icon(Icons.tips_and_updates_outlined,color: Color.fromRGBO(11, 111, 244, 1),),
                    Container(margin: EdgeInsets.all(5),),
                    Text('Show Tutorials',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
                  ],
                ),
                ),
              ),

              Text('Settings will also be updated over time, stay updated..!\n\nVersion 1.0',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10),),
              Divider(thickness: 2,),
            ],
          ),

        ),


      ),
    );
  }
}